using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;
using static ERP.Pages.Inventario.Reporte.Familias_Facturadas.Monto_Familias_VendidasModel;

namespace ERP.Pages.Inventario.Reporte.Familias_Facturadas
{
    public class Monto_Familias_VendidasModel : PageModel
    {
        public List<InfoFamiliaFacturada> listaFamilias { get; set; } = new List<InfoFamiliaFacturada>();
        public string mensajeError = "";
        public string FechaInicio { get; set; }
        public string FechaFin { get; set; }

        public void OnPost()
        {
            FechaInicio = Request.Form["fecha_inicio"];
            FechaFin = Request.Form["fecha_final"];

            Conexion conexionBD = new Conexion();
            try
            {
                conexionBD.abrir();
                string query = "SELECT familia, monto_total_vendido FROM ObtenerMontoTotalVendidoPorFamilia(@FechaInicio, @FechaFin);";
                SqlCommand command = conexionBD.obtenerComando(query);
                command.Parameters.AddWithValue("@FechaInicio", FechaInicio);
                command.Parameters.AddWithValue("@FechaFin", FechaFin);

                SqlDataReader reader = command.ExecuteReader();
                while (reader.Read())
                {
                    listaFamilias.Add(new InfoFamiliaFacturada
                    {
                        familia = reader.GetString(0),
                        monto = reader.GetDouble(1),
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

        public class InfoFamiliaFacturada
        {
            public string familia { get; set; }
            public Double monto { get; set; }
        }
    }
}