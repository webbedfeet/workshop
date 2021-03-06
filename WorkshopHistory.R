#' % Introduction to R
#' % Abhijit Dasgupta, PhD
#'   Data Community DC
#' % June 15, 2013
#' 
#' <img src='DC2logo.png',style='height:50px'></img>
#' <br/>
#' <br/>
#' 
#' # Starting out in R
#' 
#' We will start off by creating a blank data.frame, opening a window to directly
#' enter data into it, do some manipulations, draw a plot, and generate a report
#' Some lines of code below are commented (line starting with `#`) so that it 
#' doesn't run during this document. If you want to run the code on your own,
#' just remove the `#` at the beginning of the lines.
#' 
#' R coding is free-form, in that you can split code over lines. If you want 
#' to put two commands on the same line of text, separate them with a `;`. 
#' 
#' I saved a version of R.df using the `save` command, into a file _example.rda_
#' You can replace it with the commented commands. Note that a R data file (an rda file)
#' will work for all versions of R on all platforms.

#+ readdata, echo=T, results='hide', error=FALSE, warning=FALSE, message=FALSE
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

#' ## Reading data into R from a CSV file
#' 
#' The most common type of data are text files, and often comma-separated
#' files or csv files. R natively handles the import of data in csv format, using 
#' `read.csv`.

#+ readcsv, results='hide'
pheno <- read.csv('data/pheno.csv')
pheno # This prints out the data
head(pheno) # This prints out first 6 lines
tail(pheno) # This prints out last 6 lines

#' > __Tip:__ you can just type an R object to see what it is or what it
#' > contains. For example, if you want to see how the function `read.csv` is 
#' > coded, just type `read.csv`. You can also find out just what the arguments for
#' > a function and their default values are using the function `arg`, as below

#+ typing1, echo=T, results='markup'
read.csv
args(read.csv)

#' > We see that `read.csv` is build on the function 
#' > `read.table`. To see more about `read.table`, you can access its documentation
#' > by typing `?read.table` or `help(read.table)`

#+ help, echo=TRUE, results='hide'
help(read.table)

#' ## Working with data sets
#' 
#' ### Figuring out what's in a data set
#' 
#' R has two powerful functions which give you a quick feel about a data set. The 
#' two major pieces of information you need are
#' 
#' + What kinds of data are part of the data set (use `str`)
#' + Some summary of the data (use `summary`)
#' 
#' `str(pheno)` tells us that we have a `data.frame` object with 1000 observations
#' of 6 variables. Each variable has a type -- in this case all are integer variables (`int`)
#' and `sex` is a `factor` variable. I'll describe `factor` variables in a bit.
#' 
#' `summary(pheno)` gives numerical summaries for `int` variables (as it would for `numeric` variables)
#' and frequency tabulations for `factor` variables. If you have a `character` variable (denoted `chr` in the output of `str`), it would merely say that you have a character variable of 1000 observations
#' 
#' 

#+ summaries
str(pheno)
summary(pheno)

#' ### A note on `data.frame`
#' The `data.frame` looks like a matrix, but it really isn't. This is one of the pitfalls
#' and quirks of R. We can see this by

#+ isdf
is.data.frame(pheno)
is.matrix(pheno)

