({ library(arrow); library(dplyr) })
x <- read_tsv_arrow(file, quote = "", na = character(), as_data_frame = FALSE)
print(x)
a <- head(x)
b <- tail(x)
c <- x[sample(NROW(x), 100), ]
d <- x[X1 == "helpless_sheep", ]
e <- group_by(x, X1) %>% summarise(avg_nchar = mean(nchar(X2)))
