#' xinjiang
#'
#' @return package
#' @export
#'
install_nhanesR.xinjiang <- function () {
    e <- tryCatch(detach("package:nhanesR", unload = TRUE),error=function(e) 'e')
    url='https://gitee.com/yikeshu0611/nhanes-r.git'

    (td <- tempdir(check = TRUE))
    td2 <- '1'
    while(td2 %in% list.files(path = td)){
        td2 <- as.character(as.numeric(td2)+1)
    }
    (buddle <- paste0(td,'/',td2))
    dir.create(path = buddle,recursive = TRUE,showWarnings = FALSE)
    (file <- tempfile(tmpdir = td,pattern = paste0(td2,'-------')) |> do::Replace0('-----.*'))

    message("Downloading git repo ", url)
    args <- c("clone", "--depth", "1", "--no-hardlinks")
    args <- c(args,  url, file)
    x <- remotes:::git(paste0(args, collapse = " "), quiet = TRUE)
    nhanesR <- list.files(buddle,'nhanesR_',full.names = TRUE)
    k <- do::Replace0(nhanesR,'.*nhanesR_','.zip','\\.') |> as.numeric() |> which.max()
    unzip(nhanesR[k],files = 'nhanesR/DESCRIPTION',exdir = buddle)
    pkg <- paste0(buddle,'/nhanesR')
    check_package(pkg)
    install.packages(nhanesR[k],repos = NULL)
    file.remove(list.files(buddle,full.names = TRUE,recursive = TRUE))
    invisible()
}
