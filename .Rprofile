options(
    repos = c(CRAN = "https://cran.rstudio.com"),
    # browserNLdisabled = TRUE,
    # deparse.max.lines = 2,
    max.print = 200,
    radian.color_scheme = "native",
    radian.history_search_no_duplicates = TRUE,
    radian.auto_match = TRUE,
    radian.indent_lines = FALSE
    # radian.insert_new_line = FALSE
    # radian.auto_match.auto_indentation = FALSE
    # radian.complete_while_typing = FALSE
)

options(testthat.default_reporter = if (isatty(stdout())) "progress" else "summary")


# setHook(
#     packageEvent("languageserver", "onLoad"),
#     function(...) {
#         options(languageserver.default_linters = lintr::with_defaults(
#             line_length_linter = lintr::line_length_linter(100),
#             object_usage_linter = NULL,
#             object_length_linter = NULL,
#             object_name_linter = NULL,
#             commented_code_linter = NULL
#         ))
#     }
# )


# mac only
if (Sys.info()["sysname"] == "Darwin"){
    if (interactive()) {
        Sys.setenv(TZ = "America/New_York")
        options(
            device = "quartz",
            help_type = "html",
            editor = "sublimetext"
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
