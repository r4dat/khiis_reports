## Procedure Cost summaries.
library(data.table)
library(lubridate)
library(dplyr)
library(stringr)
library(assertthat)

base_path = 'D:/MySQL_KHIIS_OUT/'
file_string = '_Calc_CostofCare.csv'

options("scipen"=10)

## County, State, Year

if(!exists("readProcedureData", mode="function")) source("readData.R")

colo10 = readProcedureData(year_string = 2010,procedure =  "Colonoscopy")
colo11 = readProcedureData(year_string = 2011,procedure = "Colonoscopy")
colo12 = readProcedureData(year_string = 2012,procedure = "Colonoscopy")

hip10 = readProcedureData(year_string = 2010,procedure = "Hip")
hip11 = readProcedureData(year_string = 2011,procedure = "Hip")
hip12 = readProcedureData(year_string = 2012,procedure = "Hip")

gall10 = readProcedureData(year_string = 2010,procedure = "Gallbladder")
gall11 = readProcedureData(year_string = 2011,procedure = "Gallbladder")
gall12 = readProcedureData(year_string = 2012,procedure = "Gallbladder")

mammo10 = readProcedureData(year_string = 2010,procedure = "Mammo")
mammo11 = readProcedureData(year_string = 2011,procedure = "Mammo")
mammo12 = readProcedureData(year_string = 2012,procedure = "Mammo")

colo = rbind(colo10,colo11,colo12)
hip = rbind(hip10,hip11,hip12)
## Make up for mis-matched columsn with fill=TRUE
gall = rbind(gall10,gall11,gall12,fill=TRUE)
mammo = rbind(mammo10,mammo11,mammo12)

remove(colo10,colo11,colo12,hip10,hip11,hip12,gall10,gall11,gall12,mammo10,mammo11,mammo12)

out = colo %>% group_by(county,subyr) %>% summarise(median=median(TotCost),AvgTot=mean(TotCost),ClassSize=n()) %>% arrange(county,subyr)

write.csv(out,str_c(base_path,"Colon_Cnty_",file_string),row.names=FALSE)

out = colo %>% group_by(subyr) %>% summarise(median=median(TotCost),AvgTot=mean(TotCost),ClassSize=n()) %>% arrange(subyr)

write.csv(out,str_c(base_path,"Colon_State_",file_string),row.names=FALSE)

####################
out = hip %>% group_by(county,subyr) %>% summarise(median=median(TotCost),AvgTot=mean(TotCost),ClassSize=n()) %>% arrange(county,subyr)

write.csv(out,str_c(base_path,"Hip_Cnty_",file_string),row.names=FALSE)

out = hip %>% group_by(subyr) %>% summarise(median=median(TotCost),AvgTot=mean(TotCost),ClassSize=n()) %>% arrange(subyr)

write.csv(out,str_c(base_path,"Hip_State_",file_string),row.names=FALSE)

#####################

out = gall %>% group_by(county,subyr) %>% summarise(median=median(TotCost),AvgTot=mean(TotCost),ClassSize=n()) %>% arrange(county,subyr)

write.csv(out,str_c(base_path,"Gall_Cnty_",file_string),row.names=FALSE)

out = gall %>% group_by(subyr) %>% summarise(median=median(TotCost),AvgTot=mean(TotCost),ClassSize=n()) %>% arrange(subyr)

write.csv(out,str_c(base_path,"Gall_State_",file_string),row.names=FALSE)

#####################

out = mammo %>% group_by(county,subyr) %>% summarise(median=median(TotCost),AvgTot=mean(TotCost),ClassSize=n()) %>% arrange(county,subyr)

write.csv(out,str_c(base_path,"Gall_Cnty_",file_string),row.names=FALSE)

out = mammo %>% group_by(subyr) %>% summarise(median=median(TotCost),AvgTot=mean(TotCost),ClassSize=n()) %>% arrange(subyr)

write.csv(out,str_c(base_path,"Mammo_State_",file_string),row.names=FALSE)