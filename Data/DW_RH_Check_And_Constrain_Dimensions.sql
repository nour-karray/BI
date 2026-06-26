USE DW_RH;
GO

/* 1. Verifier les doublons */
SELECT DeptID, COUNT(*) AS DuplicateCount
FROM dbo.DimDepartment
GROUP BY DeptID
HAVING COUNT(*) > 1;
GO

SELECT State, Zip, COUNT(*) AS DuplicateCount
FROM dbo.DimLocation
GROUP BY State, Zip
HAVING COUNT(*) > 1;
GO

SELECT PositionID, COUNT(*) AS DuplicateCount
FROM dbo.DimPosition
GROUP BY PositionID
HAVING COUNT(*) > 1;
GO

SELECT ManagerID, COUNT(*) AS DuplicateCount
FROM dbo.DimManager
GROUP BY ManagerID
HAVING COUNT(*) > 1;
GO

SELECT PerfScoreID, PerformanceScore, COUNT(*) AS DuplicateCount
FROM dbo.DimPerformance
GROUP BY PerfScoreID, PerformanceScore
HAVING COUNT(*) > 1;
GO

SELECT RecruitmentSource, FromDiversityJobFairID, COUNT(*) AS DuplicateCount
FROM dbo.DimRecruitment
GROUP BY RecruitmentSource, FromDiversityJobFairID
HAVING COUNT(*) > 1;
GO

/* 2. Creer les contraintes UNIQUE seulement si les resultats ci-dessus sont vides */
IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = N'UQ_DimDepartment_DeptID')
    ALTER TABLE dbo.DimDepartment ADD CONSTRAINT UQ_DimDepartment_DeptID UNIQUE (DeptID);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = N'UQ_DimLocation_State_Zip')
    ALTER TABLE dbo.DimLocation ADD CONSTRAINT UQ_DimLocation_State_Zip UNIQUE (State, Zip);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = N'UQ_DimPosition_PositionID')
    ALTER TABLE dbo.DimPosition ADD CONSTRAINT UQ_DimPosition_PositionID UNIQUE (PositionID);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = N'UQ_DimManager_ManagerID')
    ALTER TABLE dbo.DimManager ADD CONSTRAINT UQ_DimManager_ManagerID UNIQUE (ManagerID);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = N'UQ_DimPerformance_PerfScore')
    ALTER TABLE dbo.DimPerformance ADD CONSTRAINT UQ_DimPerformance_PerfScore UNIQUE (PerfScoreID, PerformanceScore);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = N'UQ_DimRecruitment_Source_JobFair')
    ALTER TABLE dbo.DimRecruitment ADD CONSTRAINT UQ_DimRecruitment_Source_JobFair UNIQUE (RecruitmentSource, FromDiversityJobFairID);
GO
