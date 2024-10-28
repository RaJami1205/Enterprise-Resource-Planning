using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;

namespace ERP.Pages.Inventario.Articulo
{
    public class Articulo_listModel : PageModel
    {
        public List<ArticuloInfo> listaArticulos = new List<ArticuloInfo>(); // Lista que almacena los datos de los art�culos
        public Conexion conexionBD = new Conexion(); // Instancia de la clase Conexion para manejar la conexi�n a la base de datos

        /// <summary>
        /// M�todo que se ejecuta cuando se accede a la p�gina (GET request).
        /// Objetivo: Recuperar la lista de art�culos desde la base de datos y lo almacena en listaArticulos.
        /// Salidas: Una lista de objetos ArticuloInfo que contienen informaci�n b�sica de los art�culos.
        /// Restricciones: En caso de error, el programa manejar� la excepci�n, cerrando la conexi�n y mostrando un mensaje.
        /// </summary>
        public void OnGet()
        {
            try
            {
                conexionBD.abrir();
                String sql = "SELECT codigo_articulo, nombre_articulo, descripcion_articulo, codigo_bodega, ubicacion_bodega, cantidad_en_bodega FROM ArticuloBodega";
                SqlCommand command = conexionBD.obtenerComando(sql);
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {

                        ArticuloInfo articulo = new ArticuloInfo();
                        articulo.codigo_articulo = reader.GetInt32(0).ToString();
                        articulo.nombre = reader.GetString(1);
                        articulo.descripcion = reader.GetString(2);
                        articulo.codigo_bodega = reader.GetInt32(3).ToString();
                        articulo.ubicacion = reader.GetString(4);
                        articulo.cantidad_bodega = reader.GetInt32(5).ToString();

                        listaArticulos.Add(articulo);
                    }
                }
                conexionBD.cerrar();
            }
            catch (Exception ex)
            {
                // Aqu� se maneja el error
                Console.WriteLine("Error: " + ex.Message);
                conexionBD.cerrar();
            }
        }

        // Clase que representa el modelo de vista para la lista de Art�culos
        public class ArticuloInfo
        {
            public string codigo_articulo { get; set; }
            public string nombre { get; set; }
            public string descripcion { get; set; }
            public string codigo_bodega { get; set; }
            public string ubicacion { get; set; }
            public string cantidad_bodega { get; set; }
        }
    }
}
