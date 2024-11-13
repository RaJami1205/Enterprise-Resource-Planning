using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Collections.Generic;
using System.Data.SqlClient;

namespace ERP.Pages.Planilla.Planilla_view
{
    public class PlanillaViewModel : PageModel
    {
        public List<PlanillaInfo> ListaPlanillas { get; set; } = new List<PlanillaInfo>();

        // Instancia de la conexión a la base de datos
        public Conexion conexionBD = new Conexion(); // Asume que tienes una clase de conexión configurada

        public void OnGet()
        {
            // Consultar la vista VistaPlanillaMensual para obtener los datos de la planilla
            try
            {
                conexionBD.abrir();

                string query = "SELECT Año, Mes, Cantidad_Salarios, Total_Pago FROM VistaPlanillaMensual";
                SqlCommand command = conexionBD.obtenerComando(query);

                using (SqlDataReader reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        PlanillaInfo planilla = new PlanillaInfo
                        {
                            Año = reader.GetInt32(0).ToString(),
                            Mes = reader.GetInt32(1).ToString(),
                            CantidadSalarios = reader.GetInt32(2).ToString(),
                            TotalPago = reader.GetDouble(3).ToString()
                        };
                        ListaPlanillas.Add(planilla);
                    }
                }
            }
            finally
            {
                conexionBD.cerrar();
            }
        }

        // Clase para representar cada fila de planilla
        public class PlanillaInfo
        {
            public string Año { get; set; }
            public string Mes { get; set; }
            public string CantidadSalarios { get; set; }
            public string TotalPago { get; set; }
        }
    }
}

