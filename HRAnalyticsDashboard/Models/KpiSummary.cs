namespace HRAnalyticsDashboard.Models;

public class KpiSummary
{
    public int TotalEmployees { get; set; }
    public decimal TotalSalary { get; set; }
    public decimal AverageSalary { get; set; }
    public int TotalAbsences { get; set; }
    public decimal AverageSatisfaction { get; set; }
    public decimal AverageEngagement { get; set; }
    public int TerminationCount { get; set; }
    public decimal AverageTenure { get; set; }
}