#' The `data.frame` object is really another kind of R object, a `list`. We will see later how 
#' this is useful, since R has very powerful list manipulation functions. Still, some matrix
#' operations are allowed for `data.frame` objects. For example, you can extract rows and columns and 
#' elements just like a matrix, using `pheno[1,]` (1st row), `pheno[,3]` (3rd column) or 
#' `pheno[1,2]` (the (1,2) element). 
#' 
#' You can extract variables (stored apparently in columns) either by the above matrix notation,
#' or by variable name. For example, to just extract the `sex` variable, you can use
#' `pheno$sex` or `pheno[,'sex']`. The `$` notation is useful to extract single variables,
#' but the matrix-like notation is useful to extract multiple variables by name: 
#' `pheno[,c('sex','sbp','dbp','bmi')]. As a side note,  `c()` is a function called "concatenate", which
#' creates vectors.
#' 
#' ### Merging data sets
#' 
#' The study I took the data from has two files, geno and pheno, which
#' collected gene data and clinical data respectively from 1000 subjects. We
#' now read in the gene data, but we need to match up the two data sets so that
#' the rows correspond. The simplest way to do this is to sort the rows of the 
#' data frame by the `id` variable, so both have the same order. The data set `pheno` 
#' is already sorted. We need to do this for `pheno`. We will use the `order` function
#' on the `id` variable to figure out its sort order. Basically, the rule is that,
#' to sort a vector `x`, you can do `sort(x)` or `x[order(x)]`. Here what we need
#' is the correct re-ordering, not just the sorted values. So `order(x)` is what's needed
#' to re-order the rows. 
#' 
#' > __A general practice:__ Never change data (be it a vector or a data.frame) in place.
#' > Always copy it to differently-named object and change that. That way, if you 
#' > goof up, you're not having to re-generate everything. So, I saved the
#' > re-ordered `pheno` to `pheno2`. This keeps `pheno` unchanged.

#+ match1
geno <- read.table('data/geno.csv', sep=',', header=T)
head(geno)
head(pheno)
o=order(pheno$id)
#pheno$id[o]
pheno2=pheno[o,]
# pheno2 <- pheno[order(pheno$id),]
head(pheno2)

#' A better way to match the ordering of two data sets based on a common variable is to
#' use the function `match`

#+ match2, echo=T
args(match)
ind <- match(geno$id, pheno$id)
pheno3 <- pheno[ind,]

#' You can check for yourself whether `pheno2` and `pheno3` are the same.
#' 
#' You can also merge the two datasets into a single data set based on a 
#' common variable, using the function `merge`. This does not require the common
#' variable (in this case, `id`) to be sorted, unlike in SAS.

#+ merge1
combined.data <- merge(pheno, geno,by='id')
head(combined.data)

#' ### Factor variables
#'
#' Factor variables are very useful, but can be quirky. Factors look like character
#' variables, but are really stored as numeric variables. They are meant to 
#' store categorical variables rather than strings. 

#+ factor1
s2 = as.character(pheno$sex)
str(s2)
summary(s2)
head(as.numeric(pheno$sex))
head(as.numeric(s2))

#' When we read in data sets, R, by default, converts any string variable to a factor. This is 
#' often not what we want. For example, an identifier variable needs to remain a character, 
#' not a factor. Most of us suggest making sure that strings are imported as characters, not 
#' factors. There is an option `stringsAsFactors` which can be set globally using 
#' `options(stringsAsFactors=FALSE)`. You can also set it on the fly when you import data

#+ str1, results='hide'
pheno <- read.csv('data/pheno.csv', stringsAsFactors=F)

#' You can also pre-specify what the types of variables are in each column you 
#' are importing, using the option `colClasses` (note the camel-case). This 
#' is much faster if you are importing large data sets

#+ str2, results='hide'
pheno <- read.csv('data/pheno.csv', colClasses=c('integer','factor','integer','integer','integer','integer'))

#' ## Reading from databases
#' 
#' R has packages to import data from most standard relational databases. The
#' generic package is `RODBC` which connects R to ODBC-compliant databases. Popular
#' databases also have dedicated packages, including 
#' 
#' + MySQL (`RMySQL`),
#' + Postgresql (`RPgSQL`),
#' + SQLite (`RSQLite`), 
#' + MonetDB (`MonetDB.R`)
#'
#' More recently, there are packages to import from 
#' MongoDB and CouchDB, two popular NoSQL databases.
#' 
#' I'm demonstrating using RSQLite, since it installs the sqlite database automatically.
#' The other package you need is `sqldb`, which allows you to manipulate R data frames and
#' database objects using SQL commands. If you are coming from a SQL background, 
#' this is a life saver.

#+ sql1, message=FALSE, warning=FALSE, error=FALSE
library(RSQLite)
sqlite <- dbDriver('SQLite')
exampledb <- dbConnect(sqlite,'data/mydb.sqlite')
dbListTables(exampledb)
library(sqldf)
sqldf('select * from phenotype limit 5', dbname='data/mydb.sqlite')
sqldf('select * from pheno limit 5') # use the data.frame pheno

