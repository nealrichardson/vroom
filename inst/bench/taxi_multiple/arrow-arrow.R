({library(arrow); library(dplyr)})
x <- open_dataset(dirname(file[1]), format = "csv")
print(x)
a <- head(x)
b <- tail(x)
c <- x[sample(NROW(x), 100), ]
d <- filter(x, payment_type == "UNK") %>% collect(as_data_frame = FALSE)
e <- group_by(x, payment_type) %>% select(tip_amount) %>% collect() %>% summarise(avg_tip = mean(tip_amount))
