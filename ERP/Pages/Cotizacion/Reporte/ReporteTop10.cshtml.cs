using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Collections.Generic;
using System.Data.SqlClient;

namespace ERP.Pages.Cotizacion.Reporte
{
    public class ReporteTop10Model : PageModel
    {
        public List<ProductoCotizado> ProductosCotizados { get; set; } = new List<ProductoCotizado>();
        public string mensajeError = "";
        public string FechaInicio { get; set; }
        public string FechaFin { get; set; }

        public void OnPost()
        {
            FechaInicio = Request.Form["FechaInicio"];
            FechaFin = Request.Form["FechaFin"];

            Conexion conexionBD = new Conexion();
            try
            {
                conexionBD.abrir();
                string query = "SELECT Producto, CantidadCotizaciones FROM ObtenerTop10ProductosMasCotizados(@FechaInicio, @FechaFin)";
                SqlCommand command = conexionBD.obtenerComando(query);
                command.Parameters.AddWithValue("@FechaInicio", FechaInicio);
                command.Parameters.AddWithValue("@FechaFin", FechaFin);

                SqlDataReader reader = command.ExecuteReader();
                while (reader.Read())
                {
                    ProductosCotizados.Add(new ProductoCotizado
                    {
                        Producto = reader.GetString(0),
                        CantidadCotizaciones = reader.GetInt32(1)
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

        public class ProductoCotizado
        {
            public string Producto { get; set; }
            public int CantidadCotizaciones { get; set; }
        }
    }
}
