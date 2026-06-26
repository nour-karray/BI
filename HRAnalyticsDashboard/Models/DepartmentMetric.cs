namespace HRAnalyticsDashboard.Models;

public class DepartmentMetric
{
    public string Department { get; set; } = string.Empty;
    public int EmployeeCount { get; set; }
    public decimal TotalSalary { get; set; }
    public int TotalAbsences { get; set; }
    public decimal AverageSatisfaction { get; set; }
    public decimal AverageEngagement { get; set; }
}
