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

# if (interactive()) {
#     tag_release <- function(pkg = ".") {
#         pkg <- devtools:::as.package(pkg)
#         release_file <- file.path(pkg$path, "CRAN-RELEASE")
#         if (!file.exists(release_file)) {
#             cat("CRAN-RELEASE file not found\n")
#             return(invisible())
#         }
#         line <- readLines(release_file)[2]
#         match <- regexec("commit ([a-z0-9]+)", line)
#         sha <- regmatches(line, match)[[1]][2]
#         if (is.na(sha)) {
#             cat("Cannot parse CRAN-RELEASE\n")
#             return(invisible())
#         }
#         semver <- stringr::str_extract(paste0("v", pkg$version), "v[0-9]+\\.[0-9]+\\.[0-9]+")[[1]]
#         if (devtools:::yesno(glue::glue("tag {sha} as {semver}"))) {
#             return(invisible())
#         }
#         tag_sha <- gert::git_tag_create(semver, message = semver, ref = sha, repo = pkg$path)
#         file.remove(release_file)
#         invisible(tag_sha)
#     }
# }


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
