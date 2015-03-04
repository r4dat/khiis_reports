## Procedure Cost summaries.
library(data.table)
library(lubridate)
library(dplyr)
library(stringr)
library(assertthat)

options("scipen"=10)

## County, State, Year

if(!exists("readProcedureData", mode="function")) source("readData.R")

colo10 = readProcedureData(year_string = 2010,year_string = "Colonoscopy")
colo11 = readProcedureData(year_string = 2011,year_string = "Colonoscopy")
colo12 = readProcedureData(year_string = 2012,year_string = "Colonoscopy")

hip10 = readProcedureData(year_string = 2010,year_string = "Hip")
hip11 = readProcedureData(year_string = 2010,year_string = "Hip")
hip12 = readProcedureData(year_string = 2010,year_string = "Hip")

gall10 = readProcedureData(year_string = 2010,year_string = "Gallbladder")
gall11 = readProcedureData(year_string = 2010,year_string = "Gallbladder")
gall12 = readProcedureData(year_string = 2010,year_string = "Gallbladder")

mammo10 = readProcedureData(year_string = 2010,year_string = "Mammo")
mammo11 = readProcedureData(year_string = 2010,year_string = "Mammo")
mammo12 = readProcedureData(year_string = 2010,year_string = "Mammo")

colo = rbind(colo10,colo11,colo12)
hip = rbind(hip10,hip11,hip12)
gall = rbind(gall10,gall11,gall12)
mammo = rbind(mammo10,mammo11,mammo12)