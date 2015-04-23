.First <- function(){
    options(
        repos = c(CRAN = "http://cran.rstudio.com/"),
        browserNLdisabled = TRUE,
        deparse.max.lines = 2,
        help_type="html",
        max.print=200)

    installed <- function(pkg){
        pkg %in% rownames(utils::installed.packages())
    }
    install <- function(pkg, github=FALSE){
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

        package_list <- c(
            "Rcpp",
            "RcppArmadillo",
            "doParallel",
            "ggplot2",
            "dplyr",
            "reshape2",
            "abind",
            "knitr",
            "roxygen2",
            "rex",
            "numDeriv",
            "partitions",
            "lme4",
            "lintr",
            "lars",
            "fields",
            "fda",
            "data.table",
            "glmnet",
            "caret",
            "devtools"
            )
        # for (pkg in package_list){
        #     if (!installed(pkg)) install(pkg)
        # }
    }

}
