using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;

namespace ERP.Pages.Cotizacion.Cotizacion_view
{
    public class Cotizacion_view_listModel : PageModel
    {
        public List<CotizacionInfo> listaCotizaciones = new List<CotizacionInfo>();
        public Conexion conexionBD = new Conexion();  // Utilizamos la clase Conexion previamente definida

        public void OnGet()
        {
            try
            {
                conexionBD.abrir(); // Abrimos la conexión

                string sql = @"SELECT num_cotizacion, orden_compra, descripcion, monto_total, mes_cierre, probabilidad, 
                                   nombre_vendedor, nombre_cliente, zona, sector, estado, tipo 
                               FROM VistaCotizacion"; // La vista que creaste

                SqlCommand command = conexionBD.obtenerComando(sql); // Obtenemos el comando

                using (SqlDataReader reader = command.ExecuteReader()) // Ejecutamos el lector
                {
                    while (reader.Read())
                    {
                        CotizacionInfo cotizacion = new CotizacionInfo
                        {
                            num_cotizacion = reader.GetInt32(0),
                            orden_compra = reader.GetString(1),
                            descripcion = reader.GetString(2),
                            monto_total = reader.GetDecimal(3),
                            mes_cierre = reader.GetInt32(4),
                            probabilidad = reader.GetDecimal(5),
                            cedula_vendedor = reader.GetInt32(6),
                            cedula_cliente = reader.GetInt32(7),
                            zona = reader.GetString(8),
                            sector = reader.GetString(9),
                            estado = reader.GetString(10),
                            tipo = reader.GetString(11)
                        };

                        listaCotizaciones.Add(cotizacion); // Añadimos cada cotización a la lista
                    }
                }
            }
            catch (SqlException ex)
            {
                Console.WriteLine($"SQL Server Error: {ex.Message}, Código de Error: {ex.Number}");
            }
            finally
            {
                conexionBD.cerrar(); // Cerramos la conexión
            }
        }
    }
}

