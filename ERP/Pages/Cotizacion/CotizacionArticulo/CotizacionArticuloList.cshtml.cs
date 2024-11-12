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

                string sql = @"SELECT codigo_articulo, nombre_articulo, cantidad_inventario, estado_articulo, 
                           descripcion_articulo, peso_articulo, costo_articulo, precio_articulo, 
                           numero_cotizacion, cantidad_cotizada, monto_cotizacion 
                       FROM VistaArticuloCotizacion";

                SqlCommand command = conexionBD.obtenerComando(sql); // Obtenemos el comando

                using (SqlDataReader reader = command.ExecuteReader()) // Ejecutamos el lector
                {
                    while (reader.Read())
                    {
                        ArticuloCotizacionInfo articuloCotizacion = new ArticuloCotizacionInfo
                        {
                            codigo_articulo = reader.GetInt32(0).ToString(),
                            nombre_articulo = reader.GetString(1),
                            cantidad_inventario = reader.GetInt32(2).ToString(),
                            estado_articulo = reader.GetString(3), // Convertimos a "Activo"/"Inactivo"
                            descripcion_articulo = reader.GetString(4),
                            peso_articulo = reader.GetDecimal(5).ToString("F2"),
                            costo_articulo = reader.GetDecimal(6).ToString("F2"),
                            precio_articulo = reader.GetDecimal(7).ToString("F2"),
                            numero_cotizacion = reader.GetInt32(8).ToString(),
                            cantidad_cotizada = reader.GetInt32(9).ToString(),
                            monto_cotizacion = reader.GetDouble(10).ToString("F2")
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
            public string codigo_articulo { get; set; }
            public string nombre_articulo { get; set; }
            public string descripcion_articulo { get; set; }
            public string cantidad_inventario { get; set; }
            public string precio_articulo { get; set; }
            public string numero_cotizacion { get; set; }
            public string cantidad_cotizada { get; set; }
            public string monto_cotizacion { get; set; }
            public string estado_articulo { get; set; }
            public string peso_articulo { get; set; }
            public string costo_articulo {get ; set;}
        }
    }
}

