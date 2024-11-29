using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Collections.Generic;
using System.Data.SqlClient;

namespace ERP.Pages.Planilla
{
    public class DetallesPlanillaModel : PageModel
    {

        public List<DetalleSalarioInfo> DetalleSalarios { get; set; } = new List<DetalleSalarioInfo>();

        public Conexion conexionBD = new Conexion();

        public void OnGet()
        {
            try
            {
                string Año=Request.Query["anno"];
                string Mes = Request.Query["mes"];
                conexionBD.abrir();
                // Llamada al procedimiento almacenado ObtenerSalariosMensuales
                string query = "EXEC ObtenerSalariosMensuales @Año, @Mes";
                SqlCommand command = conexionBD.obtenerComando(query);
                command.Parameters.AddWithValue("@Año", Año);
                command.Parameters.AddWithValue("@Mes", Mes);

                using (SqlDataReader reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        DetalleSalarios.Add(new DetalleSalarioInfo
                        {
                            CedulaEmpleado = reader.GetInt32(0).ToString(),
                            CantidadHoras = reader.GetInt32(1).ToString(),
                            Pago = reader.GetDouble(2).ToString()
                        });
                    }
                }
            }
            finally
            {
                conexionBD.cerrar();
            }
        }

        public class DetalleSalarioInfo
        {
            public string CedulaEmpleado { get; set; }
            public string CantidadHoras { get; set; }
            public string Pago { get; set; }
        }
    }
}
