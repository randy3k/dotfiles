options(
    repos = c(CRAN = "https://cran.rstudio.com"),
    # browserNLdisabled = TRUE,
    # deparse.max.lines = 2,
    max.print = 200,
    rtichoke.color_scheme = "native",
    rtichoke.history_search_no_duplicates = TRUE,
    rtichoke.auto_match = TRUE
    # rtichoke.insert_new_line = FALSE
    # rtichoke.auto_match.auto_indentation = FALSE
    # rtichoke.complete_while_typing = TRUE
)

options(testthat.default_reporter = if (isatty(stdout())) "progress" else "summary")

try({
    options(languageserver.default_linters = lintr::with_defaults(
        line_length_linter = lintr::line_length_linter(100),
        object_usage_linter = NULL,
        object_length_linter = NULL,
        object_name_linter = NULL,
        commented_code_linter = NULL
    ))
}, silent = TRUE)


# mac only
if (Sys.info()["sysname"] == "Darwin"){
    if (interactive()) {
        Sys.setenv(TZ = "America/New_York")
        options(
            device = "quartz",
            help_type = "html",
            editor = "'subl -w'"
        )
        setHook(packageEvent("grDevices", "onLoad"),
                function(...) grDevices::quartz.options(
                    width = 5,
                    height = 5,
                    pointsize = 8
                ))
    } else {
        options(
            repr.plot.width = 5,
            repr.plot.height = 5,
            repr.plot.res = 100,
            jupyter.plot_mimetypes = "image/png"
        )
    }
}
