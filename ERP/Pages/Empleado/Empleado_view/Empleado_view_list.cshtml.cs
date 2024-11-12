using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;

namespace ERP.Pages.Empleado.Empleado_view
{
    public class Empleado_view_listModel : PageModel
    {
        public List<EmpleadoInfo> listaEmpleados = new List<EmpleadoInfo>(); // Lista que almacena los datos de los Empleados
        public Conexion conexionBD = new Conexion(); // Instancia de la clase Conexion para manejar la conexión a la base de datos

        /// <summary>
        /// Método que se ejecuta cuando se accede a la página (GET request).
        /// Objetivo: Recuperar la lista de empleados desde la base de datos y lo almacena en la listaEmpleados.
        /// Salidas: Una lista de objetos EmpleadoInfo que contienen información básica de los empleados.
        /// Restricciones: En caso de error, el programa manejará la excepción, cerrando la conexión y mostrando un mensaje.
        /// </summary>
        public void OnGet()
        {
            try
            {
                conexionBD.abrir();
                String sql = "SELECT Cedula, Nombre, Apellido_1, Apellido_2, Edad, Genero, Residencia, Fecha_Ingreso, Departamento, Vendedor, Telefono, Salario, Puesto FROM Vista_Empleado_Completa";
                SqlCommand command = conexionBD.obtenerComando(sql);
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {

                        EmpleadoInfo empleado = new EmpleadoInfo();
                        empleado.cedula = reader.GetInt32(0).ToString();
                        empleado.nombre = reader.GetString(1);
                        empleado.apellido1 = reader.GetString(2);
                        empleado.apellido2 = reader.GetString(3);
                        empleado.edad = reader.GetInt32(4).ToString();
                        empleado.genero = reader.GetString(5);
                        empleado.residencia = reader.GetString(6);
                        empleado.fecha_ingreso = reader.GetDateTime(7).ToString("yyyy-MM-dd");
                        empleado.departamento = reader.GetString(8); 
                        empleado.vendedor = reader.GetString(9); 
                        empleado.telefono = reader.GetInt32(10).ToString(); 
                        empleado.salario = reader.GetDouble(11).ToString("F2"); 
                        empleado.puesto = reader.GetString(12); 

                        listaEmpleados.Add(empleado);
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

        // Clase que representa el modelo de vista para la lista de empleados
        public class EmpleadoInfo
        {
            public string cedula { get; set; }
            public string nombre { get; set; }
            public string apellido1 { get; set; }
            public string apellido2 { get; set; }
            public string edad { get; set; }
            public string genero { get; set; }
            public string residencia { get; set; }
            public string fecha_ingreso { get; set; }
            public string departamento { get; set; }
            public string puesto { get; set; }
            public string vendedor { get; set; }
            public string telefono { get; set; }
            public string salario { get; set; }
        }
    }
}