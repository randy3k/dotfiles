options(
    repos = c(CRAN = "https://cran.rstudio.com"),
    browserNLdisabled = TRUE,
    deparse.max.lines = 2,
    max.print = 200,
    rice.color_scheme = "native"
    # rice.auto_indentation = FALSE
    # rice.complete_while_typing = FALSE
)

utils::rc.settings(ipck=TRUE)


# mac only
if (Sys.info()["sysname"] == "Darwin"){
    if (interactive()) {
        Sys.setenv(TZ = "America/New_York")
        try(suppressPackageStartupMessages(library(prettycode)), silent = TRUE)
        options(
            device = "quartz",
            help_type = "html"
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
