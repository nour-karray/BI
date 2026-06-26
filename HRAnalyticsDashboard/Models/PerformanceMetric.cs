namespace HRAnalyticsDashboard.Models;

public class PerformanceMetric
{
    public string PerformanceScore { get; set; } = string.Empty;
    public int TotalProjects { get; set; }
    public decimal AverageSatisfaction { get; set; }
}
