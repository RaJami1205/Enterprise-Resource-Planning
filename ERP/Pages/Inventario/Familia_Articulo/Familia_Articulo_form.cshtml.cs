using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;


namespace ERP.Pages.Inventario.Familia_Articulo
{
    public class Familia_Articulo_formModel : PageModel
    {
        public Familia_ArticuloInfo FamiliArticulo { get; set; } = new Familia_ArticuloInfo(); // Lista que contiene los datos de los requests
        public Conexion conexionBD = new Conexion(); // Instancia de la clase Conexion para gestionar la conexión a la base de datos
        public string mensaje_error = ""; // Variables para almacenar mensajes de error
        public string mensaje_exito = ""; // Variables para almacenar mensajes de exito

        public void OnGet()
        {
        }

        /// <summary>
        /// Método que se ejecuta cuando se realiza una solicitud POST para guardar la información ingresada.
        /// Objetivo: Insertar una nueva familia de artículo en la base de datos.
        /// Entradas: Información del formulario (código, nombre y descripción de la familia de artículo).
        /// Restricciones: Los campos código, nombre y descripción no pueden estar vacíos. Maneja posibles errores al insertar datos en la base de datos.
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

        // Clase que representa el modelo de vista para el formulario de Familia de Artículos
        public class Familia_ArticuloInfo {
            public string codigo { get; set; }
            public string nombre { get; set; }
            public string descripcion { get; set; }
        }
    }
}
