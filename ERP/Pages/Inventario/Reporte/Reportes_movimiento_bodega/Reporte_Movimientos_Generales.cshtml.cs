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
        public string FechaInicio { get; set; }
        public string FechaFin { get; set; }

        public void OnPost()
        {

            Conexion conexionBD = new Conexion();
            try
            {
                FechaInicio = Request.Form["fecha_inicio"];
                FechaFin = Request.Form["fecha_final"];

                conexionBD.abrir();
                string query = "SELECT ubicacion, porcentaje_entradas, porcentaje_salidas, porcentaje_movimientos FROM PorcentajeMovimientosBodegas(@FechaInicio, @FechaFin);";
                SqlCommand command = conexionBD.obtenerComando(query);
                command.Parameters.AddWithValue("@FechaInicio", FechaInicio);
                command.Parameters.AddWithValue("@FechaFin", FechaFin);

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