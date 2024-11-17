using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;
using System.Collections.Generic;
using System;

namespace ERP.Pages.Cliente.Reporte
{
    public class ReporteClientesVentasZonaModel : PageModel
    {
        public List<ZonaReporte> ClientesVentasZonaData { get; set; } = new List<ZonaReporte>();
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

                    string query = "SELECT Zona, CantidadClientes, MontoVentas FROM ObtenerClientesVentasPorZona(@FechaInicio, @FechaFin)";
                    SqlCommand command = conexionBD.obtenerComando(query);
                    command.Parameters.AddWithValue("@FechaInicio", FechaInicio);
                    command.Parameters.AddWithValue("@FechaFin", FechaFin);

                    SqlDataReader reader = command.ExecuteReader();
                    while (reader.Read())
                    {
                        ClientesVentasZonaData.Add(new ZonaReporte
                        {
                            Zona = reader.GetString(0),
                            CantidadClientes = reader.GetInt32(1),
                            MontoVentas = reader.GetDouble(2)
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

        public class ZonaReporte
        {
            public string Zona { get; set; }
            public int CantidadClientes { get; set; }
            public double MontoVentas { get; set; }
        }
    }
}
