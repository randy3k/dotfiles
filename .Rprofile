options(
    repos = c(CRAN = "https://cran.rstudio.com"),
    useFancyQuotes = FALSE,
    browserNLdisabled = TRUE,
    max.print = 200,
    languageserver.snippet_support = FALSE,
    languageserver.server_capabilities = list(
        documentHighlightProvider = FALSE
    ),
    languageserver.rich_documentation = FALSE
)
options(usethis.protocol = "ssh")

Sys.setenv(TZ = "US/Pacific")
# options(testthat.default_reporter = if (isatty(stdout())) "progress" else "summary")


# mac only
if (Sys.info()["sysname"] == "Darwin") {
    Sys.setenv(R_LANGSVR_LOG = "/tmp/languageserver.log")

    if (interactive()) {

        # if (!startsWith(R.home(""), "/Library/Frameworks/R.framework")) {
        #     local({
        #         paths <- .libPaths()
        #         .libPaths(paths[!startsWith(paths, normalizePath("~"))])
        #     })
        # }

        options(
            help_type = "html"
            # editor = "sublimetext"
        )
        setHook(
            packageEvent("grDevices", "onLoad"),
            function(...) {
                grDevices::quartz.options(
                    width = 5,
                    height = 5,
                    pointsize = 8
                )
            }
        )
        if (Sys.getenv("RSTUDIO") == "1") {
            local({
                # inhert shell's environmental variables
                tf <- tempfile("env")
                writeLines(system2(c("bash", "-lc", "printenv"), stdout = TRUE), tf)
                on.exit(unlink(tf))
                readRenviron(tf)

                # to disable RStudio's debug mode
                if (Sys.getenv("RSTUDIO_PROGRAM_MODE", "desktop") == "desktop") {
                    unlockBinding("options", asNamespace("base"))
                    old_options <- options
                    new_options <- function(...) {
                        args <- list(...)
                        nms <- names(args)
                        if ("browser" %in% nms) {
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
            })
        }
    } else {
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
