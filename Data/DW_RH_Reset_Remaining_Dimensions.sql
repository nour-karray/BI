USE DW_RH;
GO

/*
Purge uniquement les dimensions qui affichent encore des doublons :
- DimPosition
- DimManager
- DimPerformance
- DimRecruitment
*/

IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = N'UQ_DimPosition_PositionID')
    ALTER TABLE dbo.DimPosition DROP CONSTRAINT UQ_DimPosition_PositionID;
GO

IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = N'UQ_DimManager_ManagerID')
    ALTER TABLE dbo.DimManager DROP CONSTRAINT UQ_DimManager_ManagerID;
GO

IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = N'UQ_DimPerformance_Perf')
    ALTER TABLE dbo.DimPerformance DROP CONSTRAINT UQ_DimPerformance_Perf;
GO

IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = N'UQ_DimPerformance_PerfScore')
    ALTER TABLE dbo.DimPerformance DROP CONSTRAINT UQ_DimPerformance_PerfScore;
GO

IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = N'UQ_DimRecruitment_Source_JobFair')
    ALTER TABLE dbo.DimRecruitment DROP CONSTRAINT UQ_DimRecruitment_Source_JobFair;
GO

IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = N'UQ_DimRecruitment_FromDiversityJobFairID')
    ALTER TABLE dbo.DimRecruitment DROP CONSTRAINT UQ_DimRecruitment_FromDiversityJobFairID;
GO

DELETE FROM dbo.DimPosition;
DBCC CHECKIDENT ('dbo.DimPosition', RESEED, 0);
GO

DELETE FROM dbo.DimManager;
DBCC CHECKIDENT ('dbo.DimManager', RESEED, 0);
GO

DELETE FROM dbo.DimPerformance;
DBCC CHECKIDENT ('dbo.DimPerformance', RESEED, 0);
GO

DELETE FROM dbo.DimRecruitment;
DBCC CHECKIDENT ('dbo.DimRecruitment', RESEED, 0);
GO

SELECT 'DimPosition' AS TableName, COUNT(*) AS NbRows FROM dbo.DimPosition
UNION ALL
SELECT 'DimManager', COUNT(*) FROM dbo.DimManager
UNION ALL
SELECT 'DimPerformance', COUNT(*) FROM dbo.DimPerformance
UNION ALL
SELECT 'DimRecruitment', COUNT(*) FROM dbo.DimRecruitment;
GO
