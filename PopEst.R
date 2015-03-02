library(data.table)
library(lubridate)
library(dplyr)
library(stringr)
library(assertthat)
library(reshape2)

## County Totals Dataset: Population, Population Change and Estimated Components 
## of Population Change: April 1, 2010 to July 1, 2013
##
## http://www.census.gov/popest/data/counties/totals/2013/CO-EST2013-alldata.html
## Read in if not found in environment.
if(!exists("COEST13")) COEST13 = fread("CO-EST2013-Alldata.csv",stringsAsFactors=FALSE)

StateEst = COEST13 %>% filter(STNAME=='Kansas') %>% 
           select(CTYNAME,POPESTIMATE2010,POPESTIMATE2011,POPESTIMATE2012,
                  GQESTIMATES2010,GQESTIMATES2011,GQESTIMATES2012)

StateEst$CTYNAME=gsub(' County','',StateEst$CTYNAME)

## Make Long
StateEst=melt(StateEst)
## Create Year var from variable name.
StateEst = StateEst %>% mutate(year=str_extract(variable,'20\\d\\d'))
## Remove year from variable name.
StateEst$variable = gsub(pattern = '20\\d\\d','',StateEst$variable)
## Recast into wider format.
StateEst = dcast(StateEst,CTYNAME+year~variable) %>% mutate(adjpop=POPESTIMATE-GQESTIMATES)

setnames(StateEst,c("county","year","gqest","popest","adjpop"))