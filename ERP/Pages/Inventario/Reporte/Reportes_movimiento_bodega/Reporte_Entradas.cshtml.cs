using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;

namespace ERP.Pages.Inventario.Reporte.Reportes_movimiento_bodega
{
    public class Reporte_EntradasModel : PageModel
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
                string query = "SELECT ubicacion, porcentaje_entradas, porcentaje_salidas, porcentaje_movimientos FROM PorcentajeMovimientosBodegas();";
                SqlCommand command = conexionBD.obtenerComando(query);

                SqlDataReader reader = command.ExecuteReader();
                while (reader.Read())
                {
                    listaMovimientos.Add(new InfoMovimiento
                    {
                        ubicacion_bodega = reader.GetString(0),
                        cantidad_entrada = reader.GetDouble(1),
                        cantidad_salida = reader.GetDouble(2),
                        cantidad_movimiento = reader.GetDouble(3)
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
            public Double cantidad_entrada { get; set; }
            public Double cantidad_salida { get; set; }
            public Double cantidad_movimiento { get; set; }
        }
    }
}