using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;

namespace ERP.Pages.Factura.FacturaArticulo
{
    public class FacturaArticuloListModel : PageModel
    {
        public List<FacturaArticuloInfo> listaFacturaArticulo = new List<FacturaArticuloInfo>();
        public Conexion conexionBD = new Conexion();

        public void OnGet()
        {
            try
            {
                conexionBD.abrir();

                string sql = @"SELECT numero_factura, codigo_articulo, nombre_articulo, descripcion_articulo,
                               cantidad_facturada, monto_articulo, precio_estandar, estado_factura 
                           FROM VistaFacturaArticulo";

                SqlCommand command = conexionBD.obtenerComando(sql);

                using (SqlDataReader reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        FacturaArticuloInfo facturaArticulo = new FacturaArticuloInfo
                        {
                            numero_factura = reader.GetInt32(0).ToString(),
                            codigo_articulo = reader.GetInt32(1).ToString(),
                            nombre_articulo = reader.GetString(2),
                            descripcion_articulo = reader.GetString(3),
                            cantidad_facturada = reader.GetInt32(4).ToString(),
                            monto_articulo = reader.GetDouble(5).ToString("F2"),
                            precio_estandar = reader.GetDecimal(6).ToString("F2"),
                            estado_factura = reader.GetString(7)
                        };

                        listaFacturaArticulo.Add(facturaArticulo);
                    }
                }
            }
            catch (SqlException ex)
            {
                Console.WriteLine($"SQL Server Error: {ex.Message}, Código de Error: {ex.Number}");
            }
            finally
            {
                conexionBD.cerrar();
            }
        }

        // Clase para representar los datos de la vista VistaFacturaArticulo
        public class FacturaArticuloInfo
        {
            public string numero_factura { get; set; }
            public string codigo_articulo { get; set; }
            public string nombre_articulo { get; set; }
            public string descripcion_articulo { get; set; }
            public string cantidad_facturada { get; set; }
            public string monto_articulo { get; set; }
            public string precio_estandar { get; set; }
            public string estado_factura { get; set; }
        }
    }
}
