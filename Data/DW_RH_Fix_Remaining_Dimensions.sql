USE DW_RH;
GO

/*
Rattrapage des dimensions encore non propres apres chargement SSIS.

Important :
- ManagerID n'est pas parfaitement stable dans la source.
- Dans HRDataset_Clean_Validated.csv, ManagerID = 3 apparait avec 2 noms :
  Brandon R. LeBlanc
  Webster Butler

Si on impose ManagerID UNIQUE, il faut donc garder une seule ligne par ManagerID.
Ce script conserve la premiere ligne chargee (plus petit ManagerKey).
*/

/* 1. Supprimer les anciennes contraintes si elles existent */
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

/* 2. Dedupliquer DimManager sur ManagerID seul */
;WITH x AS (
    SELECT
        ManagerKey,
        ManagerID,
        ManagerName,
        ROW_NUMBER() OVER (PARTITION BY ManagerID ORDER BY ManagerKey) AS rn
    FROM dbo.DimManager
    WHERE ManagerID IS NOT NULL
)
DELETE FROM x
WHERE rn > 1;
GO

/* 3. Dedupliquer DimPerformance sur (PerfScoreID, PerformanceScore) */
;WITH x AS (
    SELECT
        PerformanceKey,
        PerfScoreID,
        PerformanceScore,
        ROW_NUMBER() OVER (
            PARTITION BY PerfScoreID, PerformanceScore
            ORDER BY PerformanceKey
        ) AS rn
    FROM dbo.DimPerformance
    WHERE PerfScoreID IS NOT NULL
      AND PerformanceScore IS NOT NULL
)
DELETE FROM x
WHERE rn > 1;
GO

/* 4. Dedupliquer DimRecruitment sur (RecruitmentSource, FromDiversityJobFairID) */
;WITH x AS (
    SELECT
        RecruitmentKey,
        RecruitmentSource,
        FromDiversityJobFairID,
        ROW_NUMBER() OVER (
            PARTITION BY RecruitmentSource, FromDiversityJobFairID
            ORDER BY RecruitmentKey
        ) AS rn
    FROM dbo.DimRecruitment
    WHERE RecruitmentSource IS NOT NULL
      AND FromDiversityJobFairID IS NOT NULL
)
DELETE FROM x
WHERE rn > 1;
GO

/* 5. Verifications */
SELECT COUNT(*) AS NbRows_DimManager FROM dbo.DimManager;
SELECT ManagerID, COUNT(*) AS Nb
FROM dbo.DimManager
GROUP BY ManagerID
HAVING COUNT(*) > 1;
GO

SELECT COUNT(*) AS NbRows_DimPerformance FROM dbo.DimPerformance;
SELECT PerfScoreID, PerformanceScore, COUNT(*) AS Nb
FROM dbo.DimPerformance
GROUP BY PerfScoreID, PerformanceScore
HAVING COUNT(*) > 1;
GO

SELECT COUNT(*) AS NbRows_DimRecruitment FROM dbo.DimRecruitment;
SELECT RecruitmentSource, FromDiversityJobFairID, COUNT(*) AS Nb
FROM dbo.DimRecruitment
GROUP BY RecruitmentSource, FromDiversityJobFairID
HAVING COUNT(*) > 1;
GO

/* 6. Contraintes finales */
IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = N'UQ_DimManager_ManagerID')
    ALTER TABLE dbo.DimManager ADD CONSTRAINT UQ_DimManager_ManagerID UNIQUE (ManagerID);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = N'UQ_DimPerformance_Perf')
    ALTER TABLE dbo.DimPerformance ADD CONSTRAINT UQ_DimPerformance_Perf UNIQUE (PerfScoreID, PerformanceScore);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = N'UQ_DimRecruitment_Source_JobFair')
    ALTER TABLE dbo.DimRecruitment ADD CONSTRAINT UQ_DimRecruitment_Source_JobFair UNIQUE (RecruitmentSource, FromDiversityJobFairID);
GO
