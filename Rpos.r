dev.off()
library(ggplot2)
library(reshape)

#read data
data = read.table(file.choose(), header=T,sep=",")

#melt data “rating vs. all”
data2=melt(data,id=c("rating"))
data2
max(data2$value)
qplot(rating,value,data=data2,geom="line",linetype=variable)