#' ## Subsetting
#' 
#' We will use another data set that comes with R to demonstrate some other functionalities.
#' You can see all the data sets that are loaded with R and other R packages you might 
#' have installed by typing `data()`. We will use the `mtcars` data set, which is 
#' a data set of car road tests published by Motor Trend magazine in 1974. 
#' 
#' First, we will look at subsetting data by values of some variable. Note, if you
#' wanted to subset particular rows, say the first 10 rows, you could just use matrix
#' notation and do `mtcars[1:10,]`. 
#' 
#' >> The notation `1:10` denotes the sequence 1,2,3,4,5,6,7,8,9,10, stored in a numeric
#' >> vector. This is similar to the function `range` in Python.
#' 
#' >> Note that R starts counting at 1, so the first element of a vector `x` is `x[1]`. This
#' >> is unlike Python or C, which start counting at 0. This is because of R's close history
#' >> with Fortran, which was a column-dominant language counting from 1. 
#' 
#' We start by extracting the subset of data where number of cylinders is 6. Note that
#' we are using `==` and not `=`. You can also put multiple conditions in your subset conditions, 
#' either using `&` (and) or `|` (or)

#+ mtcars1
str(mtcars)
head(mtcars)
subset(mtcars, cyl==6)
subset(mtcars, cyl==6 & mpg<20)

#' ## Transformation and creating new variables
#' 
#' The non-destructive way of creating new variables in a data set is the function `transform`. First
#' we want to say that if a car gets less than 20 mpg, it is a gas guzzler. R has a convenient
#' `ifelse` function to do this (much like th `?` function in Python/C). Ideally you want to make this new variable a factor.
#' 
#' You can create multiple variables in one command using `transform`. For example, I also
#' convert mpg to kmpg.

#+ trans
ifelse(mtcars$mpg<20, 'gas.guzzler','Econ')
blah <- transform(mtcars, gas = ifelse(mpg<20, 'gas.guzzler','econ'), kmpg=1.6*mpg)
str(blah)
blah <- transform(mtcars, gas = ifelse(mpg<20, 'gas.guzzler','econ'), kmpg=1.6*mpg, score=3*cyl+0.1*wt-0.01*mpg)
str(blah)

#' Note that the original `mtcars` remains unchanged

#+ mtcars2
str(mtcars)

#' ## Missing data
#' R codes missing data as `NA`, and provides the function `is.na` to find missing values. 
#' Many of R's functions give a missing value or `NA` if one of the components in the computation is missing. 
#' This behavior can be suppressed within the functions which accept it by the option `na.rm=TRUE`. The
#' `summary` function we saw before already does this, and tells you how many values are missing for
#' each variable in the data set

#+ mtcars3
blah$mpg[3] <- NA
head(blah)
mean(blah$mpg)
mean(blah$mpg, na.rm=T)

#' ## 'Apply'ing a function over components of a data set
#' R provides a family of functions, all ending in `apply`, which are meant to 
#' evaluate a function over different aspects of a data set. The function `apply` works on matrices.

#+ apply,results='hide'
args(apply)
#X = matrix(rnorm(100),ncol=10) # rnorm generates normal random numbers
#apply(X, 2, mean)


#' `lapply` does the same for components of a `list`. Recall I said that a `data.frame` object
#' is really a `list`. So the following works:

#+ lapply, results='hide'
args(lapply)
#lapply(pheno, mean, na.rm=T)

