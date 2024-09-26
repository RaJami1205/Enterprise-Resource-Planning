using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;

namespace ERP.Pages.Cliente.Cliente_view
{
    public class Cliente_view_formModel : PageModel
    {
        public ClienteInfo Cliente { get; set; } = new ClienteInfo(); // Lista para almacenar los datos obtenidos de los requests
        public Conexion conexionBD = new Conexion(); // Instancia de la clase Conexion para manejar la conexión a la base de datos
        public string mensaje_error = ""; // Variable para almacenar mensajes de error
        public string mensaje_exito = ""; // Variable para almacenar mensajes de éxito

        public void OnGet()
        {
        }

        /// <summary>
        /// Método que se ejecuta cuando el formulario de la página es enviado (POST request).
        /// Objetivo: Recibir los datos del formulario, insertarlos en la base de datos y manejar cualquier error.
        /// Entradas: Datos del formulario (cedula, nombre, apellido1, apellido2, correo, teléfono, celular, fax, zona, sector).
        /// Salidas: Mensaje de éxito o mensaje de error.
        /// Restricciones: Requiere que los campos no estén vacíos para realizar el registro exitosamente.
        /// </summary>
        public void OnPost()
        {
            Cliente.cedula = Request.Form["cedula"];
            Cliente.nombre = Request.Form["nombre"];
            Cliente.correo = Request.Form["correo"];
            Cliente.telefono = Request.Form["telefono"];
            Cliente.celular = Request.Form["celular"];
            Cliente.fax = Request.Form["fax"];
            Cliente.zona = Request.Form["zona"];
            Cliente.sector = Request.Form["sector"];

            try
            {
                conexionBD.abrir();
                string query = @"
                    INSERT INTO Cliente (cedula_juridica, nombre, correo, telefono, celular, fax, zona, sector)
                    VALUES (@cedula_juridica, @nombre, @correo, @telefono, @celular, @fax, @zona, @sector)";
                SqlCommand command = conexionBD.obtenerComando(query);
                command.Parameters.AddWithValue("@cedula_juridica", Cliente.cedula);
                command.Parameters.AddWithValue("@nombre", Cliente.nombre);
                command.Parameters.AddWithValue("@correo", Cliente.correo);
                command.Parameters.AddWithValue("@telefono", Cliente.telefono);
                command.Parameters.AddWithValue("@celular", Cliente.celular);
                command.Parameters.AddWithValue("@fax", Cliente.fax);
                command.Parameters.AddWithValue("@zona", Cliente.zona);
                command.Parameters.AddWithValue("@sector", Cliente.sector);

                command.ExecuteNonQuery();


                // Limpieza del formulario
                Cliente.cedula = "";
                Cliente.nombre = "";
                Cliente.correo = "";
                Cliente.telefono = "";
                Cliente.celular = "";
                Cliente.fax = "";
                Cliente.zona = "";
                Cliente.sector = "";

                mensaje_exito = "Actividad registrada exitosamente";
            }
            catch (Exception ex)
            {
                mensaje_error = ex.Message;
            }
        }

        // Clase que representa la información de un cliente
        public class ClienteInfo 
        {
            public string cedula { get; set; }
            public string nombre { get; set; }
            public string correo { get; set; }
            public string telefono { get; set; }
            public string celular { get; set; }
            public string fax { get; set; }
            public string zona { get; set; }
            public string sector { get; set; }
        }
    }
}
