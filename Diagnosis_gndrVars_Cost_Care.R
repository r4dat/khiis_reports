library(data.table)
library(lubridate)
library(dplyr)
library(stringr)
library(assertthat)

options("scipen"=10)
base_path = 'D:/MySQL_KHIIS_OUT/'
file_string = '_Raw_Claim_Summ.csv'

if(!exists("readClaimsData", mode="function")) source("readData.R")

claims10=readData('2010')
claims11=readData('2011')
claims12=readData('2012')

tmp = rbind(claims10,claims11,claims12)

#################
# DIAB
# gender 0 county 1
#
#
out = tmp %>% group_by(county,ageband,diab,subyr) %>% 
  summarise(Med = median(as.numeric((TotCost))),
            AvgTot=
              ifelse( (sum(as.integer(membmo))==0),
                      ((sum(as.numeric(TotCost)))/(sqrt(n()))),
                      ((sum(as.numeric(TotCost)))/(sum(as.integer(membmo))/12))),
            ClassTotal=((sum(as.numeric(TotCost)))),ClassMemMo=(sum(as.integer(membmo))),ClassSize=n())


## Create fill for empty sets.
cnty=unique(out$county)
age=unique(out$ageband)
diab=unique(out$diab)
year=unique(out$subyr)
fill=expand.grid(cnty,age,diab,year,stringsAsFactors=FALSE)
setnames(fill,c("county","ageband","diab","subyr"))

assert_that(nrow(fill)==1890)

out = full_join(out,fill)
# Replace Empty NA's with 0's.
out[is.na(out)]=0
out$Med = format(round(out$Med, 2), nsmall = 2)
out$AvgTot = format(round(out$AvgTot,2),nsmall=2)
out$ClassTotal=format(round(out$ClassTotal,2),nsmall=2)

## Prepend space for excel shenanigans?
#out$elgband=str_c(' ',out$elgband)

write.csv(out,str_c("D:/MySQL_KHIIS_OUT/gender0cnty1_DIAB_Calc_Tot_CostofCare.csv"),row.names=FALSE)

#################
# DIAB
# gender 1 county 0
#
#
out = tmp %>% group_by(gender,ageband,diab,subyr) %>% 
  summarise(Med = median(as.numeric((TotCost))),
            AvgTot=
              ifelse( (sum(as.integer(membmo))==0),
                      ((sum(as.numeric(TotCost)))/(sqrt(n()))),
                      ((sum(as.numeric(TotCost)))/(sum(as.integer(membmo))/12))),
            ClassTotal=((sum(as.numeric(TotCost)))),ClassMemMo=(sum(as.integer(membmo))),ClassSize=n())


## Create fill for empty sets.
gndr=unique(out$gender)
age=unique(out$ageband)
diab=unique(out$diab)
year=unique(out$subyr)
fill=expand.grid(gndr,age,diab,year,stringsAsFactors=FALSE)
setnames(fill,c("gender","ageband","diab","subyr"))

assert_that(nrow(fill)==18)

out = full_join(out,fill)
# Replace Empty NA's with 0's.
out[is.na(out)]=0
out$Med = format(round(out$Med, 2), nsmall = 2)
out$AvgTot = format(round(out$AvgTot,2),nsmall=2)
out$ClassTotal=format(round(out$ClassTotal,2),nsmall=2)

## Prepend space for excel shenanigans?
#out$elgband=str_c(' ',out$elgband)

write.csv(out,str_c("D:/MySQL_KHIIS_OUT/gender1cnty0_DIAB_Calc_Tot_CostofCare.csv"),row.names=FALSE)

#################
# DIAB
# gender 0 county 0
#
#
out = tmp %>% group_by(ageband,diab,subyr) %>% 
  summarise(Med = median(as.numeric((TotCost))),
            AvgTot=
              ifelse( (sum(as.integer(membmo))==0),
                      ((sum(as.numeric(TotCost)))/(sqrt(n()))),
                      ((sum(as.numeric(TotCost)))/(sum(as.integer(membmo))/12))),
            ClassTotal=((sum(as.numeric(TotCost)))),ClassMemMo=(sum(as.integer(membmo))),ClassSize=n())


## Create fill for empty sets.
age=unique(out$ageband)
diab=unique(out$diab)
year=unique(out$subyr)
fill=expand.grid(age,diab,year,stringsAsFactors=FALSE)
setnames(fill,c("ageband","diab","subyr"))

assert_that(nrow(fill)==3*2*3)

out = full_join(out,fill)
# Replace Empty NA's with 0's.
out[is.na(out)]=0
out$Med = format(round(out$Med, 2), nsmall = 2)
out$AvgTot = format(round(out$AvgTot,2),nsmall=2)
out$ClassTotal=format(round(out$ClassTotal,2),nsmall=2)

