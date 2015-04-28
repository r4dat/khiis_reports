CALL ReportProc('20120101','20121231');

SELECT 
    uniqID,
    AgeBand,
    PatientGenderCode as Gender,
    countynm as County,
    elg_band(SmElgMoMid) as ElgBand,
  SmElgMoMid,
  SubmissionYear
FROM
    memb_summ
WHERE PatientGenderCode IN ('M','F')
ORDER BY countynm

INTO OUTFILE 'D:\\MySQL_KHIIS_OUT\\2012_Raw_Members.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
;

SELECT 
  a.uniqID,
    AgeBand,
    a.PatientGenderCode,
	countynm AS County,
    elg_band(SmElgMoMid) as ElgBand,
	SmElgMoMid as MembMo,
	SmTotChg,
    SmTotAllwd,
    SmTotPd,
	MbrRsp,
	diab,
	chf,
	copd,
	asthm,
	a.SubmissionYear
	
FROM
    memb_summ as a JOIN claim_summ as b ON
	(a.uniqID=b.uniqID)
WHERE a.PatientGenderCode IN ('M','F')

INTO OUTFILE 'D:\\MySQL_KHIIS_OUT\\2012_Raw_Claim_Summ.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
;

SELECT 	
	b.uniqID,
    b.ClaimNumber,
    b.PatientDOB,
  countynm as County,
    b.PatientGenderCode,
    b.NAICNo,
    b.FirstDateOfService,
    b.LastdateOfService,
    b.DatePaid,
    b.Zipcode,
    b.ClaimReceived,
	MAX(diab) as diab,
	MAX(chf) as chf,
	MAX(copd) as copd,
	MAX(asthm) as asthm,
    CONVERT(SUM(b.TotalCharges)/100,Decimal(11,2)) as SmTotChg,
    CONVERT(SUM(b.TotalAllowed)/100,Decimal(11,2)) as SmTotAllwd,
    CONVERT(SUM(b.TotalPaid)/100,Decimal(11,2)) as SmTotPd,
    CONVERT(SUM(b.MemberResponsibility)/100,Decimal(11,2)) as MbrRsp,
    b.COORDBENEFITS,
    b.PlanType,
    b.ProductType,
    b.SubmissionQtr,
    b.SubmissionYear FROM gallbladder as a LEFT JOIN yearlytable as b ON a.uniqID=b.uniqID
AND 
(
 (a.servicedate between b.FirstDateofService and b.LastDateofService)
)
JOIN memb_summ as c ON a.uniqID=c.uniqID
WHERE b.PatientGenderCode IN ('M','F')
GROUP BY b.uniqID

INTO OUTFILE 'D:\\MySQL_KHIIS_OUT\\2012_Gallbladder_Claim_Summ.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
;

SELECT  
	b.uniqID,
	b.ClaimNumber,
    b.PatientDOB,
  countynm as County,
    b.PatientGenderCode,
    b.NAICNo,
    b.FirstDateOfService,
    b.LastdateOfService,
    b.DatePaid,
    b.Zipcode,
    b.ClaimReceived,
	MAX(diab) as diab,
	MAX(chf) as chf,
	MAX(copd) as copd,
	MAX(asthm) as asthm,
    CONVERT(SUM(b.TotalCharges)/100,Decimal(11,2)) as SmTotChg,
    CONVERT(SUM(b.TotalAllowed)/100,Decimal(11,2)) as SmTotAllwd,
    CONVERT(SUM(b.TotalPaid)/100,Decimal(11,2)) as SmTotPd,
    CONVERT(SUM(b.MemberResponsibility)/100,Decimal(11,2)) as MbrRsp,
    b.COORDBENEFITS,
    b.PlanType,
    b.ProductType,
    b.SubmissionQtr,
    b.SubmissionYear FROM hip as a LEFT JOIN yearlytable as b ON a.uniqID=b.uniqID
AND 
(
 (a.servicedate between b.FirstDateofService and b.LastDateofService)
)
JOIN memb_summ as c ON a.uniqID=c.uniqID
WHERE b.PatientGenderCode IN ('M','F')
GROUP BY b.uniqID

INTO OUTFILE 'D:\\MySQL_KHIIS_OUT\\2012_Hip_Claim_Summ.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
;

