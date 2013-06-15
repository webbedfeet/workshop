# An example
```{r results='hide', echo=FALSE}
library(pander)
```

First we will find out which software packages/systems we use. 
```{r results='asis', echo=FALSE}
pandoc.table(R.df')
```
So which software is the most popular?<br>

```{r fig.align='default', fig.height=4, echo=FALSE}
barplot(table(melt(R.df, id='ID')$value))

```


