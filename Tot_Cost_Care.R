library(data.table)
library(lubridate)
library(dplyr)
library(stringr)
library(assertthat)

options("scipen"=10)

base_path = 'D:/MySQL_KHIIS_OUT/'
file_string = '_Raw_Claim_Summ.csv'

if(!exists("readClaimsData", mode="function")) source("readData.R")

claims10 = readData(year_string='2010')
claims11 = readData(year_string='2011')
claims12 = readData(year_string='2012')

tmp = rbind(claims10,claims11,claims12)

out = tmp %>% group_by(gender,county,ageband,elgband,subyr) %>% 
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
elg=unique(out$elgband)
year=unique(out$subyr)
fill=expand.grid(gndr,cnty,age,elg,year,stringsAsFactors=FALSE)
setnames(fill,c("gender","county","ageband","elgband","subyr"))

assert_that(nrow(fill)==9450)

out = full_join(out,fill)
# Replace Empty NA's with 0's.
out[is.na(out)]=0

## Set rounding to 2 digits for dollar values.
out$Med = format(round(out$Med, 2), nsmall = 2)
out$AvgTot = format(round(out$AvgTot,2),nsmall=2)
out$ClassTotal=format(round(out$ClassTotal,2),nsmall=2)

## Prepend space for excel shenanigans?
out$elgband=str_c(' ',out$elgband)

write.csv(out,str_c("D:/MySQL_KHIIS_OUT/Calc_Tot_CostofCare.csv"),row.names=FALSE)


##########################################################
## NO GENDER
## Both genders -- eg dropping gender as grouping var.
out = tmp %>% group_by(county,ageband,elgband,subyr) %>% 
  summarise(Med = median(as.numeric((TotCost))),
            AvgTot=
              ifelse( (sum(as.integer(membmo))==0),
                      ((sum(as.numeric(TotCost)))/(sqrt(n()))),
                      ((sum(as.numeric(TotCost)))/(sum(as.integer(membmo))/12))),
            ClassTotal=((sum(as.numeric(TotCost)))),ClassMemMo=(sum(as.integer(membmo))),ClassSize=n())

## Create fill for empty sets.
cnty=unique(out$county)
age=unique(out$ageband)
elg=unique(out$elgband)
year=unique(out$subyr)
fill=expand.grid(cnty,age,elg,year,stringsAsFactors=FALSE)
setnames(fill,c("county","ageband","elgband","subyr"))

assert_that(nrow(fill)==4725)
nrow(fill)

out = full_join(out,fill)
# Replace Empty NA's with 0's.
out[is.na(out)]=0

## Set rounding to 2 digits for dollar values.
out$Med = format(round(out$Med, 2), nsmall = 2)
out$AvgTot = format(round(out$AvgTot,2),nsmall=2)
out$ClassTotal=format(round(out$ClassTotal,2),nsmall=2)

## Prepend space for excel shenanigans?
out$elgband=str_c(' ',out$elgband)

write.csv(out,str_c("D:/MySQL_KHIIS_OUT/0gender1cnty_Calc_Tot_CostofCare.csv"),row.names=FALSE)


###########################################################
## NO GENDER NO COUNTY
## Both genders -- eg dropping gender as grouping var.
out = tmp %>% group_by(ageband,elgband,subyr) %>% 
  summarise(Med = median(as.numeric((TotCost))),
            AvgTot=
              ifelse( (sum(as.integer(membmo))==0),
                      ((sum(as.numeric(TotCost)))/(sqrt(n()))),
                      ((sum(as.numeric(TotCost)))/(sum(as.integer(membmo))/12))),
            ClassTotal=((sum(as.numeric(TotCost)))),ClassMemMo=(sum(as.integer(membmo))),ClassSize=n())


## Create fill for empty sets.
age=unique(out$ageband)
elg=unique(out$elgband)
year=unique(out$subyr)
fill=expand.grid(age,elg,year,stringsAsFactors=FALSE)
setnames(fill,c("ageband","elgband","subyr"))

assert_that(nrow(fill)==45)
nrow(fill)

out = full_join(out,fill)
# Replace Empty NA's with 0's.
out[is.na(out)]=0

## Set rounding to 2 digits for dollar values.
out$Med = format(round(out$Med, 2), nsmall = 2)
out$AvgTot = format(round(out$AvgTot,2),nsmall=2)
out$ClassTotal=format(round(out$ClassTotal,2),nsmall=2)

## Prepend space for excel shenanigans?
out$elgband=str_c(' ',out$elgband)

write.csv(out,str_c("D:/MySQL_KHIIS_OUT/0gender0county_Calc_Tot_CostofCare.csv"),row.names=FALSE)


###################################################
##
##  +Gender, -County
##
##

out = tmp %>% group_by(gender,ageband,elgband,subyr) %>% 
  summarise(Med = median(as.numeric((TotCost))),
            AvgTot=
              ifelse( (sum(as.integer(membmo))==0),
                      ((sum(as.numeric(TotCost)))/(sqrt(n()))),
                      ((sum(as.numeric(TotCost)))/(sum(as.integer(membmo))/12))),
            ClassTotal=((sum(as.numeric(TotCost)))),ClassMemMo=(sum(as.integer(membmo))),ClassSize=n())


## Create fill for empty sets.
gndr=unique(out$gender)
age=unique(out$ageband)
elg=unique(out$elgband)
year=unique(out$subyr)
fill=expand.grid(gndr,age,elg,year,stringsAsFactors=FALSE)
setnames(fill,c("gender","ageband","elgband","subyr"))

assert_that(nrow(fill)==90)

out = full_join(out,fill)
# Replace Empty NA's with 0's.
out[is.na(out)]=0

## Set rounding to 2 digits for dollar values.
out$Med = format(round(out$Med, 2), nsmall = 2)
out$AvgTot = format(round(out$AvgTot,2),nsmall=2)
out$ClassTotal=format(round(out$ClassTotal,2),nsmall=2)

## Prepend space for excel shenanigans?
out$elgband=str_c(' ',out$elgband)

write.csv(out,str_c("D:/MySQL_KHIIS_OUT/1gndr0cnty_Calc_Tot_CostofCare.csv"),row.names=FALSE)
