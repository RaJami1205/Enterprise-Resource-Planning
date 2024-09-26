using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;

namespace ERP.Pages.Empleado.Empleado_view
{
    public class Empleado_view_listModel : PageModel
    {
        public List<EmpleadoInfo> listaEmpleados = new List<EmpleadoInfo>(); // Lista que almacena los datos de los Empleados
        public Conexion conexionBD = new Conexion(); // Instancia de la clase Conexion para manejar la conexi�n a la base de datos

        /// <summary>
        /// M�todo que se ejecuta cuando se accede a la p�gina (GET request).
        /// Objetivo: Recuperar la lista de empleados desde la base de datos y almacenarla en la listaEmpleados.
        /// Salidas: Una lista de objetos EmpleadoInfo que contienen informaci�n b�sica de los empleados.
        /// Restricciones: En caso de error, el programa manejar� la excepci�n, cerrando la conexi�n y mostrando un mensaje.
        /// </summary>
        public void OnGet()
        {
            try
            {
                conexionBD.abrir();
                String sql = "SELECT cedula, nombre, apellido1, apellido2, departamento, permiso_vendedor, puesto FROM Empleado";
                SqlCommand command = conexionBD.obtenerComando(sql);
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {

                        EmpleadoInfo empleado = new EmpleadoInfo();
                        empleado.cedula = "" + reader.GetInt32(0);
                        empleado.nombre = "" + reader.GetString(1);
                        empleado.apellido1 = "" + reader.GetString(2);
                        empleado.apellido2 = "" + reader.GetString(3);
                        empleado.departamento = "" + reader.GetString(4);
                        empleado.permiso_vendedor = "" + reader.GetString(5);
                        empleado.puesto = "" + reader.GetString(6);

                        listaEmpleados.Add(empleado);
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
    }

    // Clase que representa el modelo de vista para la lista de empleados
    public class EmpleadoInfo {
        public string cedula { get; set; }
        public string nombre { get; set; }
        public string apellido1 { get; set; }
        public string apellido2 { get; set; }
        public string departamento { get; set; }
        public string permiso_vendedor { get; set; }
        public string puesto { get; set; }
    }
}