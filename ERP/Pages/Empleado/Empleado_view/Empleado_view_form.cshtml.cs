using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;
using System.Data;

namespace ERP.Pages.Empleado.Empleado_view
{
    public class Empleado_view_formModel : PageModel
    {
        public EmpleadoInfo Empleado { get; set; } = new EmpleadoInfo(); // Lista que guarda toda la información de los requests
        public Conexion conexionBD = new Conexion(); // Instancia de la clase Conexion para manejar la conexión a la base de datos
        public List<string> listaPuestos { get; set; } = new List<string>();
        public List<string> listaDepartamentos { get; set; } = new List<string>();
        public string mensaje_error = ""; // Variable para almacenar mensajes de error
        public string mensaje_exito = ""; // Variable para almacenar mensajes de éxito

        /// <summary>
        /// Método que se ejecuta cuando se ingresa al formulario (GET request).
        /// Objetivo: Extraer los datos de los ID de puesto y departamento y manejar errores.
        /// Entradas: Ninguna.
        /// Salidas: Mensaje de éxito o mensaje de error.
        /// </summary>
        public void OnGet()
        {
            conexionBD.abrir();
            string sqlPuesto = "SELECT puesto FROM Puesto";
            SqlCommand command_puesto = conexionBD.obtenerComando(sqlPuesto);
            using (SqlDataReader reader = command_puesto.ExecuteReader())
            {
                while (reader.Read())
                {
                    listaPuestos.Add("" + reader.GetString(0));
                }
            }
            conexionBD.cerrar();

            conexionBD.abrir();
            string sqlDepartamento = "SELECT nombre FROM Departamento";
            SqlCommand command_Departamento = conexionBD.obtenerComando(sqlDepartamento);
            using (SqlDataReader reader = command_Departamento.ExecuteReader())
            {
                while (reader.Read())
                {
                    listaDepartamentos.Add("" + reader.GetString(0));
                }
            }
            conexionBD.cerrar();
        }

        /// <summary>
        /// Método que se ejecuta cuando se envía el formulario (POST request).
        /// Objetivo: Recibir los datos del formulario de empleado, insertarlos en la base de datos y manejar errores.
        /// Entradas: Datos del formulario (cedula, nombre, apellidos, fecha de nacimiento, género, edad, fecha de ingreso, teléfono, salario, puesto, departamento, permiso de vendedor).
        /// Salidas: Mensaje de éxito o mensaje de error.
        /// Restricciones: Todos los campos deben estar debidamente validados antes de enviarse.
        /// </summary>
        public void OnPost()
        {
            Empleado.cedula = Request.Form["cedula"];
            Empleado.nombre = Request.Form["nombre"];
            Empleado.apellido1 = Request.Form["apellido1"];
            Empleado.apellido2 = Request.Form["apellido2"];
            Empleado.genero = Request.Form["genero"];
            Empleado.fecha_nacimiento = Request.Form["fecha_nacimiento"];
            Empleado.residencia = Request.Form["residencia"];
            Empleado.fecha_ingreso = Request.Form["fecha_ingreso"];
            Empleado.numero_telefono = Request.Form["numero_telefono"];
            Empleado.salario_actual = Request.Form["salario_actual"];
            Empleado.puesto = Request.Form["puesto"];
            Empleado.departamento = Request.Form["departamento"];
            Empleado.permiso_vendedor = Request.Form["permiso_vendedor"];
            Empleado.usuario = Request.Form["usuario"];
            Empleado.contraseña = Request.Form["contraseña"];

            try 
            {
                conexionBD.abrir();
                string query_1 = "InsertarEmpleado";
                SqlCommand command_1 = conexionBD.obtenerComando(query_1);
                command_1.CommandType = System.Data.CommandType.StoredProcedure;
                SqlParameter errorParameter = new SqlParameter("@ErrorMsg", SqlDbType.VarChar, 255)
                {
                    Direction = ParameterDirection.Output
                };

                command_1.Parameters.AddWithValue("@cedula", Empleado.cedula);
                command_1.Parameters.AddWithValue("@nombre", Empleado.nombre);
                command_1.Parameters.AddWithValue("@apellido1", Empleado.apellido1);
                command_1.Parameters.AddWithValue("@apellido2", Empleado.apellido2);
                command_1.Parameters.AddWithValue("@fecha_nacimiento", Empleado.fecha_nacimiento);
                command_1.Parameters.AddWithValue("@genero", Empleado.genero);
                command_1.Parameters.AddWithValue("@residencia", Empleado.residencia);
                command_1.Parameters.AddWithValue("@fecha_ingreso", Empleado.fecha_ingreso);
                command_1.Parameters.AddWithValue("@departamento", Empleado.departamento);
                command_1.Parameters.AddWithValue("@permiso_vendedor", Empleado.permiso_vendedor);
                command_1.Parameters.AddWithValue("@numero_telefono", Empleado.numero_telefono);
                command_1.Parameters.AddWithValue("@salario_actual", Empleado.salario_actual);
                command_1.Parameters.AddWithValue("@puesto", Empleado.puesto);
                command_1.Parameters.Add(errorParameter);

                command_1.ExecuteNonQuery();
                string ErrorMesage_1 = (string) command_1.Parameters["@ErrorMsg"].Value;

                conexionBD.cerrar();

                conexionBD.abrir();
                string query_2 = "InsertarLogueoUsuario";
                SqlCommand command_2 = conexionBD.obtenerComando(query_2);
                command_2.CommandType = System.Data.CommandType.StoredProcedure;
                SqlParameter errorParameter_2 = new SqlParameter("@ErrorMsg", SqlDbType.VarChar, 255)
                {
                    Direction = ParameterDirection.Output
                };

                command_2.Parameters.AddWithValue("@usuario", Empleado.usuario);
                command_2.Parameters.AddWithValue("@contrasenna_hash", Empleado.contraseña);
                command_2.Parameters.AddWithValue("@cedula_empleado", Empleado.cedula);
                command_2.Parameters.Add(errorParameter_2);


                command_2.ExecuteNonQuery();
                string ErrorMesage_2 = (string)command_2.Parameters["@ErrorMsg"].Value;
                conexionBD.cerrar();

                // Limpieza del formulario
                Empleado.cedula = "";
                Empleado.nombre = "";
                Empleado.apellido1 = "";
                Empleado.apellido2 = "";
                Empleado.fecha_nacimiento = "";
                Empleado.genero = "";
                Empleado.residencia = "";
                Empleado.fecha_ingreso = "";
                Empleado.departamento = "";
                Empleado.permiso_vendedor = "";
                Empleado.numero_telefono = "";
                Empleado.salario_actual = "";
                Empleado.puesto = "";
                Empleado.usuario = "";
                Empleado.contraseña = "";

                mensaje_exito = "Empleado registrado exitosamente";
            }
            catch (Exception ex)
            {
                mensaje_error = ex.Message;
                conexionBD.cerrar();
                OnGet();
            }
        }

        // Clase que representa el modelo de vista para el formulario de empleado
        public class EmpleadoInfo
        {
            public string cedula { get; set; }
            public string nombre { get; set; }
            public string apellido1 { get; set; }
            public string apellido2 { get; set; }
            public string fecha_nacimiento { get; set; }
            public string genero { get; set; }
            public string residencia { get; set; }
            public string fecha_ingreso { get; set; }
            public string departamento { get; set; }
            public string permiso_vendedor { get; set; }
            public string numero_telefono { get; set; }
            public string salario_actual { get; set; }
            public string puesto { get; set; }
            public string usuario { get; set; }
            public string contraseña { get; set; }
        }
    }
}