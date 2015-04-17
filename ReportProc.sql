-- --------------------------------------------------------------------------------
  -- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
  DELIMITER $$
  
  CREATE DEFINER=`user`@`localhost` PROCEDURE `ReportProc`(IN year_start char(8), IN year_end char(8))
BEGIN
SET @YEAR_STR=year_start;
SET @YEAR_END=year_end;

DROP TEMPORARY TABLE IF EXISTS dentoptclaims;
DROP TEMPORARY TABLE IF EXISTS tempyearlytable;
DROP TEMPORARY TABLE IF EXISTS adjclaims;
DROP TEMPORARY TABLE IF EXISTS tempmemb;
DROP TEMPORARY TABLE IF EXISTS yearlytable;
DROP TEMPORARY TABLE IF EXISTS memb_summ;
DROP TEMPORARY TABLE IF EXISTS claim_summ;


DROP TEMPORARY TABLE IF EXISTS gallbladder;
DROP TEMPORARY TABLE IF EXISTS hip;
DROP TEMPORARY TABLE IF EXISTS colonoscopy;
DROP TEMPORARY TABLE IF EXISTS mammo;



#458 Seconds 7.6 minutes
CREATE TEMPORARY TABLE IF NOT EXISTS 
dentoptclaims ( INDEX(uniqID,ClaimNumber) ) 
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
  AND  PlanType NOT IN('5','6') AND ProductType='1'
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
  LEFT JOIN dentoptclaims as b
  ON 	(a.uniqID = b.uniqID
       AND 
       a.ClaimNumber= b.ClaimNumber
  )
  WHERE b.ClaimNumber IS NULL
);

DROP TEMPORARY TABLE tempyearlytable;


## 409 Sec or 6.8 Minutes
CREATE TEMPORARY TABLE IF NOT EXISTS 
tempmemb ( INDEX(uniqID) ) 
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
  tempmemb
  WHERE statename='Kansas'
  AND  PlanType NOT IN('5','6') AND ProductType='1'
  AND SubmissionYear=LEFT(@YEAR_STR,4)
  GROUP BY uniqID);

DROP TEMPORARY TABLE tempmemb;

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
    CONVERT(SUM(yearlytable.TotalCharges)/100,Decimal(11,2)) as SmTotChg,
    CONVERT(SUM(yearlytable.TotalAllowed)/100,Decimal(11,2)) as SmTotAllwd,
    CONVERT(SUM(yearlytable.TotalPaid)/100,Decimal(11,2)) as SmTotPd,
    CONVERT(SUM(yearlytable.MemberResponsibility)/100,Decimal(11,2)) as MbrRsp,
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
  AND  PlanType NOT IN('5','6') AND ProductType='1'
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
  AND  PlanType NOT IN('5','6') AND ProductType='1'
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
  AND  PlanType NOT IN('5','6') AND ProductType='1'
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
  AND  PlanType NOT IN('5','6') AND ProductType='1'
  AND RevenueProcedureCode IN('G020','G0204','77052','77051','77057','77056')
);
#
#End Procedure Table Creation.
#
#################################
END