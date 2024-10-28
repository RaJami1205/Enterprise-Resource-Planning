using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;

namespace ERP.Pages.Factura.Factura_view
{
    public class Factura_view_listModel : PageModel
    {
        public List<FacturaInfo> listaFacturas = new List<FacturaInfo>();
        public Conexion conexionBD = new Conexion();  // Conexión a la base de datos

        public void OnGet()
        {
            try
            {
                conexionBD.abrir(); // Abrir conexión

                string sql = @"SELECT num_facturacion, telefono_local, cedula_juridica, nombre_local, 
                                fecha, estado_factura, cedula_vendedor, num_cotizacion 
                            FROM VistaFacturaDetalle"; // Asegúrate de crear una vista VistaFactura

                SqlCommand command = conexionBD.obtenerComando(sql); // Comando SQL

                using (SqlDataReader reader = command.ExecuteReader()) // Ejecuta el lector
                {
                    while (reader.Read())
                    {
                        FacturaInfo factura = new FacturaInfo
                        {
                            num_facturacion = reader.GetInt32(0).ToString(),
                            telefono_local = reader.GetInt32(1).ToString(),
                            cedula_juridica = reader.GetInt32(2).ToString(),
                            nombre_local = reader.GetString(3),
                            fecha = reader.GetDateTime(4).ToString("yyyy-MM-dd"),
                            estado = reader.GetString(5),
                            cedula_vendedor = reader.GetInt32(6).ToString(),
                            num_cotizacion = reader.IsDBNull(7) ? "N/A" : reader.GetInt32(7).ToString()
                        };

                        listaFacturas.Add(factura); // Añade cada factura a la lista
                    }
                }
            }
            catch (SqlException ex)
            {
                Console.WriteLine($"SQL Server Error: {ex.Message}, Código de Error: {ex.Number}");
            }
            finally
            {
                conexionBD.cerrar(); // Cerrar conexión
            }
        }
    }

    public class FacturaInfo
    {
        public string num_facturacion { get; set; }
        public string telefono_local { get; set; }
        public string cedula_juridica { get; set; }
        public string nombre_local { get; set; }
        public string fecha { get; set; }
        public string estado { get; set; }
        public string cedula_vendedor { get; set; }
        public string num_cotizacion { get; set; }
        public string bodega { get; set; }
    }
}

