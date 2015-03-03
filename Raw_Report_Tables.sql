SET @YEAR_STR='20120101';
SET @YEAR_END='20121231';

DROP TEMPORARY TABLE dentclaims;
DROP TEMPORARY TABLE tempyearlytable;
DROP TEMPORARY TABLE adjclaims;
DROP TEMPORARY TABLE temp_table;
DROP TEMPORARY TABLE yearlytable;
DROP TEMPORARY TABLE memb_summ;
DROP TEMPORARY TABLE claim_summ;


DROP TEMPORARY TABLE gallbladder;
DROP TEMPORARY TABLE hip;
DROP TEMPORARY TABLE colonoscopy;
DROP TEMPORARY TABLE mammo;

##############
# Create temporary procedure tables.
#
#
CREATE TEMPORARY TABLE IF NOT EXISTS 
  gallbladder ( INDEX(uniqID,ClaimNumber) ) 
ENGINE=InnoDB 
AS(
SELECT 
  DISTINCT
	Concat(MembershipID,PatientDOB,PatientGenderCode,FamilyMembershipID) as uniqID,
	ClaimNumber,
	Servicedate,
	RevenueProcedureCode
FROM khiisdetailflatfile
WHERE Servicedate BETWEEN @YEAR_STR AND @YEAR_END 
AND PlanType NOT IN('5','6')
AND RevenueProcedureCode IN('47562','47563','47564')
);


CREATE TEMPORARY TABLE IF NOT EXISTS 
  hip ( INDEX(uniqID,ClaimNumber) ) 
ENGINE=InnoDB 
AS(
SELECT 
	DISTINCT
	Concat(MembershipID,PatientDOB,PatientGenderCode,FamilyMembershipID) as uniqID,
	ClaimNumber,
	Servicedate,
	RevenueProcedureCode
FROM khiisdetailflatfile
WHERE Servicedate BETWEEN @YEAR_STR AND @YEAR_END 
AND RevenueProcedureCode IN('27125','27130','27131','27132','27134','27135','27136','27137','27138')
);

CREATE TEMPORARY TABLE IF NOT EXISTS 
  colonoscopy ( INDEX(uniqID,ClaimNumber) ) 
ENGINE=InnoDB 
AS(
SELECT 
	DISTINCT
	Concat(MembershipID,PatientDOB,PatientGenderCode,FamilyMembershipID) as uniqID,
	ClaimNumber,
	Servicedate,
	RevenueProcedureCode
FROM khiisdetailflatfile
WHERE Servicedate BETWEEN @YEAR_STR AND @YEAR_END 
AND RevenueProcedureCode IN('G0104','G0105','G0121','45378','45330','45335','45380')
);

CREATE TEMPORARY TABLE IF NOT EXISTS 
  mammo ( INDEX(uniqID,ClaimNumber) ) 
ENGINE=InnoDB 
AS(
SELECT 
	DISTINCT
	Concat(MembershipID,PatientDOB,PatientGenderCode,FamilyMembershipID) as uniqID,
	ClaimNumber,
	Servicedate,
	RevenueProcedureCode
FROM khiisdetailflatfile
WHERE Servicedate BETWEEN @YEAR_STR AND @YEAR_END 
AND RevenueProcedureCode IN('G020','G0204','77052','77051','77057','77056')
);
#
#End Procedure Table Creation.
#
#################################


#458 Seconds 7.6 minutes
CREATE TEMPORARY TABLE IF NOT EXISTS 
  dentclaims ( INDEX(uniqID,ClaimNumber) ) 
ENGINE=InnoDB 
AS(
SELECT 
	DISTINCT
	Concat(MembershipID,PatientDOB,PatientGenderCode,FamilyMembershipID) as uniqID,
	ClaimNumber,
	Servicedate
FROM khiisdetailflatfile
WHERE Servicedate BETWEEN @YEAR_STR AND @YEAR_END 
AND 
(ProviderSpecialtyCode IN('DTA','DTH','DTL','DENT','OPH','OPT','OD','OTT')
OR 
TaxonomyCode IN('126800000X', '124Q00000X', '126900000X', '1223D0001X', 
'122300000X', '1223E0200X', '1223G0001X', '1223P0106X', '1223X0008X', 
'1223S0112X', '1223X0400X', '1223P0221X', '1223P0300X', '1223P0700X', '122400000X',
'152WC0802X','152WL0500X', '152WX0102X','152W00000X', '152WP0200X', 
'152WS0006X', '152WV0400X','156FC0800X', '156FC0801X', '156FX1700X', 
'156FX1100X', '156FX1101X', '156FX1800X', '156FX1201X', '156FX1202X', 
'156FX1900X','156F00000X')
)
);


## 448 Sec or 7.4 Minutes
CREATE TEMPORARY TABLE IF NOT EXISTS 
  adjclaims ( INDEX(uniqID,ClaimNumber,ServiceDate) ) 
ENGINE=InnoDB 
AS(
SELECT 
	DISTINCT
	Concat(MembershipID,PatientDOB,PatientGenderCode,FamilyMembershipID) as uniqID,
	ClaimNumber,
	Servicedate,
	ClaimActionType, PlanType,ProductType
FROM khiisdetailflatfile
WHERE (
		(Servicedate BETWEEN @YEAR_STR AND @YEAR_END) 
		AND 
		(ClaimActionType IN('NA','PA'))
	 )
);