SELECT  
	b.uniqID,
	b.ClaimNumber,
    b.PatientDOB,
  countynm as County,
    b.PatientGenderCode,
    b.NAICNo,
    b.FirstDateOfService,
    b.LastdateOfService,
    b.DatePaid,
    b.Zipcode,
    b.ClaimReceived,
	MAX(diab) as diab,
	MAX(chf) as chf,
	MAX(copd) as copd,
	MAX(asthm) as asthm,
    CONVERT(SUM(b.TotalCharges)/100,Decimal(11,2)) as SmTotChg,
    CONVERT(SUM(b.TotalAllowed)/100,Decimal(11,2)) as SmTotAllwd,
    CONVERT(SUM(b.TotalPaid)/100,Decimal(11,2)) as SmTotPd,
    CONVERT(SUM(b.MemberResponsibility)/100,Decimal(11,2)) as MbrRsp,
    b.COORDBENEFITS,
    b.PlanType,
    b.ProductType,
    b.SubmissionQtr,
    b.SubmissionYear FROM colonoscopy as a LEFT JOIN yearlytable as b ON a.uniqID=b.uniqID
AND 
(
 (a.servicedate between b.FirstDateofService and b.LastDateofService)
)
JOIN memb_summ as c ON a.uniqID=c.uniqID
WHERE b.PatientGenderCode IN ('M','F')
GROUP BY b.uniqID

INTO OUTFILE 'D:\\MySQL_KHIIS_OUT\\2012_Colonoscopy_Claim_Summ.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
;

SELECT b.uniqID,
	b.ClaimNumber,
    b.PatientDOB,
  countynm as County,
    b.PatientGenderCode,
    b.NAICNo,
    b.FirstDateOfService,
    b.LastdateOfService,
    b.DatePaid,
    b.Zipcode,
    b.ClaimReceived,
	MAX(diab) as diab,
	MAX(chf) as chf,
	MAX(copd) as copd,
	MAX(asthm) as asthm,
    CONVERT(SUM(b.TotalCharges)/100,Decimal(11,2)) as SmTotChg,
    CONVERT(SUM(b.TotalAllowed)/100,Decimal(11,2)) as SmTotAllwd,
    CONVERT(SUM(b.TotalPaid)/100,Decimal(11,2)) as SmTotPd,
    CONVERT(SUM(b.MemberResponsibility)/100,Decimal(11,2)) as MbrRsp,
    b.COORDBENEFITS,
    b.PlanType,
    b.ProductType,
    b.SubmissionQtr,
    b.SubmissionYear FROM mammo as a LEFT JOIN yearlytable as b ON a.uniqID=b.uniqID
AND 
(
 (a.servicedate between b.FirstDateofService and b.LastDateofService)
)
JOIN memb_summ as c ON a.uniqID=c.uniqID
WHERE b.PatientGenderCode IN ('M','F')
GROUP BY b.uniqID

INTO OUTFILE 'D:\\MySQL_KHIIS_OUT\\2012_Mammo_Claim_Summ.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
;

CALL ReportProc('20110101','20111231');

SELECT 
    uniqID,
    AgeBand,
    PatientGenderCode as Gender,
    countynm as County,
    elg_band(SmElgMoMid) as ElgBand,
	SmElgMoMid,
	SubmissionYear
FROM
    memb_summ
WHERE PatientGenderCode IN ('M','F')
ORDER BY countynm

INTO OUTFILE 'D:\\MySQL_KHIIS_OUT\\2011_Raw_Members.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
;

SELECT 
	a.uniqID,
    AgeBand,
    a.PatientGenderCode,
	countynm AS County,
    elg_band(SmElgMoMid) as ElgBand,
	SmElgMoMid as MembMo,
	SmTotChg,
    SmTotAllwd,
    SmTotPd,
	MbrRsp,
	diab,
	chf,
	copd,
	asthm,
	a.SubmissionYear
	
FROM
    memb_summ as a JOIN claim_summ as b ON
	(a.uniqID=b.uniqID)
WHERE a.PatientGenderCode IN ('M','F')

INTO OUTFILE 'D:\\MySQL_KHIIS_OUT\\2011_Raw_Claim_Summ.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
;

