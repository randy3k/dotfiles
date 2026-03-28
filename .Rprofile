# --- Startup & Shutdown Hooks ---
.First <- function() {
    if (interactive()) {
        tryCatch(utils::loadhistory("~/.Rhistory"), error = \(e) NULL)
    }
}

.Last <- function() {
    if (interactive()) {
        tryCatch(utils::savehistory("~/.Rhistory"), error = \(e) NULL)
    }
}

# --- Global Options ---
options(
    repos = c(CRAN = "https://cran.rstudio.com"),
    useFancyQuotes = FALSE,
    browserNLdisabled = TRUE,
    max.print = 200,
    help_type = "html",
    usethis.protocol = "ssh"
)

# --- Package-Specific Settings ---
options(
    languageserver.snippet_support = FALSE,
    languageserver.server_capabilities = list(
        documentHighlightProvider = FALSE
    ),
    languageserver.rich_documentation = FALSE
)

# --- Environment Settings ---
Sys.setenv(TZ = "US/Pacific")

# --- OS & Environment Specifics ---
local({
    sysname <- Sys.info()["sysname"]
    is_interactive <- interactive()

    if (sysname == "Darwin") {
        if (is_interactive) {
            # macOS Quartz settings
            setHook(
                packageEvent("grDevices", "onLoad"),
                function(...) {
                    grDevices::quartz.options(width = 5, height = 5, pointsize = 8)
                }
            )

            # RStudio-specific hacks
            if (Sys.getenv("RSTUDIO") == "1") {
                # Inherit shell's environment variables
                try({
                    tf <- tempfile("env")
                    writeLines(system2(c("bash", "-lc", "printenv"), stdout = TRUE), tf)
                    readRenviron(tf)
                    unlink(tf)
                }, silent = TRUE)

                # Disable RStudio's intrusive options hijacking in desktop mode
                if (Sys.getenv("RSTUDIO_PROGRAM_MODE", "desktop") == "desktop") {
                    unlockBinding("options", asNamespace("base"))
                    old_options <- options
                    new_options <- function(...) {
                        args <- list(...)
                        if ("browser" %in% names(args)) {
                            unlockBinding("options", asNamespace("base"))
                            assign("options", old_options, inherits = TRUE)
                            unlockBinding("options", asNamespace("base"))
                        } else {
                            do.call(old_options, args)
                        }
                    }
                    assign("options", new_options, inherits = TRUE)
                    unlockBinding("options", asNamespace("base"))
                }
            }
        } else {
            # Non-interactive settings (e.g., Jupyter)
            options(
                # repr.plot.width = 5,
                # repr.plot.height = 5,
                # repr.plot.res = 100,
                repr.matrix.max.rows = 20,
                jupyter.plot_mimetypes = "image/png"
                # jupyter.rich_display = FALSE
            )
        }
    }
})

# --- Local Profile ---
if (file.exists("~/.Rprofile.local")) {
    source("~/.Rprofile.local")
}