#' ## Aggregation
#' 
#' R provides many ways to aggregate data, including the functions `by` and `aggregate`. The most
#' powerful group of functions are from the package `plyr`. These functions are all of
#' the form `(x)(y)ply`, where `(x)` and `(y)` can be any of _d_ (data.frame),_a_ (array), and
#' _l_ (list). `(x)` denotes the type of data that is input, and `(y)` denotes the type of data 
#' being output. These functions implement what Wickham calls the "split-apply-combine" paradigm, 
#' i.e., you split the data by some variable (usually of type `factor`), apply a function to the split pieces, and put
#' the results of the functions back together. The documentation is rather unfortunate for these 
#' functions, so I'll demonstrate by example.
#' 
#' We will first look at the average mpg of the cars in `mtcars` by number of cylinders. This 
#' can be done by splitting the data set by `cyl`, passing the split data sets through the function
#' `summarise`, and then putting the results back together into a data frame. For more information on
#' the `summarise` function, look at its documentation. There are two ways of denoting the splitting
#' variable. I prefer `~cyl`, since it is similar to the formula interface for modeling in R that I
#' am familiar with, and that you will learn later. You can also split on two or more factors quite
#' easily. With `summarise`, you can also compute more than one measure

#+ plyr1
library(plyr)
mtcars <- transform(mtcars, cyl=as.factor(cyl), gear=as.factor(gear)) #this creates a local copy
avg.by.cyl <- ddply(mtcars, ~cyl, summarise, mpg=mean(mpg, na.rm=T))
# avg.by.cyl <- ddply(mtcars, .(cyl), summarise, mpg = mean(mpg, na.rm=T))
avg.by.cyl
avg.by.cyl.gear <- ddply(mtcars, ~cyl+gear, summarise, mean.mpg=mean(mpg, na.rm=T),
                         median.mpg =median(mpg, na.rm=T))
avg.by.cyl.gear

#' If you want to just split the data set up by a variable, that is very easy as well

#+ plyr2, results='hide'
dlply(mtcars, ~cyl)

#' # Basic plotting
#' R provides several plotting frameworks. The basic one is known as base graphics, and 
#' one of the more popular frameworks is in the package [`ggplot2`](http://docs.ggplot2.org).
#' To make a few quick and dirty plots....

#+ plots1
plot(mpg~disp, data=mtcars)
plot(mpg~disp, data=mtcars, xlab='Displacement',ylab='Miles per gallon',
     main = 'Fuel effiency by engine size') # adding labels
boxplot(mpg~cyl, data=mtcars)

#' You can make prettier plots with better defaults using `ggplot2` which is based on the 
#' Grammar of Graphics. The idea is, like a painter, to layer different components of the plot
#' on top of each other. The syntax is quirky again, but once you learn it, it is really
#' very powerful. 

#+ ggplot, warning=FALSE, error=FALSE, message=FALSE
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

#' If you want to look at several variables and their inter-relationships, the functions
#' `pairs` (base graphics) and `plotmatrix` (ggplot2) work

#+ pm, warning=FALSE
pairs(pheno[,c('sbp','dbp','bmi')])
print(
  plotmatrix(pheno[,c('sbp','dbp','bmi')])
)

#' ### Javascript-based interactive charts
#' I believe the future is in web-based content-rich interactive charts. The package
#' `rCharts` provides an interface from R to several Javascript graphing libraries. Running the following
#' code will open up your web browser to display the charts. These charts can be integrated into HTML
#' documents, but that's another day. See the [rCharts](http://ramnathv.github.io/rCharts/) webpage
#' for more details.

#+ rcharts, results='hide'
library(rCharts)
r1 <- rPlot(mpg~wt|cyl, data=mtcars, type='point')
r1

#' # Some basic modeling
#' Fitting a linear regression model to two variables is a pretty basic task. R
#' provies an intuitive formula interface for all its modeling functions, which 
#' reads just like an equation. The linear regression model is fit using the function
#' `lm` (linear model). Other modeling functions include `glm` (generalized linear models),
#' `lrm` (logistic regression, in package rms), `coxph` (Cox regression, in package survival),
#' and several machine learning methods in the package `caret`. There are many more.
#' 
#' >> __Huge tip:__ Go to the [Task Views](http://cran.rstudio.com/web/views/) page on 
#' >> CRAN to find packages addressing different
#' >> topics in analytics

#+ lm
model1 <- lm(mpg~disp, data=mtcars)
model1
summary(model1)

