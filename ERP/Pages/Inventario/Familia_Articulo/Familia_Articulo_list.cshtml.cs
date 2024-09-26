using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;

namespace ERP.Pages.Inventario.Familia_Articulo
{
    public class Familia_Articulo_listModel : PageModel
    {
        public List<Familia_ArticuloInfo> listaFamiliArticulos = new List<Familia_ArticuloInfo>(); // Lista que almacena los datos de la familia de artículo
        public Conexion conexionBD = new Conexion(); // Instancia de la clase Conexion para gestionar la conexión a la base de datos

        /// <summary>
        /// Método que maneja la solicitud GET para obtener la lista de familias de artículos desde la base de datos.
        /// </summary>
        /// <remarks>
        /// Este método abre una conexión a la base de datos, ejecuta una consulta SQL para recuperar
        /// los códigos, nombres y descripciones de las familias de artículos y los almacena
        /// en la lista `listaFamiliArticulos`. En caso de error, se captura la excepción y se
        /// almacena el mensaje de error en `mensaje_error`.
        /// </remarks>
        /// <returns>Este método no tiene un valor de retorno.</returns>
        /// <exception cref="Exception">Lanza una excepción si ocurre un error al interactuar con la base de datos.</exception>
        public void OnGet()
        {
            try
            {
                conexionBD.abrir();
                String sql = "SELECT codigo, nombre, descripcion FROM Familia";
                SqlCommand command = conexionBD.obtenerComando(sql);
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {

                        Familia_ArticuloInfo FamiliArticulo = new Familia_ArticuloInfo();
                        FamiliArticulo.codigo = "" + reader.GetInt32(0);
                        FamiliArticulo.nombre = "" + reader.GetString(1);
                        FamiliArticulo.descripcion = "" + reader.GetString(2);

                        listaFamiliArticulos.Add(FamiliArticulo);
                    }
                }
                conexionBD.cerrar();
            }
            catch (Exception ex)
            {
                // Aquí se maneja el error
                Console.WriteLine("Error: " + ex.Message);
                conexionBD.cerrar();
            }
        }

        // Clase que representa el modelo de vista para el formulario de Familia de Artículos
        public class Familia_ArticuloInfo
        {
            public string codigo { get; set; }
            public string nombre { get; set; }
            public string descripcion { get; set; }
        }
    }
}
