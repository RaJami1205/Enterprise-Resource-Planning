using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;

namespace ERP.Pages.Factura.Reporte
{
    public class ReporteMesAnoModel : PageModel
    {
        public List<MesAnioReporte> CotizacionesVentasData { get; set; } = new List<MesAnioReporte>();
        public List<Reporte> VentasData { get; set; } = new List<Reporte>();
        public List<Reporte> CotizacionesData { get; set; } = new List<Reporte>();
        public string mensajeError = "";

        public void OnGet()
        {
            Conexion conexionBD = new Conexion();
            try
            {
                conexionBD.abrir();

                // Obtener Ventas por Mes y A�o
                string queryVentas = "SELECT Anio, Mes, CantidadVentas FROM ObtenerVentasPorMesAno()";
                SqlCommand commandVentas = conexionBD.obtenerComando(queryVentas);
                SqlDataReader readerVentas = commandVentas.ExecuteReader();
                while (readerVentas.Read())
                {
                    VentasData.Add(new Reporte
                    {
                        A�o = readerVentas.GetInt32(0),
                        Mes = readerVentas.GetInt32(1),
                        Cantidad = readerVentas.GetInt32(2)
                    });
                }
                readerVentas.Close();

                // Obtener Cotizaciones por Mes y A�o
                string queryCotizaciones = "SELECT Anio, Mes, CantidadCotizaciones FROM ObtenerCotizacionesPorMesAno()";
                SqlCommand commandCotizaciones = conexionBD.obtenerComando(queryCotizaciones);
                SqlDataReader readerCotizaciones = commandCotizaciones.ExecuteReader();
                while (readerCotizaciones.Read())
                {
                    CotizacionesData.Add(new Reporte
                    {
                        A�o = readerCotizaciones.GetInt32(0),
                        Mes = readerCotizaciones.GetInt32(1),
                        Cantidad = readerCotizaciones.GetInt32(2)
                    });
                }
                readerCotizaciones.Close();

                // Unificar datos para generar CotizacionesVentasData
                var allYears = VentasData.Select(v => v.A�o).Union(CotizacionesData.Select(c => c.A�o)).Distinct().OrderBy(y => y);
                var allMonths = VentasData.Select(v => v.Mes).Union(CotizacionesData.Select(c => c.Mes)).Distinct().OrderBy(y => y);

                foreach (var year in allYears)
                {
                    foreach (var month in allMonths)
                    {
                        var ventas = VentasData.FirstOrDefault(v => v.A�o == year && v.Mes == month)?.Cantidad ?? 0;
                        var cotizaciones = CotizacionesData.FirstOrDefault(c => c.A�o == year && c.Mes == month)?.Cantidad ?? 0;

                        CotizacionesVentasData.Add(new MesAnioReporte
                        {
                            A�o = year,
                            Mes = month,
                            CantidadVentas = ventas,
                            CantidadCotizaciones = cotizaciones
                        });
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
        }

        public class MesAnioReporte
        {
            public int A�o { get; set; }
            public int Mes { get; set; }
            public int CantidadVentas { get; set; }
            public int CantidadCotizaciones { get; set; }
        }

        public class Reporte
        {
            public int A�o { get; set; }
            public int Mes { get; set; }
            public int Cantidad { get; set; }
        }
    }
}