#' You can now export components of the results for use in your report. The most useful
#' tools (in Windows) is the package `R2wd` which will take the result of the model, 
#' format it and put it into your open Word document. 
#' 
#' My preferred way now is using [markdown](http://daringfireball.net/projects/markdown/),
#' [pandoc](http://johnmacfarlane.net/pandoc/) and the R package [knitr](http://yihui.name/knitr/),
#' as demonstrated [here](http://yihui.name/knitr/demo/pandoc/). `knitr` is a very powerful tool
#' which is relatively easy to use (I'm using it right now), so is worth a look. This file uses these tools,
#' and the process of converting it to Word and HTML are described at the end of this document. The 
#' results of the model above is formatted below:

#+ conv, results='asis'
require(pander)
pander(model1)


#' R treats graphs as printable objects, and so provides several "printers" to convert
#' graphs to PDF, PNG, JPG, etc. 

#+ plot2, results='hide'
dev.off()
pdf(file='graph.pdf')
# png(file='graph.png')
# jpeg(file='graph.jpg')
plot(mpg~disp, data=mtcars, xlab='Displacement',ylab='Miles per gallon')
dev.off()

#' ### Finally
#' You should be writing R in a script file and passing it to R, rather than writing 
#' directly in the R console. However, R automatically saves all your commands in a history file, so 
#' you can save that directly

#+ hist, results='hide'
savehistory("~/Downloads/workshop-master/WorkshopHistory.R")

#' # Resources
#' No endorsement is implied in this list. There are many many R resources out 
#' there. This is the tip of the iceberg.
#' 
#' ## Learning R
#' 
#' 1. [Learning R](http://learnr.workpress.com)
#' 2. [UCLA IDRE](http://www.ats.ucla.edu/stat/r/)
#' 3. [R Bloggers](http://www.r-bloggers.com)
#' 4. [CRAN Task Views](http://cran.r-project.org/web/views)
#' 5. [Code school](http://www.codeschool.com/courses/try-r)
#' 6. [How to learn R](http://www.inside-r.org/howto/how-learn-r)
#' 7. [A R mindmap](http://www.xmind.net/m/LKF2/)
#' 8. [statistics.com](http://www.statistics.com)
#' 
#' ## Coming from another software
#' 
#' 1. [SAS and R](http://sas-and-r.blogspot.com)
#' 2. [r4stats](http://r4stats.com/examples/)
#' 3. [RExcel](http://rcom.univie.ac.at)
#' 
#' ## Locally (shameless plug)
#' 
#' 1. [Statistical Programming DC](http://datacommunitydc.org/blog/stats-prog-dc/)
#' 2. [Data Science DC](http://datacommunitydc.org/blog/data-science-dc/)
#' 3. [Data Visualization DC](http://datacommunitydc.org/blog/data-visualization-dc/)
#' 
#' # Acknowledgements
#' 
#' I would like to thank Tony Ojeda for organizing the workshop, the participants for their questions
#' and interaction, and authors of the R packages I use. 
#' 
#' This document is written within RStudio using the R Notebook facility. The source _WorkshopHistory.R_
#' is formatted in accordance with requirements of the `spin` function of the `knitr` package, which 
#' converted this to Rmarkdown (_WorkshopHistory.Rmd_) and Markdown (_WorkshopHistory.md_). This
#' was then converted to HTML (_WorkshopHistory.md.html_) and Word (_WorkshopHistory.md.docx_) using 
#' [pandoc](http://johnmacfarlane.net/pandoc/) and the function `Pandoc.convert` from the R package
#' _pander_. The code has been extracted into a separate file _code.R_. 
#' This document contains both the text and the R code and can be reproduced locally by
#' the commands

#+ compile, results='hide', error=F, message=F, warning=F
library(knitr)
library(pander)
spin('WorkshopHistory.R')
Pandoc.convert("WorkshopHistory.md", format='docx')
Pandoc.convert('WorkshopHistory.md', format='html')

#' The R code can be extracted following the previous commands, using the commands

#+ rcode, results='hide', error=F, message=F, warning=F
library(knitr)
purl('WorkshopHistory.Rmd', output='code.R')

#' I hope you have fun exploring R and the many tools it provides for data analytics.
