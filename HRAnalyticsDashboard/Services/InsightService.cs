using HRAnalyticsDashboard.Models;

namespace HRAnalyticsDashboard.Services;

public class InsightService
{
    private readonly DashboardService _dashboardService;

    public InsightService(DashboardService dashboardService)
    {
        _dashboardService = dashboardService;
    }

    public async Task<List<InsightItem>> GenerateInsightsAsync()
    {
        var insights = new List<InsightItem>();

        var kpis = await _dashboardService.GetKpiSummaryAsync();
        var departments = await _dashboardService.GetEmployeesByDepartmentAsync();
        var salaries = await _dashboardService.GetSalaryByDepartmentAsync();
        var positions = await _dashboardService.GetAbsencesByPositionAsync();
        var managers = await _dashboardService.GetSatisfactionByManagerAsync();
        var recruitments = await _dashboardService.GetEngagementByRecruitmentAsync();
        var performances = await _dashboardService.GetProjectsByPerformanceAsync();
        var turnover = await _dashboardService.GetTurnoverByDepartmentAsync();

        if (departments.Count > 0)
        {
            var topDepartment = departments.OrderByDescending(x => x.EmployeeCount).First();
            var share = kpis.TotalEmployees == 0
                ? 0
                : Math.Round((decimal)topDepartment.EmployeeCount / kpis.TotalEmployees * 100m, 1);

            insights.Add(new InsightItem
            {
                Title = "Departement dominant",
                Description = $"{topDepartment.Department} concentre le plus grand nombre d'employes ({topDepartment.EmployeeCount}, soit {share} %).",
                Category = "Vue d'ensemble",
                Severity = share >= 40 ? "warning" : "info"
            });
        }

        if (salaries.Count > 0)
        {
            var highestSalary = salaries.OrderByDescending(x => x.TotalSalary).First();
            insights.Add(new InsightItem
            {
                Title = "Masse salariale maximale",
                Description = $"{highestSalary.Department} affiche la masse salariale la plus elevee ({highestSalary.TotalSalary:N0}).",
                Category = "Remuneration",
                Severity = "success"
            });
        }

        if (positions.Count > 0)
        {
            var mostAbsentPosition = positions.OrderByDescending(x => x.TotalAbsences).First();
            insights.Add(new InsightItem
            {
                Title = "Poste le plus absent",
                Description = $"{mostAbsentPosition.Position} cumule le plus grand volume d'absences ({mostAbsentPosition.TotalAbsences}).",
                Category = "Absenteisme",
                Severity = "warning"
            });
        }

        if (managers.Count > 0)
        {
            var bestManager = managers.OrderByDescending(x => x.AverageSatisfaction).First();
            insights.Add(new InsightItem
            {
                Title = "Manager le mieux note",
                Description = $"{bestManager.ManagerName} obtient la meilleure satisfaction moyenne ({bestManager.AverageSatisfaction:N2}).",
                Category = "Performance",
                Severity = "success"
            });
        }

        if (recruitments.Count > 0)
        {
            var bestSource = recruitments.OrderByDescending(x => x.AverageEngagement).First();
            insights.Add(new InsightItem
            {
                Title = "Source de recrutement la plus engagee",
                Description = $"{bestSource.RecruitmentSource} genere l'engagement moyen le plus eleve ({bestSource.AverageEngagement:N2}).",
                Category = "Recrutement",
                Severity = "info"
            });
        }

        if (performances.Count > 0)
        {
            var mostProductive = performances.OrderByDescending(x => x.TotalProjects).First();
            insights.Add(new InsightItem
            {
                Title = "Niveau de performance le plus productif",
                Description = $"{mostProductive.PerformanceScore} concentre le plus de projets speciaux ({mostProductive.TotalProjects}).",
                Category = "Performance",
                Severity = "success"
            });
        }

        if (turnover.Count > 0)
        {
            var highestTurnover = turnover.OrderByDescending(x => x.TerminationCount).First();
            insights.Add(new InsightItem
            {
                Title = "Departement le plus expose au turnover",
                Description = $"{highestTurnover.Department} presente le plus grand nombre de departs ({highestTurnover.TerminationCount}).",
                Category = "Remuneration",
                Severity = highestTurnover.TerminationCount > 0 ? "warning" : "info"
            });
        }

        return insights;
    }
}