## 1024 Sec or 17 Minutes
## Yearly Table
CREATE TEMPORARY TABLE IF NOT EXISTS 
  tempyearlytable ( INDEX(uniqID,ClaimNumber) ) 
ENGINE=InnoDB 
AS(
SELECT 
	Concat(MembershipID,PatientDOB,PatientGenderCode,FamilyMembershipID) as uniqID,
	 ClaimNumber,
    `PatientMemberInitials`,
    `PatientDOB`,
    `PatientGenderCode`,
    `NAICNo`,
    `FirstDateOfService`,
    `LastdateOfService`,
    `DatePaid`,
    `DischargeStatus`,
    `Zipcode`,
    `ClaimReceived`,
    `PatientRelationshipCode`,
    `TotalCharges`,
    `TotalAllowed`,
    `TotalPaid`,
    `PrimaryDiagnosis`,
    `PresentonAdmitPrimary`,
    `SecondaryDiagnosis`,
    `PresentonAdmitSecondary`,
    `ThirdDiagnosis`,
    `PresentonAdmitThirdDiag`,
    `FourthDiagnosis`,
    `PresentonAdmitFourthDiag`,
    `FifthDiagnosis`,
    `PresentonAdmitFifthDiag`,
    `SixthDiagnosis`,
    `PresentonAdmitSixthDiag`,
    `SeventhDiagnosis`,
    `PresentonAdmitSeventhDiag`,
    `EighthDiagnosis`,
    `PresentonadmitEightdiag`,
    `NinthDiagnosis`,
    `PresentonAdmitNinthDiag`,
    `FirstProcedureCode`,
    `SecondProcedureCode`,
    `ThirdProcedureCode`,
    `FourthProcedureCode`,
    `FifthProcedureCode`,
    `DRGCODE`,
    `COORDBENEFITS`,
    `LineOfBusiness`,
    `ProviderDiscount`,
    `MemberResponsibility`,
    `PolicyNumber`,
    `PlanType`,
    `ProductType`,
    `SubmissionQtr`,
    `SubmissionYear`
FROM khiissummaryflatfile
WHERE LastDateofService BETWEEN @YEAR_STR AND @YEAR_END
AND PlanType NOT IN('5','6')
);

CREATE TEMPORARY TABLE IF NOT EXISTS
yearlytable ( INDEX(uniqID,ClaimNumber,FirstDateOfService,LastdateOfService) ) 
ENGINE=InnoDB 
AS(
	SELECT a.*,
	IF((PrimaryDiagnosis REGEXP '^250.*')|(SecondaryDiagnosis REGEXP '^250.*')|(ThirdDiagnosis REGEXP '^250.*'),1,0) as 'diab',
	IF((PrimaryDiagnosis REGEXP '^428.*')|(SecondaryDiagnosis REGEXP '^428.*')|(ThirdDiagnosis REGEXP '^428.*'),1,0) as 'chf',
	IF((PrimaryDiagnosis REGEXP '^491.*')|(SecondaryDiagnosis REGEXP '^491.*')|(ThirdDiagnosis REGEXP '^491.*'),1,0) as 'copd',
	IF((PrimaryDiagnosis REGEXP '^493.*')|(SecondaryDiagnosis REGEXP '^493.*')|(ThirdDiagnosis REGEXP '^493.*'),1,0) as 'asthm'
	FROM tempyearlytable as a
	LEFT JOIN dentclaims as b
	ON 	(a.uniqID = b.uniqID
		AND 
		a.ClaimNumber= b.ClaimNumber
		)
	WHERE b.ClaimNumber IS NULL
    );

DROP TEMPORARY TABLE tempyearlytable;


## 409 Sec or 6.8 Minutes
CREATE TEMPORARY TABLE IF NOT EXISTS 
  temp_table ( INDEX(uniqID) ) 
ENGINE=InnoDB 
AS (
  SELECT 
	NAICNO,
    Concat(MembershipID,PatientDOB,PatientGenderCode,FamilyMembershipID) as uniqID,
	khiismemberflatfile.PatientDOB,
    age_band(khiismemberflatfile.PatientDOB, @YEAR_STR) as AgeBand,
    khiismemberflatfile.PatientGenderCode as 'PatientGenderCode',
    LEFT(TRIM(khiismemberflatfile.Zipcode),
        5) as 'fivezip',
	b.countynm,
	b.statename,
    khiismemberflatfile.EligibilityStartDate,
    khiismemberflatfile.EligibilityEndDate,
    ElgMoMid(khiismemberflatfile.EligibilityStartDate,
            khiismemberflatfile.EligibilityEndDate,
            khiismemberflatfile.SubmissionQtr,@YEAR_STR) as ElgMoMid,
    SubmissionQtr,
    SubmissionYear,
    PlanType,
    ProductType
FROM
    khiis.khiismemberflatfile
	LEFT JOIN zip as b
	ON(LEFT(TRIM(khiismemberflatfile.Zipcode),
        5)=b.zip)
WHERE
    EligibilityEndDate BETWEEN @YEAR_STR AND @YEAR_END   
ORDER BY uniqID,SubmissionQtr
);

