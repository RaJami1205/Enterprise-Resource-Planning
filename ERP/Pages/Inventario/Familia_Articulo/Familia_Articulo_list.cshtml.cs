using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;

namespace ERP.Pages.Inventario.Familia_Articulo
{
    public class Familia_Articulo_listModel : PageModel
    {
        public List<Familia_ArticuloInfo> listaFamiliArticulos = new List<Familia_ArticuloInfo>(); // Lista que almacena los datos de la familia de art�culo
        public Conexion conexionBD = new Conexion(); // Instancia de la clase Conexion para gestionar la conexi�n a la base de datos

        /// <summary>
        /// M�todo que maneja la solicitud GET para obtener la lista de familias de art�culos desde la base de datos.
        /// </summary>
        /// <remarks>
        /// Este m�todo abre una conexi�n a la base de datos, ejecuta una consulta SQL para recuperar
        /// los c�digos, nombres y descripciones de las familias de art�culos y los almacena
        /// en la lista `listaFamiliArticulos`. En caso de error, se captura la excepci�n y se
        /// almacena el mensaje de error en `mensaje_error`.
        /// </remarks>
        /// <returns>Este m�todo no tiene un valor de retorno.</returns>
        /// <exception cref="Exception">Lanza una excepci�n si ocurre un error al interactuar con la base de datos.</exception>
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
                // Aqu� se maneja el error
                Console.WriteLine("Error: " + ex.Message);
                conexionBD.cerrar();
            }
        }

        // Clase que representa el modelo de vista para el formulario de Familia de Art�culos
        public class Familia_ArticuloInfo
        {
            public string codigo { get; set; }
            public string nombre { get; set; }
            public string descripcion { get; set; }
        }
    }
}
