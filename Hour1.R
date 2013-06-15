
# An example --------------------------------------------------------------

R.df  <- data.frame()
fix(R.df)
R.df2 <- melt(R.df, id='ID')
table(R.df2$value)
barplot(table(R.df2$value))



# Reading data into R -----------------------------------------------------

## Reading raw data

R.df <- data.frame()
fix(R.df)
