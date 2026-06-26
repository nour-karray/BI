namespace HRAnalyticsDashboard.Models;

public class PositionMetric
{
    public string Position { get; set; } = string.Empty;
    public int TotalAbsences { get; set; }
    public decimal AverageDaysLate { get; set; }
    public int EmployeeCount { get; set; }
}
