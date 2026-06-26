namespace HRAnalyticsDashboard.Models;

public class RecruitmentMetric
{
    public string RecruitmentSource { get; set; } = string.Empty;
    public int EmployeeCount { get; set; }
    public decimal AverageEngagement { get; set; }
    public decimal AverageSatisfaction { get; set; }
}
