#' install
#'
#' @param token token
#'
#' @return install
#' @export
#'
install_nhanesR <- function(token){
    e <- tryCatch(detach("package:nhanesR", unload = TRUE),error=function(e) 'e')
    # check
    (td <- tempdir(check = TRUE))
    td2 <- '1'
    while(td2 %in% list.files(path = td)){
        td2 <- as.character(as.numeric(td2)+1)
    }
    (dest <- paste0(td,'/',td2))
    do::formal_dir(dest)
    dir.create(path = dest,recursive = TRUE,showWarnings = FALSE)
    (tf <- paste0(dest,'/nhanesR.zip'))

    if (do::is.windows()){
        download.file(url = 'https://codeload.github.com/yikeshu0611/nhanesR_win/zip/refs/heads/main',
                      destfile = tf,
                      mode='wb',
                      headers = c(NULL,Authorization = sprintf("token %s",token)))
        unzip(zipfile = tf,exdir = dest,overwrite = TRUE)
    }else{
        download.file(url = 'https://codeload.github.com/yikeshu0611/nhanesR_mac/zip/refs/heads/main',
                      destfile = tf,
                      mode='wb',
                      headers = c(NULL,Authorization = sprintf("token %s",token)))
        unzip(zipfile = tf,exdir = dest,overwrite = TRUE)
    }



    if (do::is.windows()){
        main <- paste0(dest,'/nhanesR_win-main')
        (nhanesR <- list.files(main,'nhanesR_',full.names = TRUE))
        (nhanesR <- nhanesR[do::right(nhanesR,3)=='zip'])
        (k <- do::Replace0(nhanesR,'.*nhanesR_','\\.zip','\\.tgz','\\.') |> as.numeric() |> which.max())
        unzip(nhanesR[k],files = 'nhanesR/DESCRIPTION',exdir = main)
    }else{
        main <- paste0(dest,'/nhanesR_mac-main')
        nhanesR <- list.files(main,'nhanesR_',full.names = TRUE)
        nhanesR <- nhanesR[do::right(nhanesR,3)=='tgz']
        k <- do::Replace0(nhanesR,'.*nhanesR_','\\.zip','\\.tgz','\\.') |> as.numeric() |> which.max()
        untar(nhanesR[k],files = 'nhanesR/DESCRIPTION',exdir = main)
    }

    (desc <- paste0(main,'/nhanesR'))
    check_package(desc)

    install.packages(pkgs = nhanesR[k],repos = NULL,quiet = FALSE)
    message('Done(nhanesR)')
    x <- suppressWarnings(file.remove(list.files(dest,recursive = TRUE,full.names = TRUE)))
    invisible()
}