CREATE TEMPORARY TABLE IF NOT EXISTS 
  memb_summ ( INDEX(uniqID) ) 
ENGINE=InnoDB 
AS (
  SELECT 
	uniqID,
	PatientDOB,
    AgeBand,
    PatientGenderCode,
    fivezip,
	countynm,
	statename,
    SUM(ElgMoMid) as SmElgMoMid,
    SubmissionQtr,
    SubmissionYear,
    PlanType,
    ProductType
FROM
    temp_table
	WHERE statename='Kansas'
	AND PlanType NOT IN('5','6')
	AND SubmissionYear=LEFT(@YEAR_STR,4)
GROUP BY uniqID);

DROP TEMPORARY TABLE temp_table;

CREATE TEMPORARY TABLE IF NOT EXISTS 
  claim_summ ( INDEX(uniqID,FirstDateOfService,LastdateOfService) ) 
ENGINE=InnoDB 
AS (SELECT 
	yearlytable.uniqID,
    yearlytable.ClaimNumber,
    yearlytable.PatientDOB,
    yearlytable.PatientGenderCode,
    yearlytable.NAICNo,
    yearlytable.FirstDateOfService,
    yearlytable.LastdateOfService,
    yearlytable.DatePaid,
    yearlytable.Zipcode,
    yearlytable.ClaimReceived,
	MAX(diab) as diab,
	MAX(chf) as chf,
	MAX(copd) as copd,
	MAX(asthm) as asthm,
    SUM(yearlytable.TotalCharges) as SmTotChg,
    SUM(yearlytable.TotalAllowed) as SmTotAllwd,
    SUM(yearlytable.TotalPaid) as SmTotPd,
    SUM(yearlytable.MemberResponsibility) as MbrRsp,
    yearlytable.COORDBENEFITS,
    yearlytable.PlanType,
    yearlytable.ProductType,
    yearlytable.SubmissionQtr,
    yearlytable.SubmissionYear
FROM
    khiis.yearlytable
        LEFT JOIN
    adjclaims as b ON (
		yearlytable.uniqID = b.uniqId
        AND yearlytable.PlanType = b.PlanType
        AND (
				(yearlytable.Claimnumber=b.ClaimNumber) OR 
				(b.servicedate BETWEEN yearlytable.FirstDateOfService AND yearlytable.LastDateOfService)
			)
	)
WHERE
        b.ClaimNumber IS NULL
GROUP BY uniqID);


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
    SUM(b.TotalCharges) as SmTotChg,
    SUM(b.TotalAllowed) as SmTotAllwd,
    SUM(b.TotalPaid) as SmTotPd,
    SUM(b.MemberResponsibility) as MbrRsp,
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
  countynm as County
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
    SUM(b.TotalCharges) as SmTotChg,
    SUM(b.TotalAllowed) as SmTotAllwd,
    SUM(b.TotalPaid) as SmTotPd,
    SUM(b.MemberResponsibility) as MbrRsp,
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
  countynm as County
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
    SUM(b.TotalCharges) as SmTotChg,
    SUM(b.TotalAllowed) as SmTotAllwd,
    SUM(b.TotalPaid) as SmTotPd,
    SUM(b.MemberResponsibility) as MbrRsp,
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
    SUM(b.TotalCharges) as SmTotChg,
    SUM(b.TotalAllowed) as SmTotAllwd,
    SUM(b.TotalPaid) as SmTotPd,
    SUM(b.MemberResponsibility) as MbrRsp,
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


SET @YEAR_STR='20110101';
SET @YEAR_END='20111231';

DROP TEMPORARY TABLE dentclaims;
DROP TEMPORARY TABLE tempyearlytable;
DROP TEMPORARY TABLE adjclaims;
DROP TEMPORARY TABLE temp_table;
DROP TEMPORARY TABLE yearlytable;
DROP TEMPORARY TABLE memb_summ;
DROP TEMPORARY TABLE claim_summ;


DROP TEMPORARY TABLE gallbladder;
DROP TEMPORARY TABLE hip;
DROP TEMPORARY TABLE colonoscopy;
DROP TEMPORARY TABLE mammo;

##############
# Create temporary procedure tables.
#
#
CREATE TEMPORARY TABLE IF NOT EXISTS 
  gallbladder ( INDEX(uniqID,ClaimNumber) ) 
ENGINE=InnoDB 
AS(
SELECT 
  DISTINCT
	Concat(MembershipID,PatientDOB,PatientGenderCode,FamilyMembershipID) as uniqID,
	ClaimNumber,
	Servicedate,
	RevenueProcedureCode
FROM khiisdetailflatfile
WHERE Servicedate BETWEEN @YEAR_STR AND @YEAR_END 
AND RevenueProcedureCode IN('47562','47563','47564')
);


CREATE TEMPORARY TABLE IF NOT EXISTS 
  hip ( INDEX(uniqID,ClaimNumber) ) 
ENGINE=InnoDB 
AS(
SELECT 
	DISTINCT
	Concat(MembershipID,PatientDOB,PatientGenderCode,FamilyMembershipID) as uniqID,
	ClaimNumber,
	Servicedate,
	RevenueProcedureCode
FROM khiisdetailflatfile
WHERE Servicedate BETWEEN @YEAR_STR AND @YEAR_END 
AND RevenueProcedureCode IN('27125','27130','27131','27132','27134','27135','27136','27137','27138')
);

