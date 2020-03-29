options(
    repos = c(CRAN = "https://cran.rstudio.com"),
    useFancyQuotes = FALSE,
    browserNLdisabled = TRUE,
    max.print = 100,
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
        # setHook(packageEvent("grDevices", "onLoad"),
        #         function(...) grDevices::quartz.options(
        #             width = 5,
        #             height = 5,
        #             pointsize = 8,
        #             dpi = NA_real_
        #         ))
    } else {
        options(
            # repr.plot.width = 5,
            # repr.plot.height = 5,
            # repr.plot.res = 100,
            repr.matrix.max.rows = 20,
            jupyter.plot_mimetypes = "image/png"
            # jupyter.rich_display = FALSE
        )
        # setHook(
        #     packageEvent("IRkernel", "onLoad"),
        #     function(...) {
        #         repr_text <- function(obj, ...)
        #             paste0("<pre>", paste0(utils::capture.output(obj), collapse = "\n"), "</pre>")
        #         evalq(local({
        #                 registerS3method("repr_html", "integer", repr_text)
        #                 registerS3method("repr_html", "double", repr_text)
        #                 registerS3method("repr_html", "character", repr_text)
        #             }),
        #             envir = getNamespace("repr")
        #         )
        #     }
        # )
    }
}

# options(radian.on_load_hooks = list(function() {
#     getOption("rchitect.py_tools")$attach()

#     radian <- import("radian")
#     prompt_toolkit <- import("prompt_toolkit")

#     KeyPress <- prompt_toolkit$key_binding$key_processor$KeyPress
#     Keys <- prompt_toolkit$keys$Keys

#     insert_mode <- radian$key_bindings$insert_mode
#     app <- radian$get_app()
#     kb <- app$session$modes$r$prompt_key_bindings

#     kb$add("j", "j", filter = insert_mode)(function(event) {
#         event$app$key_processor$feed(KeyPress(Keys$Escape))
#     })
# }))
