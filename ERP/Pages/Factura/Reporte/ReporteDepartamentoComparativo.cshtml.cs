using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;
using System.Collections.Generic;
using System.Linq;
using System;

namespace ERP.Pages.Factura.Reporte
{
    public class ReporteDepartamentoComparativoModel : PageModel
    {
        public List<DepartamentoReporte> ComparativoData { get; set; } = new List<DepartamentoReporte>();
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

                    var ventasData = new List<DepartamentoReporte>();
                    var cotizacionesData = new List<DepartamentoReporte>();

                    // Obtener Ventas por Departamento
                    string queryVentas = "SELECT Departamento, CantidadVentas, MontoTotal FROM ObtenerVentasPorDepartamento(@FechaInicio, @FechaFin)";
                    SqlCommand commandVentas = conexionBD.obtenerComando(queryVentas);
                    commandVentas.Parameters.AddWithValue("@FechaInicio", FechaInicio);
                    commandVentas.Parameters.AddWithValue("@FechaFin", FechaFin);

                    SqlDataReader readerVentas = commandVentas.ExecuteReader();
                    while (readerVentas.Read())
                    {
                        ventasData.Add(new DepartamentoReporte
                        {
                            Departamento = readerVentas.GetString(0),
                            CantidadVentas = readerVentas.GetInt32(1),
                            MontoVentas = readerVentas.GetDouble(2)
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
                        cotizacionesData.Add(new DepartamentoReporte
                        {
                            Departamento = readerCotizaciones.GetString(0),
                            CantidadCotizaciones = readerCotizaciones.GetInt32(1),
                            MontoCotizaciones = readerCotizaciones.GetDouble(2)
                        });
                    }
                    readerCotizaciones.Close();

                    // Unificar datos para incluir todos los departamentos
                    var todosLosDepartamentos = ventasData.Select(v => v.Departamento)
                                                          .Union(cotizacionesData.Select(c => c.Departamento))
                                                          .Distinct();

                    foreach (var departamento in todosLosDepartamentos)
                    {
                        var ventas = ventasData.FirstOrDefault(v => v.Departamento == departamento);
                        var cotizaciones = cotizacionesData.FirstOrDefault(c => c.Departamento == departamento);

                        ComparativoData.Add(new DepartamentoReporte
                        {
                            Departamento = departamento,
                            CantidadVentas = ventas?.CantidadVentas ?? 0,
                            MontoVentas = ventas?.MontoVentas ?? 0.0,
                            CantidadCotizaciones = cotizaciones?.CantidadCotizaciones ?? 0,
                            MontoCotizaciones = cotizaciones?.MontoCotizaciones ?? 0.0
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

        public class DepartamentoReporte
        {
            public string Departamento { get; set; }
            public int CantidadVentas { get; set; }
            public double MontoVentas { get; set; }
            public int CantidadCotizaciones { get; set; }
            public double MontoCotizaciones { get; set; }
        }
    }
}
