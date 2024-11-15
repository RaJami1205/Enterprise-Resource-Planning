using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;
using System.Collections.Generic;
using System;

namespace ERP.Pages.Factura.Reporte
{
    public class ReporteZonaModel : PageModel
    {
        public List<ZonaVenta> ZonaVentaData { get; set; } = new List<ZonaVenta>();
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
                    string query = "SELECT Zona, MontoTotal FROM ObtenerVentasPorZona(@FechaInicio, @FechaFin)";
                    SqlCommand command = conexionBD.obtenerComando(query);
                    command.Parameters.AddWithValue("@FechaInicio", FechaInicio);
                    command.Parameters.AddWithValue("@FechaFin", FechaFin);

                    SqlDataReader reader = command.ExecuteReader();
                    while (reader.Read())
                    {
                        ZonaVentaData.Add(new ZonaVenta
                        {
                            Zona = reader.GetString(0),
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
            else
            {
                mensajeError = "Fechas no válidas.";
            }
        }

        public class ZonaVenta
        {
            public string Zona { get; set; }
            public double MontoTotal { get; set; }
        }
    }
}