## Prepend space for excel shenanigans?
#out$elgband=str_c(' ',out$elgband)

write.csv(out,str_c("D:/MySQL_KHIIS_OUT/gender0cnty0_DIAB_Calc_Tot_CostofCare.csv"),row.names=FALSE)

#################
# CHF
# gender 0 county 1
#
#
out = tmp %>% group_by(county,ageband,chf,subyr) %>% 
  summarise(Med = median(as.numeric((TotCost))),
            AvgTot=
              ifelse( (sum(as.integer(membmo))==0),
                      ((sum(as.numeric(TotCost)))/(sqrt(n()))),
                      ((sum(as.numeric(TotCost)))/(sum(as.integer(membmo))/12))),
            ClassTotal=((sum(as.numeric(TotCost)))),ClassMemMo=(sum(as.integer(membmo))),ClassSize=n())


## Create fill for empty sets.
cnty=unique(out$county)
age=unique(out$ageband)
chf=unique(out$chf)
year=unique(out$subyr)
fill=expand.grid(cnty,age,chf,year,stringsAsFactors=FALSE)
setnames(fill,c("county","ageband","chf","subyr"))

assert_that(nrow(fill)==1890)

out = full_join(out,fill)
# Replace Empty NA's with 0's.
out[is.na(out)]=0
out$Med = format(round(out$Med, 2), nsmall = 2)
out$AvgTot = format(round(out$AvgTot,2),nsmall=2)
out$ClassTotal=format(round(out$ClassTotal,2),nsmall=2)

## Prepend space for excel shenanigans?
#out$elgband=str_c(' ',out$elgband)

write.csv(out,str_c("D:/MySQL_KHIIS_OUT/gender0cnty1_CHF_Calc_Tot_CostofCare.csv"),row.names=FALSE)

#################
# CHF
# gender 1 county 0
#
#
out = tmp %>% group_by(gender,ageband,chf,subyr) %>% 
  summarise(Med = median(as.numeric((TotCost))),
            AvgTot=
              ifelse( (sum(as.integer(membmo))==0),
                      ((sum(as.numeric(TotCost)))/(sqrt(n()))),
                      ((sum(as.numeric(TotCost)))/(sum(as.integer(membmo))/12))),
            ClassTotal=((sum(as.numeric(TotCost)))),ClassMemMo=(sum(as.integer(membmo))),ClassSize=n())


## Create fill for empty sets.
gndr=unique(out$gender)
age=unique(out$ageband)
chf=unique(out$chf)
year=unique(out$subyr)
fill=expand.grid(gndr,age,chf,year,stringsAsFactors=FALSE)
setnames(fill,c("gender","ageband","chf","subyr"))

assert_that(nrow(fill)==36)

out = full_join(out,fill)
# Replace Empty NA's with 0's.
out[is.na(out)]=0
out$Med = format(round(out$Med, 2), nsmall = 2)
out$AvgTot = format(round(out$AvgTot,2),nsmall=2)
out$ClassTotal=format(round(out$ClassTotal,2),nsmall=2)

## Prepend space for excel shenanigans?
#out$elgband=str_c(' ',out$elgband)

write.csv(out,str_c("D:/MySQL_KHIIS_OUT/gender1cnty0_CHF_Calc_Tot_CostofCare.csv"),row.names=FALSE)

#################
# CHF
# gender 0 county 0
#
#
out = tmp %>% group_by(ageband,chf,subyr) %>% 
  summarise(Med = median(as.numeric((TotCost))),
            AvgTot=
              ifelse( (sum(as.integer(membmo))==0),
                      ((sum(as.numeric(TotCost)))/(sqrt(n()))),
                      ((sum(as.numeric(TotCost)))/(sum(as.integer(membmo))/12))),
            ClassTotal=((sum(as.numeric(TotCost)))),ClassMemMo=(sum(as.integer(membmo))),ClassSize=n())


## Create fill for empty sets.
age=unique(out$ageband)
chf=unique(out$chf)
year=unique(out$subyr)
fill=expand.grid(age,chf,year,stringsAsFactors=FALSE)
setnames(fill,c("ageband","chf","subyr"))

assert_that(nrow(fill)==18)

out = full_join(out,fill)
# Replace Empty NA's with 0's.
out[is.na(out)]=0
out$Med = format(round(out$Med, 2), nsmall = 2)
out$AvgTot = format(round(out$AvgTot,2),nsmall=2)
out$ClassTotal=format(round(out$ClassTotal,2),nsmall=2)

