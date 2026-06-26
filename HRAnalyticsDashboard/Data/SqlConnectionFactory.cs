using Microsoft.Data.SqlClient;

namespace HRAnalyticsDashboard.Data;

public class SqlConnectionFactory
{
    private readonly IConfiguration _configuration;

    public SqlConnectionFactory(IConfiguration configuration)
    {
        _configuration = configuration;
    }

    public SqlConnection CreateConnection()
    {
        var connectionString = _configuration.GetConnectionString("DW_RH")
            ?? throw new InvalidOperationException("La chaîne de connexion DW_RH est introuvable.");

        return new SqlConnection(connectionString);
    }
}