SELECT 	
	b.uniqID,
    b.ClaimNumber,
    b.PatientDOB,
	countynm as County,
    b.PatientGenderCode,
    b.NAICNo,
    b.FirstDateOfService,
    b.LastdateOfService,
    b.DatePaid,
    b.Zipcode,
    b.ClaimReceived,
	MAX(diab) as diab,
	MAX(chf) as chf,
	MAX(copd) as copd,
	MAX(asthm) as asthm,
    CONVERT(SUM(b.TotalCharges)/100,Decimal(11,2)) as SmTotChg,
    CONVERT(SUM(b.TotalAllowed)/100,Decimal(11,2)) as SmTotAllwd,
    CONVERT(SUM(b.TotalPaid)/100,Decimal(11,2)) as SmTotPd,
    CONVERT(SUM(b.MemberResponsibility)/100,Decimal(11,2)) as MbrRsp,
    b.COORDBENEFITS,
    b.PlanType,
    b.ProductType,
    b.SubmissionQtr,
    b.SubmissionYear FROM gallbladder as a LEFT JOIN yearlytable as b ON a.uniqID=b.uniqID
AND 
(
 (a.servicedate between b.FirstDateofService and b.LastDateofService)
)
JOIN memb_summ as c ON a.uniqID=c.uniqID
WHERE b.PatientGenderCode IN ('M','F')
GROUP BY b.uniqID

INTO OUTFILE 'D:\\MySQL_KHIIS_OUT\\2011_Gallbladder_Claim_Summ.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
;

SELECT  
	b.uniqID,
	b.ClaimNumber,
    b.PatientDOB,
	countynm as County,
    b.PatientGenderCode,
    b.NAICNo,
    b.FirstDateOfService,
    b.LastdateOfService,
    b.DatePaid,
    b.Zipcode,
    b.ClaimReceived,
	MAX(diab) as diab,
	MAX(chf) as chf,
	MAX(copd) as copd,
	MAX(asthm) as asthm,
    CONVERT(SUM(b.TotalCharges)/100,Decimal(11,2)) as SmTotChg,
    CONVERT(SUM(b.TotalAllowed)/100,Decimal(11,2)) as SmTotAllwd,
    CONVERT(SUM(b.TotalPaid)/100,Decimal(11,2)) as SmTotPd,
    CONVERT(SUM(b.MemberResponsibility)/100,Decimal(11,2)) as MbrRsp,
    b.COORDBENEFITS,
    b.PlanType,
    b.ProductType,
    b.SubmissionQtr,
    b.SubmissionYear FROM hip as a LEFT JOIN yearlytable as b ON a.uniqID=b.uniqID
AND 
(
 (a.servicedate between b.FirstDateofService and b.LastDateofService)
)
JOIN memb_summ as c ON a.uniqID=c.uniqID
WHERE b.PatientGenderCode IN ('M','F')
GROUP BY b.uniqID

INTO OUTFILE 'D:\\MySQL_KHIIS_OUT\\2011_Hip_Claim_Summ.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
;

SELECT  
	b.uniqID,
	b.ClaimNumber,
    b.PatientDOB,
	countynm as County,
    b.PatientGenderCode,
    b.NAICNo,
    b.FirstDateOfService,
    b.LastdateOfService,
    b.DatePaid,
    b.Zipcode,
    b.ClaimReceived,
	MAX(diab) as diab,
	MAX(chf) as chf,
	MAX(copd) as copd,
	MAX(asthm) as asthm,
    CONVERT(SUM(b.TotalCharges)/100,Decimal(11,2)) as SmTotChg,
    CONVERT(SUM(b.TotalAllowed)/100,Decimal(11,2)) as SmTotAllwd,
    CONVERT(SUM(b.TotalPaid)/100,Decimal(11,2)) as SmTotPd,
    CONVERT(SUM(b.MemberResponsibility)/100,Decimal(11,2)) as MbrRsp,
    b.COORDBENEFITS,
    b.PlanType,
    b.ProductType,
    b.SubmissionQtr,
    b.SubmissionYear FROM colonoscopy as a LEFT JOIN yearlytable as b ON a.uniqID=b.uniqID
AND 
(
 (a.servicedate between b.FirstDateofService and b.LastDateofService)
)
JOIN memb_summ as c ON a.uniqID=c.uniqID
WHERE b.PatientGenderCode IN ('M','F')
GROUP BY b.uniqID

