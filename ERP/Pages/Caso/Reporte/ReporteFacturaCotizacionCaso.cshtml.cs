using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;
using System.Collections.Generic;

namespace ERP.Pages.Caso.Reporte
{
    public class ReporteFacturaCotizacionCasoModel : PageModel
    {
        public List<ComparativoData> CasosComparativoData { get; set; } = new List<ComparativoData>();
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

                    // Obtener casos por cotizaci�n
                    string queryCotizacion = "SELECT A�oMes, CantidadCasos FROM ObtenerCasosPorCotizacion(@FechaInicio, @FechaFin)";
                    SqlCommand commandCotizacion = conexionBD.obtenerComando(queryCotizacion);
                    commandCotizacion.Parameters.AddWithValue("@FechaInicio", FechaInicio);
                    commandCotizacion.Parameters.AddWithValue("@FechaFin", FechaFin);

                    SqlDataReader readerCotizacion = commandCotizacion.ExecuteReader();
                    while (readerCotizacion.Read())
                    {
                        CasosComparativoData.Add(new ComparativoData
                        {
                            A�oMes = readerCotizacion.GetString(0),
                            CantidadCasosCotizacion = readerCotizacion.GetInt32(1),
                            CantidadCasosFactura = 0 // Default, se actualizar� despu�s
                        });
                    }
                    readerCotizacion.Close();

                    // Obtener casos por factura
                    string queryFactura = "SELECT A�oMes, CantidadCasos FROM ObtenerCasosPorFactura(@FechaInicio, @FechaFin)";
                    SqlCommand commandFactura = conexionBD.obtenerComando(queryFactura);
                    commandFactura.Parameters.AddWithValue("@FechaInicio", FechaInicio);
                    commandFactura.Parameters.AddWithValue("@FechaFin", FechaFin);

                    SqlDataReader readerFactura = commandFactura.ExecuteReader();
                    while (readerFactura.Read())
                    {
                        string anioMes = readerFactura.GetString(0);
                        int cantidadFactura = readerFactura.GetInt32(1);

                        // Actualizar o agregar datos
                        var existing = CasosComparativoData.Find(x => x.A�oMes == anioMes);
                        if (existing != null)
                        {
                            existing.CantidadCasosFactura = cantidadFactura;
                        }
                        else
                        {
                            CasosComparativoData.Add(new ComparativoData
                            {
                                A�oMes = anioMes,
                                CantidadCasosCotizacion = 0,
                                CantidadCasosFactura = cantidadFactura
                            });
                        }
                    }
                    readerFactura.Close();
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
                mensajeError = "Por favor, ingrese un rango de fechas v�lido.";
            }
        }

        public class ComparativoData
        {
            public string A�oMes { get; set; }
            public int CantidadCasosCotizacion { get; set; }
            public int CantidadCasosFactura { get; set; }
        }
    }
}
