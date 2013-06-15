
# An example --------------------------------------------------------------

R.df  <- data.frame()
fix(R.df)
R.df2 <- melt(R.df, id='ID')
table(R.df2$value)
barplot(table(R.df2$value))

knit('Example1.Rmd')
Pandoc.convert('Example1.md', format='html')
Pandoc.convert('Example1.md', format='docx')

# Reading data into R -----------------------------------------------------

pheno <- read.csv('data/pheno.csv')
geno <- read.table('data/geno.csv', sep=',', header=T)

pheno2 <- read.csv('http://faculty.washington.edu/kenrice/sisg/example-pheno.csv')

library(RSQLite)
sqlite <- dbDriver('SQLite')
exampledb <- dbConnect(sqlite,'data/mydb.sqlite')
dbListTables(exampledb)

library(sqldf)
sqldf('select * from phenotype limit 5', dbname='data/mydb.sqlite')
sqldf('select * from pheno limit 5') # use the data.frame pheno


# How does my data look? --------------------------------------------------

str(pheno)

data(mtcars)
str(mtcars)


# data.frame --------------------------------------------------------------

pheno[1,]
pheno[,2:4]
pheno[1,2]

# factors -----------------------------------------------------------------

x.character <- as.character(15:20)
x.factor <- as.factor(x.character)

as.numeric(x.character)
as.numeric(x.factor)
