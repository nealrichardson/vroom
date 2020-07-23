({ library(arrow); library(dplyr) })
x <- read_csv_arrow(file, quote = "", na = character(), as_data_frame = FALSE)
print(x)
a <- head(x)
b <- tail(x)
c <- x[sample(NROW(x), 100), ]
d <- x[x$payment_type == "UNK", ]
e <- select(x, payment_type, tip_amount) %>% group_by(payment_type) %>% collect() %>% summarise(avg_tip = mean(tip_amount)) # TODO: aggregate in Arrow