CREATE TEMPORARY TABLE IF NOT EXISTS 
  colonoscopy ( INDEX(uniqID,ClaimNumber) ) 
ENGINE=InnoDB 
AS(
SELECT 
	DISTINCT
	Concat(MembershipID,PatientDOB,PatientGenderCode,FamilyMembershipID) as uniqID,
	ClaimNumber,
	Servicedate,
	RevenueProcedureCode
FROM khiisdetailflatfile
WHERE Servicedate BETWEEN @YEAR_STR AND @YEAR_END 
AND RevenueProcedureCode IN('G0104','G0105','G0121','45378','45330','45335','45380')
);

CREATE TEMPORARY TABLE IF NOT EXISTS 
  mammo ( INDEX(uniqID,ClaimNumber) ) 
ENGINE=InnoDB 
AS(
SELECT 
	DISTINCT
	Concat(MembershipID,PatientDOB,PatientGenderCode,FamilyMembershipID) as uniqID,
	ClaimNumber,
	Servicedate,
	RevenueProcedureCode
FROM khiisdetailflatfile
WHERE Servicedate BETWEEN @YEAR_STR AND @YEAR_END 
AND RevenueProcedureCode IN('G020','G0204','77052','77051','77057','77056')
);
#
#End Procedure Table Creation.
#
#################################

#458 Seconds 7.6 minutes
CREATE TEMPORARY TABLE IF NOT EXISTS 
  dentclaims ( INDEX(uniqID,ClaimNumber) ) 
ENGINE=InnoDB 
AS(
SELECT 
	DISTINCT
	Concat(MembershipID,PatientDOB,PatientGenderCode,FamilyMembershipID) as uniqID,
	ClaimNumber,
	Servicedate
FROM khiisdetailflatfile
WHERE Servicedate BETWEEN @YEAR_STR AND @YEAR_END 
AND 
(ProviderSpecialtyCode IN('DTA','DTH','DTL','DENT','OPH','OPT','OD','OTT')
OR 
TaxonomyCode IN('126800000X', '124Q00000X', '126900000X', '1223D0001X', 
'122300000X', '1223E0200X', '1223G0001X', '1223P0106X', '1223X0008X', 
'1223S0112X', '1223X0400X', '1223P0221X', '1223P0300X', '1223P0700X', '122400000X',
'152WC0802X','152WL0500X', '152WX0102X','152W00000X', '152WP0200X', 
'152WS0006X', '152WV0400X','156FC0800X', '156FC0801X', '156FX1700X', 
'156FX1100X', '156FX1101X', '156FX1800X', '156FX1201X', '156FX1202X', 
'156FX1900X','156F00000X')
)
);


## 448 Sec or 7.4 Minutes
CREATE TEMPORARY TABLE IF NOT EXISTS 
  adjclaims ( INDEX(uniqID,ClaimNumber,ServiceDate) ) 
ENGINE=InnoDB 
AS(
SELECT 
	DISTINCT
	Concat(MembershipID,PatientDOB,PatientGenderCode,FamilyMembershipID) as uniqID,
	ClaimNumber,
	Servicedate,
	ClaimActionType, PlanType,ProductType
FROM khiisdetailflatfile
WHERE (
		(Servicedate BETWEEN @YEAR_STR AND @YEAR_END) 
		AND 
		(ClaimActionType IN('NA','PA'))
	 )
);

## 1024 Sec or 17 Minutes
## Yearly Table
CREATE TEMPORARY TABLE IF NOT EXISTS 
  tempyearlytable ( INDEX(uniqID,ClaimNumber) ) 
ENGINE=InnoDB 
AS(
SELECT 
	Concat(MembershipID,PatientDOB,PatientGenderCode,FamilyMembershipID) as uniqID,
	 ClaimNumber,
    `PatientMemberInitials`,
    `PatientDOB`,
    `PatientGenderCode`,
    `NAICNo`,
    `FirstDateOfService`,
    `LastdateOfService`,
    `DatePaid`,
    `DischargeStatus`,
    `Zipcode`,
    `ClaimReceived`,
    `PatientRelationshipCode`,
    `TotalCharges`,
    `TotalAllowed`,
    `TotalPaid`,
    `PrimaryDiagnosis`,
    `PresentonAdmitPrimary`,
    `SecondaryDiagnosis`,
    `PresentonAdmitSecondary`,
    `ThirdDiagnosis`,
    `PresentonAdmitThirdDiag`,
    `FourthDiagnosis`,
    `PresentonAdmitFourthDiag`,
    `FifthDiagnosis`,
    `PresentonAdmitFifthDiag`,
    `SixthDiagnosis`,
    `PresentonAdmitSixthDiag`,
    `SeventhDiagnosis`,
    `PresentonAdmitSeventhDiag`,
    `EighthDiagnosis`,
    `PresentonadmitEightdiag`,
    `NinthDiagnosis`,
    `PresentonAdmitNinthDiag`,
    `FirstProcedureCode`,
    `SecondProcedureCode`,
    `ThirdProcedureCode`,
    `FourthProcedureCode`,
    `FifthProcedureCode`,
    `DRGCODE`,
    `COORDBENEFITS`,
    `LineOfBusiness`,
    `ProviderDiscount`,
    `MemberResponsibility`,
    `PolicyNumber`,
    `PlanType`,
    `ProductType`,
    `SubmissionQtr`,
    `SubmissionYear`
FROM khiissummaryflatfile
WHERE LastDateofService BETWEEN @YEAR_STR AND @YEAR_END
AND PlanType NOT IN('5','6')
);

