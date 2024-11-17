using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;

namespace ERP.Pages.Inventario.Reporte.Reportes_movimiento_bodega
{
    public class Reporte_Movimientos_GeneralesModel : PageModel
    {
        public List<InfoMovimiento> listaMovimientos { get; set; } = new List<InfoMovimiento>();
        public string mensajeError = "";
        public string tipoMovimiento { get; set; }

        public void OnPost()
        {

            Conexion conexionBD = new Conexion();
            try
            {
                conexionBD.abrir();
                string query = "SELECT ubicacion, porcentaje_salidas, porcentaje_entradas, porcentaje_movimientos FROM PorcentajeMovimientosBodegas();";
                SqlCommand command = conexionBD.obtenerComando(query);

                SqlDataReader reader = command.ExecuteReader();
                while (reader.Read())
                {
                    listaMovimientos.Add(new InfoMovimiento
                    {
                        ubicacion_bodega = reader.GetString(0),
                        cantidad_entrada = reader.GetInt32(1),
                        cantidad_salida = reader.GetInt32(2),
                        cantidad_movimiento = reader.GetInt32(3)
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

        public class InfoMovimiento
        {
            public string ubicacion_bodega { get; set; }
            public int cantidad_entrada { get; set; }
            public int cantidad_salida { get; set; }
            public int cantidad_movimiento { get; set; }
        }
    }
}