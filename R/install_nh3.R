#' install
#'
#' @param token token
#'
#' @return install
#' @export
#'
install_nh3 <- function(token){
    options(timeout = 300)
    e <- tryCatch(detach("package:nh3", unload = TRUE),error=function(e) 'e')
    # check
    (td <- tempdir(check = TRUE))
    td2 <- '1'
    while(td2 %in% list.files(path = td)){
        td2 <- as.character(as.numeric(td2)+1)
    }
    (dest <- paste0(td,'/',td2))
    do::formal_dir(dest)
    dir.create(path = dest,recursive = TRUE,showWarnings = FALSE)
    (tf <- paste0(dest,'/nh3.zip'))

    download.file(url = 'https://codeload.github.com/yikeshu0611/nh3/zip/refs/heads/main',
                  destfile = tf,
                  mode='wb',
                  headers = c(NULL,Authorization = sprintf("token %s",token)))
    unzip(zipfile = tf,exdir = dest,overwrite = TRUE)

    main <- paste0(dest,'/nh3-main')
    if (do::is.windows()){
        nh3 <- list.files(main,'nh3_',full.names = TRUE)
        nh3 <- nh3[do::right(nh3,3)=='zip']
        k <- do::Replace0(nh3,'.*nh3_','\\.zip','\\.tgz','\\.') |> as.numeric() |> which.max()
        unzip(nh3[k],files = 'nh3/DESCRIPTION',exdir = main)

    }else{
        nh3 <- list.files(main,'nh3_',full.names = TRUE)
        nh3 <- nh3[do::right(nh3,3)=='tgz']
        k <- do::Replace0(nh3,'.*nh3_','\\.zip','\\.tgz','\\.') |> as.numeric() |> which.max()
        untar(nh3[k],files = 'nh3/DESCRIPTION',exdir = main)

    }

    desc <- paste0(main,'/nh3')
    check_package(desc)

    install.packages(pkgs = nh3[k],repos = NULL,quiet = FALSE)
    message('Done(nh3)')
    x <- suppressWarnings(file.remove(list.files(dest,recursive = TRUE,full.names = TRUE)))
    invisible()
}


