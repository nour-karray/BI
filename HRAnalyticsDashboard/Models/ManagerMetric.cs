namespace HRAnalyticsDashboard.Models;

public class ManagerMetric
{
    public string ManagerName { get; set; } = string.Empty;
    public decimal AverageSatisfaction { get; set; }
    public decimal AverageEngagement { get; set; }
    public int EmployeeCount { get; set; }
}
