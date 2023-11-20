#' Retrieve metadata about an xkcd comic
#'
#' Given an xkcd comic number, this function retrieves a JSON object
#' describing that comic from the xkcd website.
#'
#' @param number A scalar numeric vector identifying an xkcd comic number.
#'
#' @return A list of class `xkcd` with the following fields
#' * month
#' * num
#' * link
#' * news
#' * safe_title
#' * transcript
#' * alt
#' * img
#' * title
#' * day
#'
#' Note that many of these fields may be an empty string
#'
#' @importFrom jsonlite read_json
#' @export
xkcd <- function(number){

  url <- file.path("https://xkcd.com", number, "info.0.json")
  x <- jsonlite::read_json(url)
  x <- new_xkcd(x)
  x <- validate_xkcd(x)
}

new_xkcd <- function(x){

  stopifnot(is.list(x))

  structure(x,
            class = "xkcd")

}

validate_xkcd <- function(x){

  required_fields <- c("month", "num", "link","year", "news", "safe_title",
                       "transcript", "alt", "img", "title", "day")


  if(!all(required_fields %in% names(x))){
    difference <- setdiff(required_fields, names(x))
    stop("xkcd object is missing the following required fields: ",
         paste(difference, collapse = ", ")
         )
  }

  char_fields <- c("month", "link","year", "news", "safe_title",
                       "transcript", "alt", "img", "title", "day")

  for(f in char_fields){
    if(!(is.character(x[[f]])) && length(x[[f]])==1){
      stop("The", f, "field in an xkcd object must be a character vector of length 1")
    }
  }

  if(!(is.numeric(x[["num"]])) && length(x[["num"]])==1){
    stop("The num field in an xkcd object must be a numeric vector of length 1")
  }


  return(x)
}

#' Visualize xkcd comics
#'
#' Given an [`xkcd`] function, this [`base::plot`] method retrieves the image file associated with
#' this comic from the xkcd website and displays it in the currently
#' active graphics device.
#'
#' @param x An [`xkcd`] object
#' @param ... Currently ignored
#'
#' @importFrom utils download.file
#' @importFrom tools file_ext
#' @importFrom png readPNG
#' @importFrom jpeg readJPEG
#' @importFrom grid grid.raster
#'
#' @exportS3Method
plot.xkcd <- function(x,...){

  img_type <- tools::file_ext(x$img)

  tmp <- tempfile(pattern = "file",
                  tmpdir = tempdir()
                  )
  utils::download.file(x$img, destfile = tmp, mode = "wb")

  if(img_type == "png"){
    p <- png::readPNG(tmp)
  }else if(img_type == "jpg"||img_type == "jpeg"){
    p <- jpeg::readJPEG(tmp)
  }else{
    stop("Unknown image format", image_type)
  }

  plot.new()
  grid::grid.raster(p)
}
