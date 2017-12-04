rm(list=ls(all=TRUE))
library(data.table)
library(ggplot2)
library(ggrepel)
##List of Aggregate Data from Country Data
# INCLUDE_THESE_REGIONS<-c("WLD",
# "LIC",
# "MIC",
# "LMC",
# "UMC",
# "LMY",
# "EAP",
# "ECA",
# "LAC",
# "MNA",
# "SAS",
# "SSA",
# "HIC",
# "EMU",
# "OEC",
# "NOC",
# "AFR",
# "ARB",
# "CEB",
# "EAS",
# "ECS",
# "EUU",
# "FCS",
# "HPC",
# "IBD",
# "IBT",
# "IDB",
# "IDX",
# "IDA",
# "LCN",
# "LDC",
# "MEA",
# "NAC",
# "OED",
# "SST",
# "CSS",
# "PSS",
# "OSS",
# "SSF")
#https://libraries.acm.org/binaries/content/assets/libraries/wdi2013.pdf
#https://datahelpdesk.worldbank.org/knowledgebase/articles/898614-api-aggregates-regions-and-income-levels
INCLUDE_THESE_REGIONS<-c("WLD",
"SAS",
"AFR",
"ARB",
"EAS",
"EUU",
"LCN",
"MEA",
"NAC",
"SSF")


FERTILITY_FILENAME <-'/Users/acal/DataScienceProjects/StoryTellingThroughDataFirstWorldvsThirdWorld/FertilityRate/FertilityRate.csv'
FERTILITY_DATA <- data.frame(read.csv(FERTILITY_FILENAME))
FERTILITY_DATA <- subset(FERTILITY_DATA, (FERTILITY_DATA$Country.Code %in% INCLUDE_THESE_REGIONS))

POPULATION_FILENAME <-'/Users/acal/DataScienceProjects/StoryTellingThroughDataFirstWorldvsThirdWorld/Population/Population.csv'
POPULATION_DATA <- data.frame(read.csv(POPULATION_FILENAME))
POPULATION_DATA <- subset(POPULATION_DATA, (POPULATION_DATA$Country.Code %in% INCLUDE_THESE_REGIONS))

LIFEEXPECTANCY_FILENAME <-'/Users/acal/DataScienceProjects/StoryTellingThroughDataFirstWorldvsThirdWorld/LifeExpectancy/LifeExpectancy.csv'
LIFEEXPECTANCY_DATA <- data.frame(read.csv(LIFEEXPECTANCY_FILENAME))
LIFEEXPECTANCY_DATA <- subset(LIFEEXPECTANCY_DATA, (LIFEEXPECTANCY_DATA$Country.Code %in% INCLUDE_THESE_REGIONS))


year_range<-seq(1960,2015)
for (num in seq(1,length(year_range))){
  year<-paste("X",year_range[num],sep='')
  print (year)
png(paste("pic_",num,".png",sep=''),units="in", width=16, height=9, res=300)
#tiff('test.tiff', units="in", width=16, height=9, res=300)
FERTILITY_DATA_subset<-FERTILITY_DATA[c("Country.Name",year)]
LIFEEXPECTANCY_DATA_subset<-LIFEEXPECTANCY_DATA[c("Country.Name",year)]
POPULATION_DATA_subset<-POPULATION_DATA[c("Country.Name",year)]
RERFERNCE_POPULATION<-POPULATION_DATA[POPULATION_DATA$Country.Code=="WLD",year]
total <- merge(FERTILITY_DATA_subset,LIFEEXPECTANCY_DATA_subset,by=c("Country.Name"))
total <- merge(total,POPULATION_DATA_subset,by=c("Country.Name"))
colnames(total)<-c("Country.Name","FERTILITY","LIFEEXPECTANCY","POPULATION")
total<-total[complete.cases(total), ]
total$POPULATION<-100*total$POPULATION/RERFERNCE_POPULATION
total<-total[total$Country.Name!='World',]
p1<-ggplot(total, aes(x = FERTILITY, y = LIFEEXPECTANCY,color=Country.Name,size=POPULATION))+
  geom_point(alpha = 0.5,show.legend=F)+
  scale_size_continuous(range = c(min(total$POPULATION), max(total$POPULATION)))+
  geom_text_repel(aes(x = FERTILITY, y = LIFEEXPECTANCY,label = Country.Name),show.legend=F,inherit.aes = FALSE,family = "Trebuchet MS",fontface = 'bold',size = 4)+
  xlim(1,7.5)+ylim(40,85)+labs(x = "Fertility (births per woman)", y = "Life Expectancy (in years)",title=as.character(year_range[num]))+
  theme(plot.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=32)) +
  theme(axis.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=22))+
  theme(axis.text.x = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=15))+
  theme(axis.text.y = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=15))
print (p1)
dev.off()
}
  
