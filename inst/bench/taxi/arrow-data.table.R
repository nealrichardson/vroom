({ library(arrow); library(data.table) })
x <- as_data_table(read_csv_arrow(file))
print(x)
a <- head(x)
b <- tail(x)
c <- x[sample(NROW(x), 100), ]
d <- x[payment_type == "UNK", ]
e <- x[ , .(mean(tip_amount)), by = payment_type]
