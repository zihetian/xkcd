## code to prepare `xkcd` dataset goes here

library(jsonlite)

json_objects <- vector(mode = "list", length = 2850)

for (i in seq_along(json_objects)) {

  if (i == 404) {
    # ha ha =/
    json_objects[[i]] <- setNames(as.list(rep(NA, 11)),
                                  c("month", "num", "link", "year", "news", "safe_title",
                                    "transcript", "alt", "img", "title", "day"
                                  )
    )
    json_objects[[i]]$num <- 404
  } else {
    url <- file.path("https://xkcd.com", i, "info.0.json")
    json_objects[[i]] <- jsonlite::read_json(url)
    Sys.sleep(1)
  }

}

xkcd_data <- do.call(rbind, json_objects)
xkcd_data <- as.data.frame(xkcd_data)
xkcd_data$extra_parts <- NULL

# Put column in defined order
column_names <- c("num", "year", "month", "day", "link", "news",
                  "title", "safe_title", "transcript", "alt", "img"
)
xkcd_data <- xkcd_data[,column_names]

usethis::use_data(xkcd_data, overwrite = TRUE)
