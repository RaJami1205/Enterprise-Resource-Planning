
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;

namespace ERP.Pages.Planilla.ReportesPlanilla
{
    public class ReporteMesAñoModel : PageModel
    {
        public List<PlanillaMesAñoData> PlanillaMesAñoData { get; set; } = new List<PlanillaMesAñoData>();
        public string mensajeError = "";

        public void OnPost()
        {
            string fechaInicio = Request.Form["FechaInicio"];
            string fechaFin = Request.Form["FechaFin"];

            try
            {
                Conexion conexionBD = new Conexion();
                conexionBD.abrir();
                string query = "SELECT AñoMes, MontoTotal FROM ObtenerMontosPlanillaRangoFechas(@FechaInicio, @FechaFin)";
                SqlCommand command = conexionBD.obtenerComando(query);
                command.Parameters.AddWithValue("@FechaInicio", fechaInicio);
                command.Parameters.AddWithValue("@FechaFin", fechaFin);

                using (SqlDataReader reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        PlanillaMesAñoData.Add(new PlanillaMesAñoData
                        {
                            AñoMes = reader.GetString(0),
                            MontoTotal = reader.GetDouble(1)
                        });
                    }
                }
                conexionBD.cerrar();
            }
            catch (Exception ex)
            {
                mensajeError = "Error al obtener los datos de la base de datos: " + ex.Message;
            }
        }
    }

    public class PlanillaMesAñoData
    {
        public string AñoMes { get; set; }
        public double MontoTotal { get; set; }
    }
}
