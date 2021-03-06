library(data.table)
library(lubridate)
library(dplyr)
library(stringr)
library(assertthat)


readMembersData = function(year_string){
  base_path = 'D:/MySQL_KHIIS_OUT/'
  file_string = '_Raw_Members.csv'
  
  members <- fread(str_c(base_path,year_string,file_string), header = FALSE,na.strings = NULL,
                   stringsAsFactors = FALSE,showProgress = TRUE,
                   colClasses="character")
  
  setnames(members,c("uniqID","ageband","gender","county","elgband","membmo","subyr"))
  
  
  return(members)
  
}





readClaimsData = function(year_string){

  
  options("scipen"=10)
  
  base_path = 'D:/MySQL_KHIIS_OUT/'
  file_string = '_Raw_Claim_Summ.csv'
  
  claims <- fread(str_c(base_path,year_string,file_string), header = FALSE,na.strings = NULL,
                  stringsAsFactors = FALSE,showProgress = TRUE,
                  colClasses="character")
  
  
  setnames(claims,c("uniqID","ageband","gender","county","elgband","membmo","sumtotchg","sumtotallwd","sumtotpd","mbrsp","diab","chf","copd","asthm","subyr"))
  
  tmp = claims
  remove(claims)
  
## Comment out because SQL is now taking care of formats.  
  
#   tmp$sumtotchg =gsub(pattern = '^(.*)(.{2})$','\\1.\\2',tmp$sumtotchg)
#   tmp$sumtotallwd =gsub(pattern = '^(.*)(.{2})$','\\1.\\2',tmp$sumtotallwd)
#   tmp$sumtotpd =gsub(pattern = '^(.*)(.{2})$','\\1.\\2',tmp$sumtotpd)
#   tmp$mbrsp =gsub(pattern = '^(.*)(.{2})$','\\1.\\2',tmp$mbrsp)
#   
#   ## Remove special case of negative numbers. .-8, .-1 etc.
#   tmp$mbrsp = gsub(pattern='^(\\.)(-)','-.0',tmp$mbrsp)
  
  tmp = tmp %>% mutate(TotCost=as.numeric(sumtotpd)+as.numeric(mbrsp))
  

  return(tmp)
  
}


#' @param procedure Hip,Gall,Mammo,Colo 
readProcedureData = function(year_string,procedure){
  base_path = 'D:/MySQL_KHIIS_OUT/'
  file_string = '_Claim_Summ.csv'
  
  
  
  proc <- fread(str_c(base_path,year_string,'_',procedure,file_string), header = FALSE,na.strings = NULL,stringsAsFactors = FALSE,showProgress = TRUE,colClasses="character")
  
  tmp = proc
  remove(proc)
  
  ## Setname for gallbladder.
  if(length(tmp)==15){
  setnames(tmp,c("uniqID","PatientDOB","county","diab","chf","copd","asthm","sumtotchg","sumtotallwd","sumtotpd","mbrsp","coord","PlanType","ProductType","subyr"))
  }

  ## Setname for all except gallbladder.
  if(length(tmp)==24){
  setnames(tmp,c("uniqID","ClaimNumber","PatientDOB","county","PatientGenderCode","NAICNo","FirstDateOfService","LastdateOfService","DatePaid","Zipcode","ClaimReceived","diab","chf","copd","asthm","sumtotchg","sumtotallwd","sumtotpd","mbrsp","coord","PlanType","ProductType","SubmissionQtr","subyr"))
  }
  
#   tmp$sumtotchg =gsub(pattern = '^(.*)(.{2})$','\\1.\\2',tmp$sumtotchg)
#   tmp$sumtotallwd =gsub(pattern = '^(.*)(.{2})$','\\1.\\2',tmp$sumtotallwd)
#   tmp$sumtotpd =gsub(pattern = '^(.*)(.{2})$','\\1.\\2',tmp$sumtotpd)
#   tmp$mbrsp =gsub(pattern = '^(.*)(.{2})$','\\1.\\2',tmp$mbrsp)
#   
#   ## Remove special case of negative numbers. .-8, .-1 etc.
#   tmp$mbrsp = gsub(pattern='^(\\.)(-)','-.0',tmp$mbrsp)
  
  tmp = tmp %>% mutate(TotCost=as.numeric(sumtotpd)+as.numeric(mbrsp))
  
  return(tmp)
}