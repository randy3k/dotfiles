options(
    repos = c(CRAN = "https://cran.rstudio.com"),
    useFancyQuotes = FALSE,
    # browserNLdisabled = TRUE,
    # deparse.max.lines = 2,
    max.print = 200,
    radian.color_scheme = "native",
    radian.history_search_no_duplicates = TRUE,
    radian.auto_match = TRUE
    # radian.indent_lines = FALSE
    # radian.insert_new_line = FALSE
    # radian.auto_match.auto_indentation = FALSE
    # radian.complete_while_typing = FALSE
)

options(radian.escape_key_map = list(
    list(key = "-", value = " <- "),
    list(key = "m", value = " %>% ")
))

options(testthat.default_reporter = if (isatty(stdout())) "progress" else "summary")


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
