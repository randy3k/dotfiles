options(
    repos = c(CRAN = "https://cran.rstudio.com"),
    useFancyQuotes = FALSE,
    browserNLdisabled = TRUE,
    max.print = 200,
    languageserver.snippet_support = FALSE,
    languageserver.server_capabilities = list(
        documentHighlightProvider = FALSE
    )
)
Sys.setenv(TZ = "US/Pacific")
Sys.setenv(R_LANGSVR_LOG = "/tmp/languageserver.log")
# options(testthat.default_reporter = if (isatty(stdout())) "progress" else "summary")


# mac only
if (Sys.info()["sysname"] == "Darwin") {
    if (interactive()) {
        options(
            help_type = "html",
            editor = "sublimetext"
        )
        setHook(packageEvent("grDevices", "onLoad"),
                function(...) grDevices::quartz.options(
                    width = 5,
                    height = 5,
                    pointsize = 8
                ))
        try(Sys.setenv(GITHUB_PAT=system2(
                "bash", c("-lc", "'echo $GITHUB_PAT'"), stdout = TRUE)), silent = TRUE)
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
