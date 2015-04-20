USE [KHIIS]
GO
/****** Object:  Table [dbo].[KHIISSummaryFlatFile]    Script Date: 04/20/2015 10:17:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[KHIISSummaryFlatFile](
  [MembershipID] [char](30) NULL,
	[FamilyMembershipID] [char](2) NULL,
	[ClaimNumber] [char](20) NULL,
	[PatientIDNo] [char](4) NULL,
	[PatientMemberInitials] [char](3) NULL,
	[PatientDOB] [char](8) NULL,
	[PatientGenderCode] [char](1) NULL,
	[NAICNo] [char](6) NULL,
	[GroupNo] [char](30) NULL,
	[FirstDateOfService] [char](8) NULL,
	[LastdateOfService] [char](8) NULL,
	[DatePaid] [char](8) NULL,
	[DischargeStatus] [char](2) NULL,
	[Zipcode] [varchar](15) NULL,
	[ClaimReceived] [char](8) NULL,
	[PatientRelationshipCode] [char](2) NULL,
	[TotalCharges] [char](11) NULL,
	[TotalAllowed] [char](11) NULL,
	[TotalPaid] [char](11) NULL,
	[PrimaryDiagnosis] [char](6) NULL,
	[PresentonAdmitPrimary] [char](1) NULL,
	[SecondaryDiagnosis] [char](6) NULL,
	[PresentonAdmitSecondary] [char](1) NULL,
	[ThirdDiagnosis] [char](6) NULL,
	[PresentonAdmitThirdDiag] [char](1) NULL,
	[FourthDiagnosis] [char](6) NULL,
	[PresentonAdmitFourthDiag] [char](1) NULL,
	[FifthDiagnosis] [char](6) NULL,
	[PresentonAdmitFifthDiag] [char](1) NULL,
	[SixthDiagnosis] [char](6) NULL,
	[PresentonAdmitSixthDiag] [char](1) NULL,
	[SeventhDiagnosis] [char](6) NULL,
	[PresentonAdmitSeventhDiag] [char](1) NULL,
	[EighthDiagnosis] [char](6) NULL,
	[PresentonadmitEightdiag] [char](1) NULL,
	[NinthDiagnosis] [char](6) NULL,
	[PresentonAdmitNinthDiag] [char](1) NULL,
	[FirstProcedureCode] [char](6) NULL,
	[SecondProcedureCode] [char](6) NULL,
	[ThirdProcedureCode] [char](6) NULL,
	[FourthProcedureCode] [char](6) NULL,
	[FifthProcedureCode] [char](6) NULL,
	[DRGCODE] [char](3) NULL,
	[COORDBENEFITS] [char](1) NULL,
	[LineOfBusiness] [char](3) NULL,
	[ProviderDiscount] [char](11) NULL,
	[MemberResponsibility] [char](11) NULL,
	[PolicyNumber] [char](30) NULL,
	[PlanType] [char](1) NULL,
	[ProductType] [char](1) NULL,
	[InpLoadDate] [datetime] NULL,
	[SubmissionQtr] [int] NULL,
	[SubmissionYear] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF

USE [KHIIS]
GO
/****** Object:  Table [dbo].[KHIISMemberFlatFile]    Script Date: 04/20/2015 10:33:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[KHIISMemberFlatFile](
  [NAICNo] [char](6) NULL,
	[GroupNo] [char](30) NULL,
	[MembershipID] [char](30) NULL,
	[FamilyMembershipId] [char](2) NULL,
	[PatientIDNo] [char](4) NULL,
	[PatientMemberInitials] [varchar](3) NULL,
	[PatientDOB] [char](8) NULL,
	[PatientGenderCode] [char](1) NULL,
	[PatientRelationshipCode] [char](2) NULL,
	[PlanType] [char](1) NULL,
	[ProductType] [char](1) NULL,
	[ProductDescription] [char](1) NULL,
	[DrugCoverageInd] [char](1) NULL,
	[DentalCoverageInd] [char](1) NULL,
	[EligibilityStartDate] [char](8) NULL,
	[EligibilityEndDate] [char](8) NULL,
	[EligibileMonths] [char](2) NULL,
	[MonthlyPremium] [char](11) NULL,
	[PrimaryCarePhysician] [varchar](12) NULL,
	[MaxIndDeductibleFacility] [char](9) NULL,
	[MaxFamilyDeductibleFacility] [char](9) NULL,
	[CopayFacility] [char](9) NULL,
	[CoinsuranceFacility] [char](3) NULL,
	[MaxIndCoinsFacility] [char](9) NULL,
	[MaxFamilyCoinsFacility] [char](9) NULL,
	[MaxIndDeductibleProf] [char](9) NULL,
	[MaxFamilyDeductibleProf] [char](9) NULL,
	[CopayProf] [char](9) NULL,
	[CoinsuranceProf] [char](3) NULL,
	[MaxIndCoinsProf] [char](9) NULL,
	[MaxFamilyCoinsProf] [char](9) NULL,
	[MaxIndDeductibleOther] [char](9) NULL,
	[MaxFamilyDeductibleOther] [char](9) NULL,
	[CopayOther] [char](9) NULL,
	[CoinsuranceOther] [char](3) NULL,
	[MaxIndCoinsOther] [char](9) NULL,
	[MaxFamilyCoinsOther] [char](9) NULL,
	[MaxIndDeductibleComb] [char](9) NULL,
	[MaxFamilyDeductibleComb] [char](9) NULL,
	[CopayComb] [char](9) NULL,
	[CoinsuranceComb] [char](3) NULL,
	[MaxIndCoinsComb] [char](9) NULL,
	[MaxFamilyCoinsComb] [char](9) NULL,
	[DrugTierCode] [char](1) NULL,
	[DrugCopayGenericFormulary] [char](9) NULL,
	[DrugCopayGenericNonFormulary] [char](9) NULL,
	[DrugCopayBrandFormulary] [char](9) NULL,
	[DrugCopayBrandNonFormulary] [char](9) NULL,
	[DrugCopayOther] [char](9) NULL,
	[DrugCoinsPctGenericFormulary] [char](3) NULL,
	[DrugCoinsPctGenericNonFormulary] [char](3) NULL,
	[DrugCoinsPctBrandFormulary] [char](3) NULL,
	[DrugCoinsPctBrandNonFormulary] [char](3) NULL,
	[DrugCoinsPctOther] [char](3) NULL,
	[DrugIndDeductible] [char](9) NULL,
	[DrugFamilyDeductible] [char](9) NULL,
	[DrugIndCoins] [char](9) NULL,
	[DrugFamilyCoins] [char](9) NULL,
	[DentalIndDeductBasic] [char](9) NULL,
	[DentalFamilyDeductBasic] [char](9) NULL,
	[DentalIndCoinsBasic] [char](9) NULL,
	[DentalFamilyCoinsBasic] [char](9) NULL,
	[DentalCoinsPctBasic] [char](3) NULL,
	[DentalIndDeductBLA] [char](9) NULL,
	[DentalFamilyDeductBLA] [char](9) NULL,
	[DentalIndCoinsBLA] [char](9) NULL,
	[DentalFamilyCoinsBLA] [char](9) NULL,
	[DentalCoinsPctBLA] [char](3) NULL,
	[DentalIndDeductBLB] [char](9) NULL,
	[DentalFamilyDeductBLB] [char](9) NULL,
	[DentalIndCoinsBLB] [char](9) NULL,
	[DentalFamilyCoinsBLB] [char](9) NULL,
	[DentalCoinsPctBLB] [char](3) NULL,
	[DentalIndDeductBLC] [char](9) NULL,
	[DentalFamilyDeductBLC] [char](9) NULL,
	[DentalIndCoinsBLC] [char](9) NULL,
	[DentalFamilyCoinsBLC] [char](9) NULL,
	[DentalCoinsPctBLC] [char](3) NULL,
	[DentalIndDeductBLD] [char](9) NULL,
	[DentalFamilyDeductBLD] [char](9) NULL,
	[DentalIndCoinsBLD] [char](9) NULL,
	[DentalFamilyCoinsBLD] [char](9) NULL,
	[DentalCoinsPctBLD] [char](3) NULL,
	[BenefitPaymentPerDay] [char](9) NULL,
	[SpecialCoverageCodes] [char](9) NULL,
	[HSAIndicator] [char](1) NULL,
	[IndemnityAllowance] [char](9) NULL,
	[PolicyNumber] [char](30) NULL,
	[Zipcode] [char](15) NULL,
	[ErisaStatus] [char](1) NULL,
	[PhysicalRehabInpatientCopayfacility] [char](9) NULL,
	[PhysicalRehabInpatientCoinsuranceFacility] [char](3) NULL,
	[PhysicalRehabOutpatientCoinsurance] [char](3) NULL,
	[PhysicalRehabOfficeVisitCoinsurance] [char](3) NULL,
	[SameDayDiagnosticserviceCopay] [char](9) NULL,
	[OutpatientSurgeryCopay] [char](9) NULL,
	[InpatientCopay] [char](9) NULL,
	[OfficevisitCopay] [char](9) NULL,
	[EmergencyRoomcopay] [char](9) NULL,
	[StandardIndustryClass] [char](6) NULL,
	[InpLoadDate] [datetime] NULL,
	[SubmissionQtr] [int] NULL,
	[SubmissionYear] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF

USE [KHIIS]
GO
/****** Object:  Table [dbo].[KHIISProviderFlatFile]    Script Date: 04/20/2015 10:33:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[KHIISProviderFlatFile](
  [ProviderNumber] [varchar](12) NULL,
	[ProviderNumberType] [int] NULL,
	[ProviderOtherDescription] [varchar](35) NULL,
	[ProviderfirstName] [varchar](35) NULL,
	[ProviderLastName] [varchar](35) NULL,
	[ProviderOfficeName] [varchar](75) NULL,
	[ProviderAddress1] [varchar](35) NULL,
	[ProviderAddress2] [varchar](35) NULL,
	[Providercity] [varchar](35) NULL,
	[ProviderState] [varchar](2) NULL,
	[ProviderZip] [varchar](15) NULL,
	[ProviderCounty] [varchar](2) NULL,
	[NAICNO] [varchar](6) NULL,
	[InputLoaddate] [datetime] NULL,
	[SubmissionQtr] [int] NULL,
	[SubmissionYear] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF

USE [KHIIS]
GO
/****** Object:  Table [dbo].[KHIISSummaryFlatFile]    Script Date: 04/20/2015 10:33:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[KHIISSummaryFlatFile](
  [MembershipID] [char](30) NULL,
	[FamilyMembershipID] [char](2) NULL,
	[ClaimNumber] [char](20) NULL,
	[PatientIDNo] [char](4) NULL,
	[PatientMemberInitials] [char](3) NULL,
	[PatientDOB] [char](8) NULL,
	[PatientGenderCode] [char](1) NULL,
	[NAICNo] [char](6) NULL,
	[GroupNo] [char](30) NULL,
	[FirstDateOfService] [char](8) NULL,
	[LastdateOfService] [char](8) NULL,
	[DatePaid] [char](8) NULL,
	[DischargeStatus] [char](2) NULL,
	[Zipcode] [varchar](15) NULL,
	[ClaimReceived] [char](8) NULL,
	[PatientRelationshipCode] [char](2) NULL,
	[TotalCharges] [char](11) NULL,
	[TotalAllowed] [char](11) NULL,
	[TotalPaid] [char](11) NULL,
	[PrimaryDiagnosis] [char](6) NULL,
	[PresentonAdmitPrimary] [char](1) NULL,
	[SecondaryDiagnosis] [char](6) NULL,
	[PresentonAdmitSecondary] [char](1) NULL,
	[ThirdDiagnosis] [char](6) NULL,
	[PresentonAdmitThirdDiag] [char](1) NULL,
	[FourthDiagnosis] [char](6) NULL,
	[PresentonAdmitFourthDiag] [char](1) NULL,
	[FifthDiagnosis] [char](6) NULL,
	[PresentonAdmitFifthDiag] [char](1) NULL,
	[SixthDiagnosis] [char](6) NULL,
	[PresentonAdmitSixthDiag] [char](1) NULL,
	[SeventhDiagnosis] [char](6) NULL,
	[PresentonAdmitSeventhDiag] [char](1) NULL,
	[EighthDiagnosis] [char](6) NULL,
	[PresentonadmitEightdiag] [char](1) NULL,
	[NinthDiagnosis] [char](6) NULL,
	[PresentonAdmitNinthDiag] [char](1) NULL,
	[FirstProcedureCode] [char](6) NULL,
	[SecondProcedureCode] [char](6) NULL,
	[ThirdProcedureCode] [char](6) NULL,
	[FourthProcedureCode] [char](6) NULL,
	[FifthProcedureCode] [char](6) NULL,
	[DRGCODE] [char](3) NULL,
	[COORDBENEFITS] [char](1) NULL,
	[LineOfBusiness] [char](3) NULL,
	[ProviderDiscount] [char](11) NULL,
	[MemberResponsibility] [char](11) NULL,
	[PolicyNumber] [char](30) NULL,
	[PlanType] [char](1) NULL,
	[ProductType] [char](1) NULL,
	[InpLoadDate] [datetime] NULL,
	[SubmissionQtr] [int] NULL,
	[SubmissionYear] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF