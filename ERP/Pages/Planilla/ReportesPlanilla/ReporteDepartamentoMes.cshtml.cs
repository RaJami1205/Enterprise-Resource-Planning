using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace ERP.Pages.Planilla.ReportesPlanilla
{
    public class ReporteDepartamentoMesModel : PageModel
    {
        public class Departamento
        {
            public string Id { get; set; }
            public string Nombre { get; set; }
        }

        public List<Departamento> Departamentos { get; set; } = new List<Departamento>();
        public List<(string Departamento, double MontoTotal)> PlanillaDepartamentoData { get; set; } = new List<(string, double)>();
        public string mensajeError = "";

        public void OnGet()
        {
            // Obtener la lista de departamentos
            var conexionBD = new Conexion();
            conexionBD.abrir();
            string sqlDepartamentos = "SELECT departamento_id, nombre FROM Departamento";
            SqlCommand command = conexionBD.obtenerComando(sqlDepartamentos);
            using (SqlDataReader reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    Departamentos.Add(new Departamento
                    {
                        Id = reader.GetInt32(0).ToString(),
                        Nombre = reader.GetString(1)
                    });
                }
            }
            conexionBD.cerrar();
        }

        public void OnPost()
        {
            string mes = Request.Form["Mes"];
            string departamentoId = Request.Form["DepartamentoId"];

            // Llamada a la función para obtener el monto por departamento y mes
            var conexionBD = new Conexion();
            conexionBD.abrir();
            string query = "SELECT Departamento, MontoTotal FROM ObtenerMontosPorDepartamentoMes(@Mes, @Departamento)";
            SqlCommand command = conexionBD.obtenerComando(query);
            command.Parameters.AddWithValue("@Mes", mes);
            command.Parameters.AddWithValue("@Departamento", departamentoId);

            try
            {
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        PlanillaDepartamentoData.Add((
                            reader.GetString(0),
                            reader.GetDouble(1)
                        ));
                    }
                }
            }
            catch (Exception ex)
            {
                mensajeError = ex.Message;
            }
            finally
            {
                conexionBD.cerrar();
            }

            // Repopular la lista de departamentos
            OnGet();
        }
    }
}
