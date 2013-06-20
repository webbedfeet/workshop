
## @knitr readdata, echo=T, results='hide', error=FALSE, warning=FALSE, message=FALSE
load('example.rda')
#R.df <- data.frame()
#R.df <- fix(R.df)
#save(R.df, file='example.rda')
R.df
str(R.df)
library(reshape2)
R.df2 <- melt(R.df, id='ID')
R.df2
str(R.df2)
table(R.df2$value)
barplot(
  table(
    R.df2$value))
library(knitr)
library(pander)
#knit('Example1.Rmd'); 
#Pandoc.convert('Example1.md', format='docx')


## @knitr readcsv, results='hide'
pheno <- read.csv('data/pheno.csv')
pheno # This prints out the data
head(pheno) # This prints out first 6 lines
tail(pheno) # This prints out last 6 lines


## @knitr typing1, echo=T, results='markup'
read.csv
args(read.csv)


## @knitr help, echo=TRUE, results='hide'
help(read.table)


## @knitr summaries
str(pheno)
summary(pheno)


## @knitr isdf
is.data.frame(pheno)
is.matrix(pheno)


## @knitr match1
geno <- read.table('data/geno.csv', sep=',', header=T)
head(geno)
head(pheno)
o=order(pheno$id)
#pheno$id[o]
pheno2=pheno[o,]
# pheno2 <- pheno[order(pheno$id),]
head(pheno2)


## @knitr match2, echo=T
args(match)
ind <- match(geno$id, pheno$id)
pheno3 <- pheno[ind,]


## @knitr merge1
combined.data <- merge(pheno, geno,by='id')
head(combined.data)


## @knitr factor1
s2 = as.character(pheno$sex)
str(s2)
summary(s2)
head(as.numeric(pheno$sex))
head(as.numeric(s2))


## @knitr str1, results='hide'
pheno <- read.csv('data/pheno.csv', stringsAsFactors=F)


## @knitr str2, results='hide'
pheno <- read.csv('data/pheno.csv', colClasses=c('integer','factor','integer','integer','integer','integer'))


## @knitr sql1, message=FALSE, warning=FALSE, error=FALSE
library(RSQLite)
sqlite <- dbDriver('SQLite')
exampledb <- dbConnect(sqlite,'data/mydb.sqlite')
dbListTables(exampledb)
library(sqldf)
sqldf('select * from phenotype limit 5', dbname='data/mydb.sqlite')
sqldf('select * from pheno limit 5') # use the data.frame pheno


## @knitr mtcars1
str(mtcars)
head(mtcars)
subset(mtcars, cyl==6)
subset(mtcars, cyl==6 & mpg<20)


## @knitr trans
ifelse(mtcars$mpg<20, 'gas.guzzler','Econ')
blah <- transform(mtcars, gas = ifelse(mpg<20, 'gas.guzzler','econ'), kmpg=1.6*mpg)
str(blah)
blah <- transform(mtcars, gas = ifelse(mpg<20, 'gas.guzzler','econ'), kmpg=1.6*mpg, score=3*cyl+0.1*wt-0.01*mpg)
str(blah)


## @knitr mtcars2
str(mtcars)


## @knitr mtcars3
blah$mpg[3] <- NA
head(blah)
mean(blah$mpg)
mean(blah$mpg, na.rm=T)


## @knitr apply,results='hide'
args(apply)
#X = matrix(rnorm(100),ncol=10) # rnorm generates normal random numbers
#apply(X, 2, mean)


## @knitr lapply, results='hide'
args(lapply)
#lapply(pheno, mean, na.rm=T)


## @knitr plyr1
library(plyr)
mtcars <- transform(mtcars, cyl=as.factor(cyl), gear=as.factor(gear)) #this creates a local copy
avg.by.cyl <- ddply(mtcars, ~cyl, summarise, mpg=mean(mpg, na.rm=T))
# avg.by.cyl <- ddply(mtcars, .(cyl), summarise, mpg = mean(mpg, na.rm=T))
avg.by.cyl
avg.by.cyl.gear <- ddply(mtcars, ~cyl+gear, summarise, mean.mpg=mean(mpg, na.rm=T),
                         median.mpg =median(mpg, na.rm=T))
avg.by.cyl.gear


## @knitr plyr2, results='hide'
dlply(mtcars, ~cyl)


## @knitr plots1
plot(mpg~disp, data=mtcars)
plot(mpg~disp, data=mtcars, xlab='Displacement',ylab='Miles per gallon',
     main = 'Fuel effiency by engine size') # adding labels
boxplot(mpg~cyl, data=mtcars)


## @knitr ggplot, warning=FALSE, error=FALSE, message=FALSE
library(ggplot2)
print(
  ggplot(mtcars, aes(x=disp, y=mpg))+geom_point()
)
print(
  ggplot(mtcars, aes(x=disp, y=mpg))+geom_point()+geom_smooth()+
  labs(x='Displacement',y='Miles per gallon') + 
  ggtitle('Fuel efficiency by engine size')
)
print(
  ggplot(mtcars, aes(x=disp, y=mpg))+geom_point()+geom_smooth()+facet_wrap(~cyl, ncol=1)+
    labs(x='Displacement',y='Miles per gallon')
)


## @knitr pm, warning=FALSE
pairs(pheno[,c('sbp','dbp','bmi')])
print(
  plotmatrix(pheno[,c('sbp','dbp','bmi')])
)


## @knitr rcharts, results='hide'
library(rCharts)
r1 <- rPlot(mpg~wt|cyl, data=mtcars, type='point')
r1


## @knitr lm
model1 <- lm(mpg~disp, data=mtcars)
model1
summary(model1)


## @knitr conv, results='asis'
require(pander)
pander(model1)


## @knitr plot2, results='hide'
dev.off()
pdf(file='graph.pdf')
# png(file='graph.png')
# jpeg(file='graph.jpg')
plot(mpg~disp, data=mtcars, xlab='Displacement',ylab='Miles per gallon')
dev.off()


## @knitr hist, results='hide'
savehistory("~/Downloads/workshop-master/WorkshopHistory.R")


## @knitr compile, results='hide', error=F, message=F, warning=F
library(knitr)
library(pander)
spin('WorkshopHistory.R')
Pandoc.convert("WorkshopHistory.md", format='docx')
Pandoc.convert('WorkshopHistory.md', format='html')


## @knitr rcode, results='hide', error=F, message=F, warning=F
library(knitr)
purl('WorkshopHistory.Rmd', output='code.R')


