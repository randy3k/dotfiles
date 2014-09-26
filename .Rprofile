.First = function(){
    options(
        repos = c(CRAN = "http://cran.rstudio.com/"),
        browserNLdisabled = TRUE,
        deparse.max.lines = 2,
        help_type="html",
        max.print=1000)


    installed = function(pkg){
        pkg %in% rownames(utils::installed.packages())
    }
    install = function(pkg, github=FALSE){
        if (Sys.getenv("R_INSTALLING_PACKAGES")==""){
            Sys.setenv(R_INSTALLING_PACKAGES=TRUE)
            library(stats)
            library(utils)
            if (github){
                devtools::install_github(pkg)
            }else{
                install.packages(pkg)
            }
            Sys.unsetenv("R_INSTALLING_PACKAGES")
        }
    }

    if (interactive()) {
        # mac only
        options(device='quartz')
        setHook(packageEvent("grDevices", "onLoad"),
                function(...) grDevices::quartz.options(width = 5, height = 5))

        package_list = c(
            "Rcpp",
            "RcppArmadillo",
            "doParallel",
            "ggplot2",
            "dplyr",
            "reshape2",
            "abind",
            "knitr",
            "roxygen2"
            )
        for (pkg in package_list){
            if (!installed(pkg)) install(pkg)
        }
        if (!installed("devtools")) install("devtools")
        if (!installed("colorout")) install("jalvesaq/colorout", github=TRUE)

        if (installed("colorout") && .Platform$GUI == "X11" && Sys.getenv("RSTUDIO")==""){
            colorout::setOutputColors256(normal = 4, number = 4, negnum = 5,
                               string = 2, const = 6, stderror = 3,
                               warn = 3, error= 1, verbose=FALSE)
        }
    }
}
