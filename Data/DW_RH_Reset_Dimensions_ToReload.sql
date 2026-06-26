USE DW_RH;
GO

/*
Ce script prepare les dimensions a recharger depuis SSIS.
Il vise exactement :
- DimDepartment
- DimLocation
- DimPosition
- DimManager
- DimPerformance
- DimRecruitment
*/

/* 1. Supprimer d'eventuelles anciennes FK sur Location */
IF OBJECT_ID(N'dbo.FK_FactAttendancePerformance_DimLocation', N'F') IS NOT NULL
    ALTER TABLE dbo.FactAttendancePerformance DROP CONSTRAINT FK_FactAttendancePerformance_DimLocation;
GO

IF OBJECT_ID(N'dbo.FK_FactEmploymentCompensation_DimLocation', N'F') IS NOT NULL
    ALTER TABLE dbo.FactEmploymentCompensation DROP CONSTRAINT FK_FactEmploymentCompensation_DimLocation;
GO

/* 2. Reinitialiser completement DimLocation avec Zip en texte */
IF OBJECT_ID(N'dbo.DimLocation', N'U') IS NOT NULL
    DROP TABLE dbo.DimLocation;
GO

CREATE TABLE dbo.DimLocation (
    LocationKey INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    State NVARCHAR(10) NULL,
    Zip NVARCHAR(20) NULL
);
GO

/* 3. Vider les autres dimensions a recharger */
DELETE FROM dbo.DimDepartment;
GO

DELETE FROM dbo.DimPosition;
GO

DELETE FROM dbo.DimManager;
GO

DELETE FROM dbo.DimPerformance;
GO

DELETE FROM dbo.DimRecruitment;
GO

/* 4. Supprimer les anciennes contraintes UNIQUE pour pouvoir les recreer proprement apres chargement */
IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = N'UQ_DimDepartment_DeptID')
    ALTER TABLE dbo.DimDepartment DROP CONSTRAINT UQ_DimDepartment_DeptID;
GO

IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = N'UQ_DimPosition_PositionID')
    ALTER TABLE dbo.DimPosition DROP CONSTRAINT UQ_DimPosition_PositionID;
GO

IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = N'UQ_DimManager_ManagerID')
    ALTER TABLE dbo.DimManager DROP CONSTRAINT UQ_DimManager_ManagerID;
GO

IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = N'UQ_DimPerformance_PerfScoreID')
    ALTER TABLE dbo.DimPerformance DROP CONSTRAINT UQ_DimPerformance_PerfScoreID;
GO

IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = N'UQ_DimPerformance_PerfScore')
    ALTER TABLE dbo.DimPerformance DROP CONSTRAINT UQ_DimPerformance_PerfScore;
GO

IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = N'UQ_DimRecruitment_FromDiversityJobFairID')
    ALTER TABLE dbo.DimRecruitment DROP CONSTRAINT UQ_DimRecruitment_FromDiversityJobFairID;
GO

IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = N'UQ_DimRecruitment_Source_JobFair')
    ALTER TABLE dbo.DimRecruitment DROP CONSTRAINT UQ_DimRecruitment_Source_JobFair;
GO

IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = N'UQ_DimLocation_State_Zip')
    ALTER TABLE dbo.DimLocation DROP CONSTRAINT UQ_DimLocation_State_Zip;
GO

/* 5. Verification de structure avant rechargement */
SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME IN (
    'DimDepartment',
    'DimLocation',
    'DimPosition',
    'DimManager',
    'DimPerformance',
    'DimRecruitment'
)
ORDER BY TABLE_NAME, ORDINAL_POSITION;
GO
