namespace HRAnalyticsDashboard.Models;

public class TurnoverMetric
{
    public string Department { get; set; } = string.Empty;
    public int TerminationCount { get; set; }
    public decimal AverageTenure { get; set; }
}
