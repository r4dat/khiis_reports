## Procedure Cost summaries.
library(data.table)
library(lubridate)
library(dplyr)
library(stringr)
library(assertthat)

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
gall = rbind(gall10,gall11,gall12)
mammo = rbind(mammo10,mammo11,mammo12)