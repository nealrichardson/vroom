({ library(arrow); library(dplyr) })
x <- read_tsv_arrow(file, quote = "", na = character(), as_data_frame = FALSE)
print(x)
a <- head(x)
b <- tail(x)
c <- x[sample(NROW(x), 100), ]
d <- x[x$X1 > 3, ]
e <- group_by(x, X2) %>% summarise(avg_X1 = mean(X1))
