using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;
using System.Collections.Generic;
using System;

namespace ERP.Pages.Factura.Reporte
{
    public class ReporteDepartamentoComparativoModel : PageModel
    {
        public List<DepartamentoReporte> VentasData { get; set; } = new List<DepartamentoReporte>();
        public List<DepartamentoReporte> CotizacionesData { get; set; } = new List<DepartamentoReporte>();
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

                    // Obtener Ventas por Departamento
                    string queryVentas = "SELECT Departamento, CantidadVentas, MontoTotal FROM ObtenerVentasPorDepartamento(@FechaInicio, @FechaFin)";
                    SqlCommand commandVentas = conexionBD.obtenerComando(queryVentas);
                    commandVentas.Parameters.AddWithValue("@FechaInicio", FechaInicio);
                    commandVentas.Parameters.AddWithValue("@FechaFin", FechaFin);

                    SqlDataReader readerVentas = commandVentas.ExecuteReader();
                    while (readerVentas.Read())
                    {
                        VentasData.Add(new DepartamentoReporte
                        {
                            Departamento = readerVentas.GetString(0),
                            Cantidad = readerVentas.GetInt32(1),
                            MontoTotal = readerVentas.GetDouble(2)
                        });
                    }
                    readerVentas.Close();

                    // Obtener Cotizaciones por Departamento
                    string queryCotizaciones = "SELECT Departamento, CantidadCotizaciones, MontoTotal FROM ObtenerCotizacionesPorDepartamento(@FechaInicio, @FechaFin)";
                    SqlCommand commandCotizaciones = conexionBD.obtenerComando(queryCotizaciones);
                    commandCotizaciones.Parameters.AddWithValue("@FechaInicio", FechaInicio);
                    commandCotizaciones.Parameters.AddWithValue("@FechaFin", FechaFin);

                    SqlDataReader readerCotizaciones = commandCotizaciones.ExecuteReader();
                    while (readerCotizaciones.Read())
                    {
                        CotizacionesData.Add(new DepartamentoReporte
                        {
                            Departamento = readerCotizaciones.GetString(0),
                            Cantidad = readerCotizaciones.GetInt32(1),
                            MontoTotal = readerCotizaciones.GetDouble(2)
                        });
                    }
                    readerCotizaciones.Close();
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

        public class DepartamentoReporte
        {
            public string Departamento { get; set; }
            public int Cantidad { get; set; }
            public double MontoTotal { get; set; }
        }
    }
}
