({ library(arrow); library(dplyr) })
x <- read_csv_arrow(file)
print(x)
a <- head(x)
b <- tail(x)
c <- x[sample(NROW(x), 100), ] # TODO: implement slice_sample method
d <- filter(x, payment_type == "UNK") %>% collect()
e <- group_by(x, payment_type) %>% summarise(avg_tip = mean(tip_amount))
