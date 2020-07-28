({ library(arrow); library(data.table) })
x <- setDT(read_csv_arrow(file, quote = "", na = character()))
print(x)
a <- head(x)
b <- tail(x)
c <- x[sample(NROW(x), 100), ]
d <- x[payment_type == "UNK", ]
e <- x[ , .(mean(tip_amount)), by = payment_type]