CREATE TEMPORARY TABLE IF NOT EXISTS
yearlytable ( INDEX(uniqID,ClaimNumber,FirstDateOfService,LastdateOfService) ) 
ENGINE=InnoDB 
AS(
	SELECT a.*,
	IF((PrimaryDiagnosis REGEXP '^250.*')|(SecondaryDiagnosis REGEXP '^250.*')|(ThirdDiagnosis REGEXP '^250.*'),1,0) as 'diab',
	IF((PrimaryDiagnosis REGEXP '^428.*')|(SecondaryDiagnosis REGEXP '^428.*')|(ThirdDiagnosis REGEXP '^428.*'),1,0) as 'chf',
	IF((PrimaryDiagnosis REGEXP '^491.*')|(SecondaryDiagnosis REGEXP '^491.*')|(ThirdDiagnosis REGEXP '^491.*'),1,0) as 'copd',
	IF((PrimaryDiagnosis REGEXP '^493.*')|(SecondaryDiagnosis REGEXP '^493.*')|(ThirdDiagnosis REGEXP '^493.*'),1,0) as 'asthm'
	FROM tempyearlytable as a
	LEFT JOIN dentclaims as b
	ON 	(a.uniqID = b.uniqID
		AND 
		a.ClaimNumber= b.ClaimNumber
		)
	WHERE b.ClaimNumber IS NULL
    );

DROP TEMPORARY TABLE tempyearlytable;


## 409 Sec or 6.8 Minutes
CREATE TEMPORARY TABLE IF NOT EXISTS 
  temp_table ( INDEX(uniqID) ) 
ENGINE=InnoDB 
AS (
  SELECT 
	NAICNO,
    Concat(MembershipID,PatientDOB,PatientGenderCode,FamilyMembershipID) as uniqID,
	khiismemberflatfile.PatientDOB,
    age_band(khiismemberflatfile.PatientDOB, @YEAR_STR) as AgeBand,
    khiismemberflatfile.PatientGenderCode as 'PatientGenderCode',
    LEFT(TRIM(khiismemberflatfile.Zipcode),
        5) as 'fivezip',
	b.countynm,
	b.statename,
    khiismemberflatfile.EligibilityStartDate,
    khiismemberflatfile.EligibilityEndDate,
    ElgMoMid(khiismemberflatfile.EligibilityStartDate,
            khiismemberflatfile.EligibilityEndDate,
            khiismemberflatfile.SubmissionQtr,@YEAR_STR) as ElgMoMid,
    SubmissionQtr,
    SubmissionYear,
    PlanType,
    ProductType
FROM
    khiis.khiismemberflatfile
	LEFT JOIN zip as b
	ON(LEFT(TRIM(khiismemberflatfile.Zipcode),
        5)=b.zip)
WHERE
    EligibilityEndDate BETWEEN @YEAR_STR AND @YEAR_END   
ORDER BY uniqID,SubmissionQtr
);

CREATE TEMPORARY TABLE IF NOT EXISTS 
  memb_summ ( INDEX(uniqID) ) 
ENGINE=InnoDB 
AS (
  SELECT 
	uniqID,
	PatientDOB,
    AgeBand,
    PatientGenderCode,
    fivezip,
	countynm,
	statename,
    SUM(ElgMoMid) as SmElgMoMid,
    SubmissionQtr,
    SubmissionYear,
    PlanType,
    ProductType
FROM
    temp_table
	WHERE statename='Kansas'
	AND PlanType NOT IN('5','6')
	AND SubmissionYear=LEFT(@YEAR_STR,4)
GROUP BY uniqID);

DROP TEMPORARY TABLE temp_table;

CREATE TEMPORARY TABLE IF NOT EXISTS 
  claim_summ ( INDEX(uniqID,FirstDateOfService,LastdateOfService) ) 
