namespace HRAnalyticsDashboard.Models;

public class DetailedAnalysisRow
{
    public int EmpId { get; set; }
    public string EmployeeName { get; set; } = string.Empty;
    public string Department { get; set; } = string.Empty;
    public string Position { get; set; } = string.Empty;
    public string ManagerName { get; set; } = string.Empty;
    public string RecruitmentSource { get; set; } = string.Empty;
    public string PerformanceScore { get; set; } = string.Empty;
    public string State { get; set; } = string.Empty;
    public decimal Salary { get; set; }
    public int Absences { get; set; }
    public decimal EmpSatisfaction { get; set; }
    public decimal EngagementSurvey { get; set; }
    public decimal Tenure { get; set; }
    public int TerminationFlag { get; set; }
}
