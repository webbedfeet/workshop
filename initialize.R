# Initialization of R for workshop

options(repository='http://cran.rstudio.org')
have.packages <- installed.packages()

if(!('devtools' %in% have.packages)) install.packages("devtools")
cran.packages <- c("reshape2","plyr","ggplot2","Hmisc","rms", "knitr","mlbench","caret",
                   "sqldf",'RSQLite', 'pander', 'gdata')
to.install <- setdiff(cran.packages, have.packages[,1])
if(length(to.install)>0) install.packages(to.install)

library(devtools)
ramnath.packages <- c('slidify','rCharts','slidifyLibraries')
for(p in ramnath.packages) {
  if(!(p %in% have.packages)) install_github(p, 'ramnathv')
}