INTO OUTFILE 'D:\\MySQL_KHIIS_OUT\\2011_Colonoscopy_Claim_Summ.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
;

SELECT b.uniqID,
	b.ClaimNumber,
    b.PatientDOB,
	countynm as County,
    b.PatientGenderCode,
    b.NAICNo,
    b.FirstDateOfService,
    b.LastdateOfService,
    b.DatePaid,
    b.Zipcode,
    b.ClaimReceived,
	MAX(diab) as diab,
	MAX(chf) as chf,
	MAX(copd) as copd,
	MAX(asthm) as asthm,
    CONVERT(SUM(b.TotalCharges)/100,Decimal(11,2)) as SmTotChg,
    CONVERT(SUM(b.TotalAllowed)/100,Decimal(11,2)) as SmTotAllwd,
    CONVERT(SUM(b.TotalPaid)/100,Decimal(11,2)) as SmTotPd,
    CONVERT(SUM(b.MemberResponsibility)/100,Decimal(11,2)) as MbrRsp,
    b.COORDBENEFITS,
    b.PlanType,
    b.ProductType,
    b.SubmissionQtr,
    b.SubmissionYear FROM mammo as a LEFT JOIN yearlytable as b ON a.uniqID=b.uniqID
AND 
(
 (a.servicedate between b.FirstDateofService and b.LastDateofService)
)
JOIN memb_summ as c ON a.uniqID=c.uniqID
WHERE b.PatientGenderCode IN ('M','F')
GROUP BY b.uniqID

INTO OUTFILE 'D:\\MySQL_KHIIS_OUT\\2011_Mammo_Claim_Summ.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
;

CALL ReportProc('20100101','20101231');

SELECT 
    uniqID,
    AgeBand,
    PatientGenderCode as Gender,
    countynm as County,
    elg_band(SmElgMoMid) as ElgBand,
	SmElgMoMid,
	SubmissionYear
FROM
    memb_summ
WHERE PatientGenderCode IN ('M','F')
ORDER BY countynm

INTO OUTFILE 'D:\\MySQL_KHIIS_OUT\\2010_Raw_Members.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
;

SELECT 
	a.uniqID,
    AgeBand,
    a.PatientGenderCode,
	countynm AS County,
    elg_band(SmElgMoMid) as ElgBand,
	SmElgMoMid as MembMo,
	SmTotChg,
    SmTotAllwd,
    SmTotPd,
	MbrRsp,
	diab,
	chf,
	copd,
	asthm,
	a.SubmissionYear
	
FROM
    memb_summ as a JOIN claim_summ as b ON
	(a.uniqID=b.uniqID)
WHERE a.PatientGenderCode IN ('M','F')

INTO OUTFILE 'D:\\MySQL_KHIIS_OUT\\2010_Raw_Claim_Summ.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
;

SELECT 	
	b.uniqID,
	b.PatientDOB,
	countynm as County,
    MAX(diab) as diab,
    MAX(chf) as chf,
    MAX(copd) as copd,
    MAX(asthm) as asthm,
    CONVERT(SUM(b.TotalCharges)/100,Decimal(11,2)) as SmTotChg,
    CONVERT(SUM(b.TotalAllowed)/100,Decimal(11,2)) as SmTotAllwd,
    CONVERT(SUM(b.TotalPaid)/100,Decimal(11,2)) as SmTotPd,
    CONVERT(SUM(b.MemberResponsibility)/100,Decimal(11,2)) as MbrRsp,
    b.COORDBENEFITS,
    b.PlanType,
    b.ProductType,
    b.SubmissionYear FROM gallbladder as a LEFT JOIN yearlytable as b ON a.uniqID=b.uniqID
AND 
(
 (a.servicedate between b.FirstDateofService and b.LastDateofService)
)
JOIN memb_summ as c ON a.uniqID=c.uniqID
WHERE b.PatientGenderCode IN ('M','F')
GROUP BY b.uniqID

INTO OUTFILE 'D:\\MySQL_KHIIS_OUT\\2010_Gallbladder_Claim_Summ.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
;

