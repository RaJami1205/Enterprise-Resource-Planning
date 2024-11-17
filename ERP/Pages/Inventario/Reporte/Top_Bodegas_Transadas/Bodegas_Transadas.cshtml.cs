using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;

namespace ERP.Pages.Inventario.Reporte.Top_Bodegas_Transadas
{
    public class Bodegas_TransadasModel : PageModel
    {
        public List<InfoTopBodegas> TopBodegas { get; set; } = new List<InfoTopBodegas>();
        public string mensajeError = "";

        public void OnPost()
        {

            Conexion conexionBD = new Conexion();
            try
            {
                conexionBD.abrir();
                string query = "SELECT ubicacion, total_entradas, total_salidas, total_movimientos, total_eventos FROM ObtenerTopBodegasTransados() ORDER BY total_eventos DESC;";
                SqlCommand command = conexionBD.obtenerComando(query);

                SqlDataReader reader = command.ExecuteReader();
                while (reader.Read())
                {
                    TopBodegas.Add(new InfoTopBodegas
                    {
                        ubicacion_bodega = reader.GetString(0),
                        cantidad_entrada = reader.GetInt32(1),
                        cantidad_salida = reader.GetInt32(2),
                        cantidad_movimiento = reader.GetInt32(3),
                        total_movimientos = reader.GetInt32(4)
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

        public class InfoTopBodegas
        {
            public string ubicacion_bodega { get; set; }
            public int cantidad_entrada { get; set; }
            public int cantidad_salida { get; set; }
            public int cantidad_movimiento { get; set; }
            public int total_movimientos { get; set; }
        }
    }
}