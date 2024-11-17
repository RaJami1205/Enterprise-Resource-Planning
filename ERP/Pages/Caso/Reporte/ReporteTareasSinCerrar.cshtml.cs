using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;
using System.Collections.Generic;

namespace ERP.Pages.Caso.Reporte
{
    public class ReporteTareasSinCerrarModel : PageModel
    {
        public List<TareaSinCerrar> TareasSinCerrarData { get; set; } = new List<TareaSinCerrar>();
        public string mensajeError = "";

        public DateTime FechaInicio { get; set; }
        public DateTime FechaFin { get; set; }

        public void OnPost()
        {
            if (DateTime.TryParse(Request.Form["FechaInicio"], out DateTime fechaInicio) &&
                DateTime.TryParse(Request.Form["FechaFin"], out DateTime fechaFin))
            {
                FechaInicio = fechaInicio;
                FechaFin = fechaFin;

                Conexion conexionBD = new Conexion();
                try
                {
                    conexionBD.abrir();

                    string query = "SELECT codigo_tarea, NombreCuenta, FechaTarea, EstadoCaso FROM ObtenerTareasSinCerrar(@FechaInicio, @FechaFin)";
                    SqlCommand command = conexionBD.obtenerComando(query);
                    command.Parameters.AddWithValue("@FechaInicio", FechaInicio);
                    command.Parameters.AddWithValue("@FechaFin", FechaFin);

                    SqlDataReader reader = command.ExecuteReader();
                    while (reader.Read())
                    {
                        TareasSinCerrarData.Add(new TareaSinCerrar
                        {
                            CodigoTarea = reader.GetInt32(0),
                            NombreCuenta = reader.GetString(1),
                            FechaTarea = reader.GetDateTime(2),
                            EstadoCaso = reader.GetInt32(3)
                        });
                    }
                    reader.Close();
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
            else
            {
                mensajeError = "Por favor, ingrese un rango de fechas válido.";
            }
        }

        public class TareaSinCerrar
        {
            public int CodigoTarea { get; set; }
            public string NombreCuenta { get; set; }
            public DateTime FechaTarea { get; set; }
            public int EstadoCaso { get; set; }
        }
    }
}

