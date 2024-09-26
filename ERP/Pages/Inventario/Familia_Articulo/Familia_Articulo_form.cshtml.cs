using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;


namespace ERP.Pages.Inventario.Familia_Articulo
{
    public class Familia_Articulo_formModel : PageModel
    {
        public Familia_ArticuloInfo FamiliArticulo { get; set; } = new Familia_ArticuloInfo(); // Lista que contiene los datos de los requests
        public Conexion conexionBD = new Conexion(); // Instancia de la clase Conexion para gestionar la conexi�n a la base de datos
        public string mensaje_error = ""; // Variables para almacenar mensajes de error
        public string mensaje_exito = ""; // Variables para almacenar mensajes de exito

        public void OnGet()
        {
        }

        /// <summary>
        /// M�todo que se ejecuta cuando se realiza una solicitud POST para guardar la informaci�n ingresada.
        /// Objetivo: Insertar una nueva familia de art�culo en la base de datos.
        /// Entradas: Informaci�n del formulario (c�digo, nombre y descripci�n de la familia de art�culo).
        /// Restricciones: Los campos c�digo, nombre y descripci�n no pueden estar vac�os. Maneja posibles errores al insertar datos en la base de datos.
        /// </summary>
        public void OnPost() 
        {
            FamiliArticulo.codigo = Request.Form["codigo"];
            FamiliArticulo.nombre = Request.Form["nombre"];
            FamiliArticulo.descripcion = Request.Form["descricion"];

            try
            {
                conexionBD.abrir();
                string query = @"
                    INSERT INTO Familia (codigo, nombre, descripcion)
                    VALUES (@codigo, @nombre, @descripcion)";
                SqlCommand command = conexionBD.obtenerComando(query);
                command.Parameters.AddWithValue("@codigo", FamiliArticulo.codigo);
                command.Parameters.AddWithValue("@nombre", FamiliArticulo.nombre);
                command.Parameters.AddWithValue("@descripcion", FamiliArticulo.descripcion);

                command.ExecuteNonQuery();


                // Limpieza del formulario
                FamiliArticulo.codigo = "";
                FamiliArticulo.nombre = "";
                FamiliArticulo.descripcion = "";

                mensaje_exito = "Actividad registrada exitosamente";
            }
            catch (Exception ex)
            {
                mensaje_error = ex.Message;
            }
        }

        // Clase que representa el modelo de vista para el formulario de Familia de Art�culos
        public class Familia_ArticuloInfo {
            public string codigo { get; set; }
            public string nombre { get; set; }
            public string descripcion { get; set; }
        }
    }
}
