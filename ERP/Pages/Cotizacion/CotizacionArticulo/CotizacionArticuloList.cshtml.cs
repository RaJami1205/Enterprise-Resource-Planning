using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;
using System;
using System.Collections.Generic;

namespace ERP.Pages.Cotizacion.CotizacionArticulo
{
    public class VistaArticuloCotizacionModel : PageModel
    {
        public List<ArticuloCotizacionInfo> listaArticuloCotizacion = new List<ArticuloCotizacionInfo>();
        public Conexion conexionBD = new Conexion();  // Utilizamos la clase Conexion previamente definida

        public void OnGet()
        {
            try
            {
                conexionBD.abrir(); // Abrimos la conexión

                // Consulta a la vista VistaArticuloCotizacion
                string sql = @"SELECT codigo_articulo, nombre_articulo, descripcion_articulo, cantidad_inventario, 
                                   precio_articulo, numero_cotizacion, cantidad_cotizada, monto_cotizacion 
                               FROM VistaArticuloCotizacion";

                SqlCommand command = conexionBD.obtenerComando(sql); // Obtenemos el comando

                using (SqlDataReader reader = command.ExecuteReader()) // Ejecutamos el lector
                {
                    while (reader.Read())
                    {
                        ArticuloCotizacionInfo articuloCotizacion = new ArticuloCotizacionInfo
                        {
                            codigo_articulo = reader.GetInt32(0),
                            nombre_articulo = reader.GetString(1),
                            descripcion_articulo = reader.GetString(2),
                            cantidad_inventario = reader.GetInt32(3),
                            precio_articulo = reader.GetDecimal(4),
                            numero_cotizacion = reader.GetInt32(5),
                            cantidad_cotizada = reader.GetInt32(6),
                            monto_cotizacion = reader.GetDecimal(7)
                        };

                        listaArticuloCotizacion.Add(articuloCotizacion); // Añadimos cada entrada a la lista
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

        // Clase para representar los datos de la vista VistaArticuloCotizacion
        public class ArticuloCotizacionInfo
        {
            public int codigo_articulo { get; set; }
            public string nombre_articulo { get; set; }
            public string descripcion_articulo { get; set; }
            public int cantidad_inventario { get; set; }
            public decimal precio_articulo { get; set; }
            public int numero_cotizacion { get; set; }
            public int cantidad_cotizada { get; set; }
            public decimal monto_cotizacion { get; set; }
        }
    }
}

