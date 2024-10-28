using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;

namespace ERP.Pages
{
    public class IndexModel : PageModel
    {
        /// <summary>
        /// M�todo que se ejecuta cuando se accede a la p�gina (GET request).
        /// Verifica si un usuario existe en la base de datos usando la funci�n VerificarUsuario.
        /// </summary>
        public Conexion conexionBD = new Conexion(); // Instancia de la clase Conexion para manejar la conexi�n a la base de datos
        public string Mensaje = ""; // Para mostrar un mensaje en la p�gina
        public bool UsuarioEncontrado { get; private set; } = false;

        /// <summary>
        /// M�todo que se ejecuta cuando se env�a el formulario (POST request).
        /// Verifica si el usuario existe en la base de datos usando la funci�n VerificarUsuario.
        /// </summary>
        public void OnPost(string usuario, string contrasenna)
        {

            try
            {
                // Abrir la conexi�n a la base de datos
                conexionBD.abrir();

                // Llamar a la funci�n VerificarUsuario que devuelve un BIT (1 o 0)
                String sql = "SELECT dbo.VerificarUsuario(@usuario, @contrasenna)";
                SqlCommand command = conexionBD.obtenerComando(sql);

                // Agregar los par�metros al comando
                command.Parameters.AddWithValue("@usuario", usuario);
                command.Parameters.AddWithValue("@contrasenna", contrasenna);

                // Ejecutar el comando y obtener el resultado
                Boolean resultado = (Boolean)command.ExecuteScalar();

                // Cerrar la conexi�n
                conexionBD.cerrar();

                // Verificar si el usuario fue encontrado
                if (resultado)
                {
                    UsuarioEncontrado = true;               }
                else
                {
                    Mensaje = "Usuario o contrase�a incorrectos.";
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