ENGINE=InnoDB 
AS (SELECT 
	yearlytable.uniqID,
    yearlytable.ClaimNumber,
    yearlytable.PatientDOB,
    yearlytable.PatientGenderCode,
    yearlytable.NAICNo,
    yearlytable.FirstDateOfService,
    yearlytable.LastdateOfService,
    yearlytable.DatePaid,
    yearlytable.Zipcode,
    yearlytable.ClaimReceived,
	MAX(diab) as diab,
	MAX(chf) as chf,
	MAX(copd) as copd,
	MAX(asthm) as asthm,
    SUM(yearlytable.TotalCharges) as SmTotChg,
    SUM(yearlytable.TotalAllowed) as SmTotAllwd,
    SUM(yearlytable.TotalPaid) as SmTotPd,
    SUM(yearlytable.MemberResponsibility) as MbrRsp,
    yearlytable.COORDBENEFITS,
    yearlytable.PlanType,
    yearlytable.ProductType,
    yearlytable.SubmissionQtr,
    yearlytable.SubmissionYear
FROM
    khiis.yearlytable
        LEFT JOIN
    adjclaims as b ON (
		yearlytable.uniqID = b.uniqId
        AND yearlytable.PlanType = b.PlanType
        AND (
				(yearlytable.Claimnumber=b.ClaimNumber) OR 
				(b.servicedate BETWEEN yearlytable.FirstDateOfService AND yearlytable.LastDateOfService)
			)
	)
WHERE
        b.ClaimNumber IS NULL
GROUP BY uniqID);


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
    SUM(b.TotalCharges) as SmTotChg,
    SUM(b.TotalAllowed) as SmTotAllwd,
    SUM(b.TotalPaid) as SmTotPd,
    SUM(b.MemberResponsibility) as MbrRsp,
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
    SUM(b.TotalCharges) as SmTotChg,
    SUM(b.TotalAllowed) as SmTotAllwd,
    SUM(b.TotalPaid) as SmTotPd,
    SUM(b.MemberResponsibility) as MbrRsp,
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
    SUM(b.TotalCharges) as SmTotChg,
    SUM(b.TotalAllowed) as SmTotAllwd,
    SUM(b.TotalPaid) as SmTotPd,
    SUM(b.MemberResponsibility) as MbrRsp,
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
    SUM(b.TotalCharges) as SmTotChg,
    SUM(b.TotalAllowed) as SmTotAllwd,
    SUM(b.TotalPaid) as SmTotPd,
    SUM(b.MemberResponsibility) as MbrRsp,
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


SET @YEAR_STR='20100101';
SET @YEAR_END='20101231';

DROP TEMPORARY TABLE dentclaims;
DROP TEMPORARY TABLE tempyearlytable;
DROP TEMPORARY TABLE adjclaims;
DROP TEMPORARY TABLE temp_table;
DROP TEMPORARY TABLE yearlytable;
DROP TEMPORARY TABLE memb_summ;
DROP TEMPORARY TABLE claim_summ;


DROP TEMPORARY TABLE gallbladder;
DROP TEMPORARY TABLE hip;
DROP TEMPORARY TABLE colonoscopy;
DROP TEMPORARY TABLE mammo;

##############
# Create temporary procedure tables.
#
#
CREATE TEMPORARY TABLE IF NOT EXISTS 
  gallbladder ( INDEX(uniqID,ClaimNumber) ) 
ENGINE=InnoDB 
AS(
SELECT 
	DISTINCT
	Concat(MembershipID,PatientDOB,PatientGenderCode,FamilyMembershipID) as uniqID,
	ClaimNumber,
	Servicedate,
	RevenueProcedureCode
FROM khiisdetailflatfile
WHERE Servicedate BETWEEN @YEAR_STR AND @YEAR_END 
AND RevenueProcedureCode IN('47562','47563','47564')
);


CREATE TEMPORARY TABLE IF NOT EXISTS 
  hip ( INDEX(uniqID,ClaimNumber) ) 
ENGINE=InnoDB 
AS(
SELECT 
	DISTINCT
	Concat(MembershipID,PatientDOB,PatientGenderCode,FamilyMembershipID) as uniqID,
	ClaimNumber,
	Servicedate,
	RevenueProcedureCode
FROM khiisdetailflatfile
WHERE Servicedate BETWEEN @YEAR_STR AND @YEAR_END 
AND RevenueProcedureCode IN('27125','27130','27131','27132','27134','27135','27136','27137','27138')
);

CREATE TEMPORARY TABLE IF NOT EXISTS 
  colonoscopy ( INDEX(uniqID,ClaimNumber) ) 
ENGINE=InnoDB 
AS(
SELECT 
	DISTINCT
	Concat(MembershipID,PatientDOB,PatientGenderCode,FamilyMembershipID) as uniqID,
	ClaimNumber,
	Servicedate,
	RevenueProcedureCode
FROM khiisdetailflatfile
WHERE Servicedate BETWEEN @YEAR_STR AND @YEAR_END 
AND RevenueProcedureCode IN('G0104','G0105','G0121','45378','45330','45335','45380')
);

CREATE TEMPORARY TABLE IF NOT EXISTS 
  mammo ( INDEX(uniqID,ClaimNumber) ) 
ENGINE=InnoDB 
AS(
SELECT 
	DISTINCT
	Concat(MembershipID,PatientDOB,PatientGenderCode,FamilyMembershipID) as uniqID,
	ClaimNumber,
	Servicedate,
	RevenueProcedureCode
FROM khiisdetailflatfile
WHERE Servicedate BETWEEN @YEAR_STR AND @YEAR_END 
AND RevenueProcedureCode IN('G020','G0204','77052','77051','77057','77056')
);
#
#End Procedure Table Creation.
#
#################################

#458 Seconds 7.6 minutes
CREATE TEMPORARY TABLE IF NOT EXISTS 
  dentclaims ( INDEX(uniqID,ClaimNumber) ) 
