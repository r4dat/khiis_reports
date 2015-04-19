library(data.table)
library(lubridate)
library(dplyr)
library(stringr)
library(assertthat)

options("scipen"=10)

if(!exists("readMembersData", mode="function")) source("readData.R")
if(!exists("StateEst")) source("PopEst.R")

members10=readMembersData('2010')
members11=readMembersData('2011')
members12=readMembersData('2012')

tmp = rbind(members10,members11,members12)

out = tmp %>% group_by(ageband,gender,county,elgband,subyr) %>% 
  summarise(ClassMemMo=sum(as.numeric(membmo)),ClassSize=n())



## Create fill for empty sets.
gndr=unique(out$gender)
cnty=unique(out$county)
age=unique(out$ageband)
elg=unique(out$elgband)
yr=unique(out$subyr)
fill=expand.grid(gndr,cnty,age,elg,yr,stringsAsFactors=FALSE)
setnames(fill,c("gender","county","ageband","elgband","subyr"))

## Expect 2 * 105 * 3 * 5 * 3
assert_that(nrow(fill)==9450)

out = full_join(out,fill)
# Replace Empty NA's with 0's.
out[is.na(out)]=0

## Prepend space for excel shenanigans?
out$elgband=str_c(' ',out$elgband)

write.csv(out,str_c("D:/MySQL_KHIIS_OUT/All_Members_Analysis.csv"),row.names=FALSE)

## Create confidence intervals for counties
out = tmp %>% group_by(county,subyr) %>% 
  summarise(ClassSize=n()) %>% inner_join(StateEst,copy = TRUE) %>% select(county,subyr,ClassSize,adjpop) %>% mutate(perc=ClassSize/adjpop) %>% mutate(Completeness=cut(perc,breaks = c(0,.25,.5,.75,1),right=FALSE,labels=c("C1","C2","C3","C4")))

write.csv(out,str_c("D:/MySQL_KHIIS_OUT/Completeness_Analysis.csv"),row.names=FALSE)