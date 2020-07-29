({ library(arrow); library(dplyr) })
x <- read_csv_arrow(file, quote = "", na = character(), as_data_frame = FALSE)
print(x)
a <- head(x)
b <- tail(x)
c <- x[sample(NROW(x), 100), ]
d <- x[x$payment_type == "UNK", ]
e <- group_by(x, payment_type) %>% summarise(avg_tip = mean(tip_amount))