ENGINE=InnoDB 
AS(
SELECT 
	DISTINCT
	Concat(MembershipID,PatientDOB,PatientGenderCode,FamilyMembershipID) as uniqID,
	ClaimNumber,
	Servicedate
FROM khiisdetailflatfile
WHERE Servicedate BETWEEN @YEAR_STR AND @YEAR_END 
AND 
(ProviderSpecialtyCode IN('DTA','DTH','DTL','DENT','OPH','OPT','OD','OTT')
OR 
TaxonomyCode IN('126800000X', '124Q00000X', '126900000X', '1223D0001X', 
'122300000X', '1223E0200X', '1223G0001X', '1223P0106X', '1223X0008X', 
'1223S0112X', '1223X0400X', '1223P0221X', '1223P0300X', '1223P0700X', '122400000X',
'152WC0802X','152WL0500X', '152WX0102X','152W00000X', '152WP0200X', 
'152WS0006X', '152WV0400X','156FC0800X', '156FC0801X', '156FX1700X', 
'156FX1100X', '156FX1101X', '156FX1800X', '156FX1201X', '156FX1202X', 
'156FX1900X','156F00000X')
)
);


## 448 Sec or 7.4 Minutes
CREATE TEMPORARY TABLE IF NOT EXISTS 
  adjclaims ( INDEX(uniqID,ClaimNumber,ServiceDate) ) 
ENGINE=InnoDB 
AS(
SELECT 
	DISTINCT
	Concat(MembershipID,PatientDOB,PatientGenderCode,FamilyMembershipID) as uniqID,
	ClaimNumber,
	Servicedate,
	ClaimActionType, PlanType,ProductType
FROM khiisdetailflatfile
WHERE (
		(Servicedate BETWEEN @YEAR_STR AND @YEAR_END) 
		AND 
		(ClaimActionType IN('NA','PA'))
	 )
);

## 1024 Sec or 17 Minutes
## Yearly Table
CREATE TEMPORARY TABLE IF NOT EXISTS 
  tempyearlytable ( INDEX(uniqID,ClaimNumber) ) 
ENGINE=InnoDB 
AS(
SELECT 
	Concat(MembershipID,PatientDOB,PatientGenderCode,FamilyMembershipID) as uniqID,
	 ClaimNumber,
    `PatientMemberInitials`,
    `PatientDOB`,
    `PatientGenderCode`,
    `NAICNo`,
    `FirstDateOfService`,
    `LastdateOfService`,
    `DatePaid`,
    `DischargeStatus`,
    `Zipcode`,
    `ClaimReceived`,
    `PatientRelationshipCode`,
    `TotalCharges`,
    `TotalAllowed`,
    `TotalPaid`,
    `PrimaryDiagnosis`,
    `PresentonAdmitPrimary`,
    `SecondaryDiagnosis`,
    `PresentonAdmitSecondary`,
    `ThirdDiagnosis`,
    `PresentonAdmitThirdDiag`,
    `FourthDiagnosis`,
    `PresentonAdmitFourthDiag`,
    `FifthDiagnosis`,
    `PresentonAdmitFifthDiag`,
    `SixthDiagnosis`,
    `PresentonAdmitSixthDiag`,
    `SeventhDiagnosis`,
    `PresentonAdmitSeventhDiag`,
    `EighthDiagnosis`,
    `PresentonadmitEightdiag`,
    `NinthDiagnosis`,
    `PresentonAdmitNinthDiag`,
    `FirstProcedureCode`,
    `SecondProcedureCode`,
    `ThirdProcedureCode`,
    `FourthProcedureCode`,
    `FifthProcedureCode`,
    `DRGCODE`,
    `COORDBENEFITS`,
    `LineOfBusiness`,
    `ProviderDiscount`,
    `MemberResponsibility`,
    `PolicyNumber`,
    `PlanType`,
    `ProductType`,
    `SubmissionQtr`,
    `SubmissionYear`
FROM khiissummaryflatfile
WHERE LastDateofService BETWEEN @YEAR_STR AND @YEAR_END
AND PlanType NOT IN('5','6')
);

CREATE TEMPORARY TABLE IF NOT EXISTS
yearlytable ( INDEX(uniqID,ClaimNumber,FirstDateOfService,LastdateOfService) ) 
ENGINE=InnoDB 
AS(
	SELECT a.*,
	IF((PrimaryDiagnosis REGEXP '^250.*')|(SecondaryDiagnosis REGEXP '^250.*')|(ThirdDiagnosis REGEXP '^250.*'),1,0) as 'diab',
	IF((PrimaryDiagnosis REGEXP '^428.*')|(SecondaryDiagnosis REGEXP '^428.*')|(ThirdDiagnosis REGEXP '^428.*'),1,0) as 'chf',
	IF((PrimaryDiagnosis REGEXP '^491.*')|(SecondaryDiagnosis REGEXP '^491.*')|(ThirdDiagnosis REGEXP '^491.*'),1,0) as 'copd',
	IF((PrimaryDiagnosis REGEXP '^493.*')|(SecondaryDiagnosis REGEXP '^493.*')|(ThirdDiagnosis REGEXP '^493.*'),1,0) as 'asthm'
	FROM tempyearlytable as a
	LEFT JOIN dentclaims as b
	ON 	(a.uniqID = b.uniqID
		AND 
		a.ClaimNumber= b.ClaimNumber
		)
	WHERE b.ClaimNumber IS NULL
    );

