using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Collections.Generic;
using System.Data.SqlClient;

namespace ERP.Pages.Cliente.Reporte
{
    public class ReporteTop10ClientesModel : PageModel
    {
        public List<ClienteReporte> TopClientesVentas { get; set; } = new List<ClienteReporte>();
        public string mensajeError = "";

        public void OnPost()
        {
            string fechaInicio = Request.Form["FechaInicio"];
            string fechaFin = Request.Form["FechaFin"];

            Conexion conexionBD = new Conexion();
            try
            {
                conexionBD.abrir();

                string query = "SELECT Cliente, MontoTotal FROM ObtenerTopClientesVentas(@FechaInicio, @FechaFin)";
                SqlCommand command = conexionBD.obtenerComando(query);
                command.Parameters.AddWithValue("@FechaInicio", fechaInicio);
                command.Parameters.AddWithValue("@FechaFin", fechaFin);

                SqlDataReader reader = command.ExecuteReader();
                while (reader.Read())
                {
                    TopClientesVentas.Add(new ClienteReporte
                    {
                        Cliente = reader.GetString(0),
                        MontoTotal = reader.GetDouble(1)
                    });
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
        }

        public class ClienteReporte
        {
            public string Cliente { get; set; }
            public double MontoTotal { get; set; }
        }
    }
}

