USE [DW_RH];
GO

IF OBJECT_ID(N'dbo.DimEmployee', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.DimEmployee (
        EmployeeKey INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        EmpID INT NULL,
        Employee_Name NVARCHAR(100) NULL,
        Sex NVARCHAR(10) NULL,
        MaritalDesc NVARCHAR(50) NULL,
        CitizenDesc NVARCHAR(50) NULL,
        HispanicLatino NVARCHAR(20) NULL,
        RaceDesc NVARCHAR(100) NULL,
        DOB DATE NULL,
        Age INT NULL,
        AgeGroup NVARCHAR(20) NULL
    );
END;
GO

IF OBJECT_ID(N'dbo.DimDepartment', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.DimDepartment (
        DepartmentKey INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        DeptID INT NULL,
        Department NVARCHAR(100) NULL
    );
END;
GO

IF OBJECT_ID(N'dbo.DimPosition', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.DimPosition (
        PositionKey INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        PositionID INT NULL,
        Position NVARCHAR(100) NULL
    );
END;
GO

IF OBJECT_ID(N'dbo.DimManager', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.DimManager (
        ManagerKey INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        ManagerID INT NULL,
        ManagerName NVARCHAR(100) NULL
    );
END;
GO

IF OBJECT_ID(N'dbo.DimLocation', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.DimLocation (
        LocationKey INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        State NVARCHAR(10) NULL,
        Zip NVARCHAR(20) NULL
    );
END;
GO

IF OBJECT_ID(N'dbo.DimRecruitment', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.DimRecruitment (
        RecruitmentKey INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        RecruitmentSource NVARCHAR(100) NULL,
        FromDiversityJobFairID INT NULL
    );
END;
GO

IF OBJECT_ID(N'dbo.DimPerformance', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.DimPerformance (
        PerformanceKey INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        PerfScoreID INT NULL,
        PerformanceScore NVARCHAR(50) NULL
    );
END;
GO

IF OBJECT_ID(N'dbo.DimDate', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.DimDate (
        DateKey INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        FullDate DATE NULL
    );
END;
GO