## Prepend space for excel shenanigans?
#out$elgband=str_c(' ',out$elgband)

write.csv(out,str_c("D:/MySQL_KHIIS_OUT/gender0cnty0_CHF_Calc_Tot_CostofCare.csv"),row.names=FALSE)

#################
# COPD
# gender 0 county 1
#
#
out = tmp %>% group_by(county,ageband,copd,subyr) %>% 
  summarise(Med = median(as.numeric((TotCost))),
            AvgTot=
              ifelse( (sum(as.integer(membmo))==0),
                      ((sum(as.numeric(TotCost)))/(sqrt(n()))),
                      ((sum(as.numeric(TotCost)))/(sum(as.integer(membmo))/12))),
            ClassTotal=((sum(as.numeric(TotCost)))),ClassMemMo=(sum(as.integer(membmo))),ClassSize=n())


## Create fill for empty sets.
cnty=unique(out$county)
age=unique(out$ageband)
copd=unique(out$copd)
year=unique(out$subyr)
fill=expand.grid(cnty,age,copd,year,stringsAsFactors=FALSE)
setnames(fill,c("county","ageband","copd","subyr"))

assert_that(nrow(fill)==1890)

out = full_join(out,fill)
# Replace Empty NA's with 0's.
out[is.na(out)]=0
out$Med = format(round(out$Med, 2), nsmall = 2)
out$AvgTot = format(round(out$AvgTot,2),nsmall=2)
out$ClassTotal=format(round(out$ClassTotal,2),nsmall=2)

## Prepend space for excel shenanigans?
#out$elgband=str_c(' ',out$elgband)

write.csv(out,str_c("D:/MySQL_KHIIS_OUT/gender0cnty1_COPD_Calc_Tot_CostofCare.csv"),row.names=FALSE)

#################
# COPD
# gender 1 county 0
#
#
out = tmp %>% group_by(gender,ageband,copd,subyr) %>% 
  summarise(Med = median(as.numeric((TotCost))),
            AvgTot=
              ifelse( (sum(as.integer(membmo))==0),
                      ((sum(as.numeric(TotCost)))/(sqrt(n()))),
                      ((sum(as.numeric(TotCost)))/(sum(as.integer(membmo))/12))),
            ClassTotal=((sum(as.numeric(TotCost)))),ClassMemMo=(sum(as.integer(membmo))),ClassSize=n())


## Create fill for empty sets.
gndr=unique(out$gender)
age=unique(out$ageband)
copd=unique(out$copd)
year=unique(out$subyr)
fill=expand.grid(gndr,age,copd,year,stringsAsFactors=FALSE)
setnames(fill,c("gender","ageband","copd","subyr"))

assert_that(nrow(fill)==36)

out = full_join(out,fill)
# Replace Empty NA's with 0's.
out[is.na(out)]=0
out$Med = format(round(out$Med, 2), nsmall = 2)
out$AvgTot = format(round(out$AvgTot,2),nsmall=2)
out$ClassTotal=format(round(out$ClassTotal,2),nsmall=2)

## Prepend space for excel shenanigans?
#out$elgband=str_c(' ',out$elgband)

write.csv(out,str_c("D:/MySQL_KHIIS_OUT/gender1cnty0_COPD_Calc_Tot_CostofCare.csv"),row.names=FALSE)

#################
# COPD
# gender 0 county 0
#
#
out = tmp %>% group_by(ageband,copd,subyr) %>% 
  summarise(Med = median(as.numeric((TotCost))),
            AvgTot=
              ifelse( (sum(as.integer(membmo))==0),
                      ((sum(as.numeric(TotCost)))/(sqrt(n()))),
                      ((sum(as.numeric(TotCost)))/(sum(as.integer(membmo))/12))),
            ClassTotal=((sum(as.numeric(TotCost)))),ClassMemMo=(sum(as.integer(membmo))),ClassSize=n())


## Create fill for empty sets.
age=unique(out$ageband)
copd=unique(out$copd)
year=unique(out$subyr)
fill=expand.grid(age,copd,year,stringsAsFactors=FALSE)
setnames(fill,c("ageband","copd","subyr"))

assert_that(nrow(fill)==18)

out = full_join(out,fill)
# Replace Empty NA's with 0's.
out[is.na(out)]=0
out$Med = format(round(out$Med, 2), nsmall = 2)
out$AvgTot = format(round(out$AvgTot,2),nsmall=2)
out$ClassTotal=format(round(out$ClassTotal,2),nsmall=2)

## Prepend space for excel shenanigans?
#out$elgband=str_c(' ',out$elgband)

