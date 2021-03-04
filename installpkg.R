options(repos = c(CRAN = "https://cloud.r-project.org/"))
install.packages("devtools")
devtools::install_github("nlmixrdevelopment/RxODE", dependencies=TRUE, update=TRUE)
devtools::install_github("nlmixrdevelopment/nlmixr", dependencies=TRUE, update=TRUE)