DROP TEMPORARY TABLE tempyearlytable;


## 409 Sec or 6.8 Minutes
CREATE TEMPORARY TABLE IF NOT EXISTS 
  temp_table ( INDEX(uniqID) ) 
ENGINE=InnoDB 
AS (
  SELECT 
	NAICNO,
    Concat(MembershipID,PatientDOB,PatientGenderCode,FamilyMembershipID) as uniqID,
	khiismemberflatfile.PatientDOB,
    age_band(khiismemberflatfile.PatientDOB, @YEAR_STR) as AgeBand,
    khiismemberflatfile.PatientGenderCode as 'PatientGenderCode',
    LEFT(TRIM(khiismemberflatfile.Zipcode),
        5) as 'fivezip',
	b.countynm,
	b.statename,
    khiismemberflatfile.EligibilityStartDate,
    khiismemberflatfile.EligibilityEndDate,
    ElgMoMid(khiismemberflatfile.EligibilityStartDate,
            khiismemberflatfile.EligibilityEndDate,
            khiismemberflatfile.SubmissionQtr,@YEAR_STR) as ElgMoMid,
    SubmissionQtr,
    SubmissionYear,
    PlanType,
    ProductType
FROM
    khiis.khiismemberflatfile
	LEFT JOIN zip as b
	ON(LEFT(TRIM(khiismemberflatfile.Zipcode),
        5)=b.zip)
WHERE
    EligibilityEndDate BETWEEN @YEAR_STR AND @YEAR_END   
ORDER BY uniqID,SubmissionQtr
);

CREATE TEMPORARY TABLE IF NOT EXISTS 
  memb_summ ( INDEX(uniqID) ) 
ENGINE=InnoDB 
AS (
  SELECT 
	uniqID,
	PatientDOB,
    AgeBand,
    PatientGenderCode,
    fivezip,
	countynm,
	statename,
    SUM(ElgMoMid) as SmElgMoMid,
    SubmissionQtr,
    SubmissionYear,
    PlanType,
    ProductType
FROM
    temp_table
	WHERE statename='Kansas'
	AND PlanType NOT IN('5','6')
	AND SubmissionYear=LEFT(@YEAR_STR,4)
GROUP BY uniqID);

DROP TEMPORARY TABLE temp_table;

CREATE TEMPORARY TABLE IF NOT EXISTS 
  claim_summ ( INDEX(uniqID,FirstDateOfService,LastdateOfService) ) 
ENGINE=InnoDB 
AS (SELECT 
	yearlytable.uniqID,
    yearlytable.ClaimNumber,
    yearlytable.PatientDOB,
    yearlytable.PatientGenderCode,
    yearlytable.NAICNo,
    yearlytable.FirstDateOfService,
    yearlytable.LastdateOfService,
    yearlytable.DatePaid,
    yearlytable.Zipcode,
    yearlytable.ClaimReceived,
	MAX(diab) as diab,
	MAX(chf) as chf,
	MAX(copd) as copd,
	MAX(asthm) as asthm,
    SUM(yearlytable.TotalCharges) as SmTotChg,
    SUM(yearlytable.TotalAllowed) as SmTotAllwd,
    SUM(yearlytable.TotalPaid) as SmTotPd,
    SUM(yearlytable.MemberResponsibility) as MbrRsp,
    yearlytable.COORDBENEFITS,
    yearlytable.PlanType,
    yearlytable.ProductType,
    yearlytable.SubmissionQtr,
    yearlytable.SubmissionYear
FROM
    khiis.yearlytable
        LEFT JOIN
    adjclaims as b ON (
		yearlytable.uniqID = b.uniqId
        AND yearlytable.PlanType = b.PlanType
        AND (
				(yearlytable.Claimnumber=b.ClaimNumber) OR 
				(b.servicedate BETWEEN yearlytable.FirstDateOfService AND yearlytable.LastDateOfService)
			)
	)
WHERE
        b.ClaimNumber IS NULL
GROUP BY uniqID);


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
	a.PatientDOB,
	countynm as County,
    SUM(b.TotalCharges) as SmTotChg,
    SUM(b.TotalAllowed) as SmTotAllwd,
    SUM(b.TotalPaid) as SmTotPd,
    SUM(b.MemberResponsibility) as MbrRsp,
    MAX(diab) as diab,
    MAX(chf) as chf,
    MAX(copd) as copd,
    MAX(asthm) as asthm,
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
    SUM(b.TotalCharges) as SmTotChg,
    SUM(b.TotalAllowed) as SmTotAllwd,
    SUM(b.TotalPaid) as SmTotPd,
    SUM(b.MemberResponsibility) as MbrRsp,
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
    SUM(b.TotalCharges) as SmTotChg,
    SUM(b.TotalAllowed) as SmTotAllwd,
    SUM(b.TotalPaid) as SmTotPd,
    SUM(b.MemberResponsibility) as MbrRsp,
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
	MAX(asthm) as asthm
    SUM(b.TotalCharges) as SmTotChg,
    SUM(b.TotalAllowed) as SmTotAllwd,
    SUM(b.TotalPaid) as SmTotPd,
    SUM(b.MemberResponsibility) as MbrRsp,
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