write.csv(out,str_c("D:/MySQL_KHIIS_OUT/gender0cnty0_COPD_Calc_Tot_CostofCare.csv"),row.names=FALSE)


#################
# ASTHM
# gender 0 county 1
#
#
out = tmp %>% group_by(county,ageband,asthm,subyr) %>% 
  summarise(Med = median(as.numeric((TotCost))),
            AvgTot=
              ifelse( (sum(as.integer(membmo))==0),
                      ((sum(as.numeric(TotCost)))/(sqrt(n()))),
                      ((sum(as.numeric(TotCost)))/(sum(as.integer(membmo))/12))),
            ClassTotal=((sum(as.numeric(TotCost)))),ClassMemMo=(sum(as.integer(membmo))),ClassSize=n())


## Create fill for empty sets.
cnty=unique(out$county)
age=unique(out$ageband)
asthm=unique(out$asthm)
year=unique(out$subyr)
fill=expand.grid(cnty,age,asthm,year,stringsAsFactors=FALSE)
setnames(fill,c("county","ageband","asthm","subyr"))

assert_that(nrow(fill)==1890)

out = full_join(out,fill)
# Replace Empty NA's with 0's.
out[is.na(out)]=0
out$Med = format(round(out$Med, 2), nsmall = 2)
out$AvgTot = format(round(out$AvgTot,2),nsmall=2)
out$ClassTotal=format(round(out$ClassTotal,2),nsmall=2)

## Prepend space for excel shenanigans?
#out$elgband=str_c(' ',out$elgband)

write.csv(out,str_c("D:/MySQL_KHIIS_OUT/gender0cnty1_ASTHM_Calc_Tot_CostofCare.csv"),row.names=FALSE)

#################
# ASTHM
# gender 1 county 0
#
#
out = tmp %>% group_by(gender,ageband,asthm,subyr) %>% 
  summarise(Med = median(as.numeric((TotCost))),
            AvgTot=
              ifelse( (sum(as.integer(membmo))==0),
                      ((sum(as.numeric(TotCost)))/(sqrt(n()))),
                      ((sum(as.numeric(TotCost)))/(sum(as.integer(membmo))/12))),
            ClassTotal=((sum(as.numeric(TotCost)))),ClassMemMo=(sum(as.integer(membmo))),ClassSize=n())


## Create fill for empty sets.
gndr=unique(out$gender)
age=unique(out$ageband)
asthm=unique(out$asthm)
year=unique(out$subyr)
fill=expand.grid(gndr,age,asthm,year,stringsAsFactors=FALSE)
setnames(fill,c("gender","ageband","asthm","subyr"))

assert_that(nrow(fill)==36)

out = full_join(out,fill)
# Replace Empty NA's with 0's.
out[is.na(out)]=0
out$Med = format(round(out$Med, 2), nsmall = 2)
out$AvgTot = format(round(out$AvgTot,2),nsmall=2)
out$ClassTotal=format(round(out$ClassTotal,2),nsmall=2)

## Prepend space for excel shenanigans?
#out$elgband=str_c(' ',out$elgband)

write.csv(out,str_c("D:/MySQL_KHIIS_OUT/gender1cnty0_ASTHM_Calc_Tot_CostofCare.csv"),row.names=FALSE)

#################
# ASTHM
# gender 0 county 0
#
#
out = tmp %>% group_by(ageband,asthm,subyr) %>% 
  summarise(Med = median(as.numeric((TotCost))),
            AvgTot=
              ifelse( (sum(as.integer(membmo))==0),
                      ((sum(as.numeric(TotCost)))/(sqrt(n()))),
                      ((sum(as.numeric(TotCost)))/(sum(as.integer(membmo))/12))),
            ClassTotal=((sum(as.numeric(TotCost)))),ClassMemMo=(sum(as.integer(membmo))),ClassSize=n())


## Create fill for empty sets.
age=unique(out$ageband)
asthm=unique(out$asthm)
year=unique(out$subyr)
fill=expand.grid(age,asthm,year,stringsAsFactors=FALSE)
setnames(fill,c("ageband","asthm","subyr"))

assert_that(nrow(fill)==18)

out = full_join(out,fill)
# Replace Empty NA's with 0's.
out[is.na(out)]=0
out$Med = format(round(out$Med, 2), nsmall = 2)
out$AvgTot = format(round(out$AvgTot,2),nsmall=2)
out$ClassTotal=format(round(out$ClassTotal,2),nsmall=2)

## Prepend space for excel shenanigans?
#out$elgband=str_c(' ',out$elgband)

write.csv(out,str_c("D:/MySQL_KHIIS_OUT/gender0cnty0_ASTHM_Calc_Tot_CostofCare.csv"),row.names=FALSE)
