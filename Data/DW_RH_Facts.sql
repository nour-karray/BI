USE DW_RH;
GO

IF OBJECT_ID(N'dbo.FactAttendancePerformance', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.FactAttendancePerformance (
        AttendancePerformanceKey INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        EmpID INT NULL,
        DeptID INT NULL,
        PositionID INT NULL,
        ManagerID INT NULL,
        State NVARCHAR(10) NULL,
        Zip NVARCHAR(20) NULL,
        RecruitmentSource NVARCHAR(100) NULL,
        FromDiversityJobFairID INT NULL,
        PerfScoreID INT NULL,
        PerformanceScore NVARCHAR(50) NULL,
        DateofHire DATE NULL,
        LastPerformanceReview_Date DATE NULL,
        Absences INT NULL,
        DaysLateLast30 INT NULL,
        EngagementSurvey DECIMAL(5,2) NULL,
        EmpSatisfaction INT NULL,
        SpecialProjectsCount INT NULL
    );
END;
GO

IF COL_LENGTH(N'dbo.FactAttendancePerformance', N'RecruitmentSource') IS NULL
BEGIN
    ALTER TABLE dbo.FactAttendancePerformance
    ADD RecruitmentSource NVARCHAR(100) NULL;
END;
GO

IF COL_LENGTH(N'dbo.FactAttendancePerformance', N'PerformanceScore') IS NULL
BEGIN
    ALTER TABLE dbo.FactAttendancePerformance
    ADD PerformanceScore NVARCHAR(50) NULL;
END;
GO

IF OBJECT_ID(N'dbo.FactEmploymentCompensation', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.FactEmploymentCompensation (
        EmploymentCompensationKey INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        EmpID INT NULL,
        DeptID INT NULL,
        PositionID INT NULL,
        ManagerID INT NULL,
        State NVARCHAR(10) NULL,
        Zip NVARCHAR(20) NULL,
        DateofHire DATE NULL,
        DateofTermination DATE NULL,
        Salary DECIMAL(12,2) NULL,
        Termd INT NULL,
        Tenure INT NULL,
        TerminationFlag INT NULL
    );
END;
GO
