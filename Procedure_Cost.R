## Procedure Cost summaries.
library(data.table)
library(lubridate)
library(dplyr)
library(stringr)
library(assertthat)

options("scipen"=10)

if(!exists("readProcedureData", mode="function")) source("readData.R")

