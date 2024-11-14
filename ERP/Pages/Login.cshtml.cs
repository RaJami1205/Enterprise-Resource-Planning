using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;

namespace ERP.Pages
{
    public class IndexModel : PageModel
    {
        /// <summary>
        /// Método que se ejecuta cuando se accede a la página (GET request).
        /// Verifica si un usuario existe en la base de datos usando la función VerificarUsuario.
        /// </summary>
        public Conexion conexionBD = new Conexion(); // Instancia de la clase Conexion para manejar la conexión a la base de datos
        public string Mensaje = ""; // Para mostrar un mensaje en la página
        public bool UsuarioEncontrado { get; private set; } = false;

        /// <summary>
        /// Método que se ejecuta cuando se envía el formulario (POST request).
        /// Verifica si el usuario existe en la base de datos usando la función VerificarUsuario.
        /// </summary>
        public void OnPost(string usuario, string contrasenna)
        {

            try
            {
                // Abrir la conexión a la base de datos
                conexionBD.abrir();

                // Llamar a la función VerificarUsuario que devuelve un BIT (1 o 0)
                String sql = "SELECT dbo.VerificarUsuario(@usuario, @contrasenna)";
                SqlCommand command = conexionBD.obtenerComando(sql);

                // Agregar los parámetros al comando
                command.Parameters.AddWithValue("@usuario", usuario);
                command.Parameters.AddWithValue("@contrasenna", contrasenna);

                // Ejecutar el comando y obtener el resultado
                Boolean resultado = (Boolean)command.ExecuteScalar();

                // Cerrar la conexión
                conexionBD.cerrar();

                // Verificar si el usuario fue encontrado
                if (resultado)
                {
                    UsuarioEncontrado = true;               }
                else
                {
                    Mensaje = "Usuario o contraseña incorrectos.";
                }
            }
            catch (Exception ex)
            {
                // Manejar cualquier error que ocurra
                Mensaje = "Error: " + ex.Message;
                conexionBD.cerrar();
            }
        }
    }
}