#' install
#'
#' @param token token
#'
#' @return install
#' @export
#'
install_chnsR <- function(token){
    e <- tryCatch(detach("package:chnsR", unload = TRUE),error=function(e) 'e')
    # check
    (td <- tempdir(check = TRUE))
    td2 <- '1'
    while(td2 %in% list.files(path = td)){
        td2 <- as.character(as.numeric(td2)+1)
    }
    (dest <- paste0(td,'/',td2))
    do::formal_dir(dest)
    dir.create(path = dest,recursive = TRUE,showWarnings = FALSE)
    (tf <- paste0(dest,'/chnsR.zip'))

    download.file(url = 'https://codeload.github.com/yikeshu0611/chnsR/zip/refs/heads/main',
                  destfile = tf,
                  mode='wb',
                  headers = c(NULL,Authorization = sprintf("token %s",token)))
    unzip(zipfile = tf,exdir = dest,overwrite = TRUE)

    main <- paste0(dest,'/chnsR-main')
    if (do::is.windows()){
        chnsR <- list.files(main,'chnsR_',full.names = TRUE)
        chnsR <- chnsR[do::right(chnsR,3)=='zip']
        k <- do::Replace0(chnsR,'.*chnsR_','\\.zip','\\.tgz','\\.') |> as.numeric() |> which.max()
        unzip(chnsR[k],files = 'chnsR/DESCRIPTION',exdir = main)

    }else{
        chnsR <- list.files(main,'chnsR_',full.names = TRUE)
        chnsR <- chnsR[do::right(chnsR,3)=='tgz']
        k <- do::Replace0(chnsR,'.*chnsR_','\\.zip','\\.tgz','\\.') |> as.numeric() |> which.max()
        untar(chnsR[k],files = 'chnsR/DESCRIPTION',exdir = main)

    }

    desc <- paste0(main,'/chnsR')
    check_package(desc)

    install.packages(pkgs = chnsR[k],repos = NULL,quiet = FALSE)
    message('Done(chnsR)')
    x <- suppressWarnings(file.remove(list.files(dest,recursive = TRUE,full.names = TRUE)))
    invisible()
}