SELECT  
	b.uniqID,
	b.ClaimNumber,
    b.PatientDOB,
	countynm as County,
    b.PatientGenderCode,
    b.NAICNo,
    b.FirstDateOfService,
    b.LastdateOfService,
    b.DatePaid,
    b.Zipcode,
    b.ClaimReceived,
	MAX(diab) as diab,
	MAX(chf) as chf,
	MAX(copd) as copd,
	MAX(asthm) as asthm,
    CONVERT(SUM(b.TotalCharges)/100,Decimal(11,2)) as SmTotChg,
    CONVERT(SUM(b.TotalAllowed)/100,Decimal(11,2)) as SmTotAllwd,
    CONVERT(SUM(b.TotalPaid)/100,Decimal(11,2)) as SmTotPd,
    CONVERT(SUM(b.MemberResponsibility)/100,Decimal(11,2)) as MbrRsp,
    b.COORDBENEFITS,
    b.PlanType,
    b.ProductType,
    b.SubmissionQtr,
    b.SubmissionYear FROM hip as a LEFT JOIN yearlytable as b ON a.uniqID=b.uniqID
AND 
(
 (a.servicedate between b.FirstDateofService and b.LastDateofService)
)
JOIN memb_summ as c ON a.uniqID=c.uniqID
WHERE b.PatientGenderCode IN ('M','F')
GROUP BY b.uniqID

INTO OUTFILE 'D:\\MySQL_KHIIS_OUT\\2010_Hip_Claim_Summ.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
;

SELECT  
	b.uniqID,
	b.ClaimNumber,
    b.PatientDOB,
	countynm as County,
    b.PatientGenderCode,
    b.NAICNo,
    b.FirstDateOfService,
    b.LastdateOfService,
    b.DatePaid,
    b.Zipcode,
    b.ClaimReceived,
	MAX(diab) as diab,
	MAX(chf) as chf,
	MAX(copd) as copd,
	MAX(asthm) as asthm,
    CONVERT(SUM(b.TotalCharges)/100,Decimal(11,2)) as SmTotChg,
    CONVERT(SUM(b.TotalAllowed)/100,Decimal(11,2)) as SmTotAllwd,
    CONVERT(SUM(b.TotalPaid)/100,Decimal(11,2)) as SmTotPd,
    CONVERT(SUM(b.MemberResponsibility)/100,Decimal(11,2)) as MbrRsp,
    b.COORDBENEFITS,
    b.PlanType,
    b.ProductType,
    b.SubmissionQtr,
    b.SubmissionYear FROM colonoscopy as a LEFT JOIN yearlytable as b ON a.uniqID=b.uniqID
AND 
(
 (a.servicedate between b.FirstDateofService and b.LastDateofService)
)
JOIN memb_summ as c ON a.uniqID=c.uniqID
WHERE b.PatientGenderCode IN ('M','F')
GROUP BY b.uniqID

INTO OUTFILE 'D:\\MySQL_KHIIS_OUT\\2010_Colonoscopy_Claim_Summ.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
;

SELECT b.uniqID,
	b.ClaimNumber,
    b.PatientDOB,
	countynm as County,
    b.PatientGenderCode,
    b.NAICNo,
    b.FirstDateOfService,
    b.LastdateOfService,
    b.DatePaid,
    b.Zipcode,
    b.ClaimReceived,
	MAX(diab) as diab,
	MAX(chf) as chf,
	MAX(copd) as copd,
	MAX(asthm) as asthm,
    CONVERT(SUM(b.TotalCharges)/100,Decimal(11,2)) as SmTotChg,
    CONVERT(SUM(b.TotalAllowed)/100,Decimal(11,2)) as SmTotAllwd,
    CONVERT(SUM(b.TotalPaid)/100,Decimal(11,2)) as SmTotPd,
    CONVERT(SUM(b.MemberResponsibility)/100,Decimal(11,2)) as MbrRsp,
    b.COORDBENEFITS,
    b.PlanType,
    b.ProductType,
    b.SubmissionQtr,
    b.SubmissionYear FROM mammo as a LEFT JOIN yearlytable as b ON a.uniqID=b.uniqID
AND 
(
 (a.servicedate between b.FirstDateofService and b.LastDateofService)
)
JOIN memb_summ as c ON a.uniqID=c.uniqID
WHERE b.PatientGenderCode IN ('M','F')
GROUP BY b.uniqID

INTO OUTFILE 'D:\\MySQL_KHIIS_OUT\\2010_Mammo_Claim_Summ.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
;
