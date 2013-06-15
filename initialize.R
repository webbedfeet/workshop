# Initialization of R for workshop

options(repository='http://cran.rstudio.org')
install.packages("devtools")

install.packages(c("httr",'RCurl','memoise','whisker'))
have.packages <- installed.packages()
cran.packages <- c("reshape2","plyr","ggplot2","Hmisc","rms", "knitr","mlbench","caret",
                   "sqldf",'RSQLite', 'pander')
to.install <- setdiff(cran.packages, have.packages[,1])
if(length(to.install)>0) install.packages(to.install)


ramnath.packages <- c('slidify','rCharts')
for(p in ramnath.packages) install_github(p, 'ramnathv')
