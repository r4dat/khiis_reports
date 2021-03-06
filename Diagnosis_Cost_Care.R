library(data.table)
library(lubridate)
library(dplyr)
library(stringr)
library(assertthat)

options("scipen"=10)
base_path = 'D:/MySQL_KHIIS_OUT/'
file_string = '_Raw_Claim_Summ.csv'

if(!exists("readClaimsData", mode="function")) source("readData.R")

claims10=readClaimsData('2010')
claims11=readClaimsData('2011')
claims12=readClaimsData('2012')

tmp = rbind(claims10,claims11,claims12)

out = tmp %>% group_by(gender,county,ageband,diab,subyr) %>% 
  summarise(Med = median(as.numeric((TotCost))),
            AvgTot=
              ifelse( (sum(as.integer(membmo))==0),
                     ((sum(as.numeric(TotCost)))/(sqrt(n()))),
                     ((sum(as.numeric(TotCost)))/(sum(as.integer(membmo))/12))),
            ClassTotal=((sum(as.numeric(TotCost)))),ClassMemMo=(sum(as.integer(membmo))),ClassSize=n())


## Create fill for empty sets.
gndr=unique(out$gender)
cnty=unique(out$county)
age=unique(out$ageband)
diab=unique(out$diab)
year=unique(out$subyr)
fill=expand.grid(gndr,cnty,age,diab,year,stringsAsFactors=FALSE)
setnames(fill,c("gender","county","ageband","diab","subyr"))

assert_that(nrow(fill)==3780)

out = full_join(out,fill)
# Replace Empty NA's with 0's.
out[is.na(out)]=0
out$Med = format(round(out$Med, 2), nsmall = 2)
out$AvgTot = format(round(out$AvgTot,2),nsmall=2)
out$ClassTotal=format(round(out$ClassTotal,2),nsmall=2)

## Prepend space for excel shenanigans?
#out$elgband=str_c(' ',out$elgband)

write.csv(out,str_c(base_path,"DIAB_Calc_Tot_CostofCare.csv"),row.names=FALSE)


out = tmp %>% group_by(gender,county,ageband,chf,subyr) %>% 
  summarise(Med = median(as.numeric((TotCost))),
            AvgTot=
              ifelse( (sum(as.integer(membmo))==0),
                      ((sum(as.numeric(TotCost)))/(sqrt(n()))),
                      ((sum(as.numeric(TotCost)))/(sum(as.integer(membmo))/12))),
            ClassTotal=((sum(as.numeric(TotCost)))),ClassMemMo=(sum(as.integer(membmo))),ClassSize=n())

## Create fill for empty sets.
gndr=unique(out$gender)
cnty=unique(out$county)
age=unique(out$ageband)
chf=unique(out$chf)
year=unique(out$subyr)
fill=expand.grid(gndr,cnty,age,diab,year,stringsAsFactors=FALSE)
setnames(fill,c("gender","county","ageband","chf","subyr"))

assert_that(nrow(fill)==3780)

out = full_join(out,fill)
# Replace Empty NA's with 0's.
out[is.na(out)]=0
out$Med = format(round(out$Med, 2), nsmall = 2)
out$AvgTot = format(round(out$AvgTot,2),nsmall=2)
out$ClassTotal=format(round(out$ClassTotal,2),nsmall=2)

## Prepend space for excel shenanigans?
#out$elgband=str_c(' ',out$elgband)

write.csv(out,str_c("D:/MySQL_KHIIS_OUT/CHF_Calc_Tot_CostofCare.csv"),row.names=FALSE)

out = tmp %>% group_by(gender,county,ageband,copd,subyr) %>% 
  summarise(Med = median(as.numeric((TotCost))),
            AvgTot=
              ifelse( (sum(as.integer(membmo))==0),
                      ((sum(as.numeric(TotCost)))/(sqrt(n()))),
                      ((sum(as.numeric(TotCost)))/(sum(as.integer(membmo))/12))),
            ClassTotal=((sum(as.numeric(TotCost)))),ClassMemMo=(sum(as.integer(membmo))),ClassSize=n())

## Create fill for empty sets.
gndr=unique(out$gender)
cnty=unique(out$county)
age=unique(out$ageband)
copd=unique(out$copd)
year=unique(out$subyr)
fill=expand.grid(gndr,cnty,age,diab,year,stringsAsFactors=FALSE)
setnames(fill,c("gender","county","ageband","copd","subyr"))

# Expected 2*105*3*2*3
assert_that(nrow(fill)==3780)

out = full_join(out,fill)
# Replace Empty NA's with 0's.
out[is.na(out)]=0
out$Med = format(round(out$Med, 2), nsmall = 2)
out$AvgTot = format(round(out$AvgTot,2),nsmall=2)
out$ClassTotal=format(round(out$ClassTotal,2),nsmall=2)

## Prepend space for excel shenanigans?
#out$elgband=str_c(' ',out$elgband)


write.csv(out,str_c("D:/MySQL_KHIIS_OUT/COPD_Calc_Tot_CostofCare.csv"),row.names=FALSE)

out = tmp %>% group_by(gender,county,ageband,asthm,subyr) %>% 
  summarise(Med = median(as.numeric((TotCost))),
            AvgTot=
              ifelse( (sum(as.integer(membmo))==0),
                      ((sum(as.numeric(TotCost)))/(sqrt(n()))),
                      ((sum(as.numeric(TotCost)))/(sum(as.integer(membmo))/12))),
            ClassTotal=((sum(as.numeric(TotCost)))),ClassMemMo=(sum(as.integer(membmo))),ClassSize=n())

## Create fill for empty sets.
gndr=unique(out$gender)
cnty=unique(out$county)
age=unique(out$ageband)
asthm=unique(out$asthm)
year=unique(out$subyr)
fill=expand.grid(gndr,cnty,age,diab,year,stringsAsFactors=FALSE)
setnames(fill,c("gender","county","ageband","asthm","subyr"))

assert_that(nrow(fill)==3780)

out = full_join(out,fill)
# Replace Empty NA's with 0's.
out[is.na(out)]=0
out$Med = format(round(out$Med, 2), nsmall = 2)
out$AvgTot = format(round(out$AvgTot,2),nsmall=2)
out$ClassTotal=format(round(out$ClassTotal,2),nsmall=2)

## Prepend space for excel shenanigans?
#out$elgband=str_c(' ',out$elgband)


write.csv(out,str_c("D:/MySQL_KHIIS_OUT/ASTHMA_Calc_Tot_CostofCare.csv"),row.names=FALSE)
