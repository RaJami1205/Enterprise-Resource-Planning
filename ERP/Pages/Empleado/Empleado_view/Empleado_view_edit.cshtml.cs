using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;
using System.Data;

namespace ERP.Pages.Empleado.Empleado_view
{
    public class Empleado_view_editModel : PageModel
    {
        public EmpleadoInfo Empleado { get; set; } = new EmpleadoInfo(); // Lista que guarda toda la información de los requests
        public Conexion conexionBD = new Conexion(); // Instancia de la clase Conexion para manejar la conexión a la base de datos
        public List<string> listaPuestos { get; set; } = new List<string>();
        public List<string> listaDepartamentos { get; set; } = new List<string>();
        public string mensaje_error = ""; // Variable para almacenar mensajes de error
        public string mensaje_exito = ""; // Variable para almacenar mensajes de éxito

        /// <summary>
        /// Método que se ejecuta cuando se edita el formulario (GET request).
        /// Objetivo: Extrae los datos del empleado con la cédula indicada.
        /// Entradas: Ninguna.
        /// Salidas: Mensaje de éxito o mensaje de error.
        /// </summary>
        public void OnGet()
        {
            string cedula = Request.Query["cedula"];
            Console.WriteLine(cedula); 

            try
            {
                conexionBD.abrir();
                String sql = "SELECT * FROM Empleado WHERE cedula = @cedula";
                SqlCommand command = conexionBD.obtenerComando(sql);
                command.Parameters.AddWithValue("@cedula", cedula);
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        Empleado.cedula = reader.GetInt32(0).ToString();
                        Empleado.nombre = reader.GetString(1);
                        Empleado.apellido1 = reader.GetString(2);
                        Empleado.apellido2 = reader.GetString(3);
                        Empleado.fecha_nacimiento = reader.GetDateTime(4).ToString("yyyy-MM-dd");
                        Empleado.genero = reader.GetString(5);
                        Empleado.residencia = reader.GetString(6);
                        Empleado.fecha_ingreso = reader.GetDateTime(7).ToString("yyyy-MM-dd");
                        Empleado.departamento = reader.GetInt32(8).ToString();
                        Empleado.permiso_vendedor = reader.GetString(9); 
                        Empleado.numero_telefono = reader.GetInt32(10).ToString(); 
                        Empleado.salario_actual = reader.GetDecimal(11).ToString("F2"); 
                        Empleado.puesto = reader.GetInt32(12).ToString();

                    }
                }
                conexionBD.cerrar();
            }
            catch (Exception ex) 
            { 
                mensaje_error = ex.Message;
                conexionBD.cerrar();
            }

            conexionBD.abrir();
            string sqlPuesto = "SELECT puesto_id FROM Puesto";
            SqlCommand command_puesto = conexionBD.obtenerComando(sqlPuesto);
            using (SqlDataReader reader = command_puesto.ExecuteReader())
            {
                while (reader.Read())
                {
                    listaPuestos.Add("" + reader.GetInt32(0));
                }
            }
            conexionBD.cerrar();

            conexionBD.abrir();
            string sqlDepartamento = "SELECT departamento_id FROM Departamento";
            SqlCommand command_Departamento = conexionBD.obtenerComando(sqlDepartamento);
            using (SqlDataReader reader = command_Departamento.ExecuteReader())
            {
                while (reader.Read())
                {
                    listaDepartamentos.Add("" + reader.GetInt32(0));
                }
            }
            conexionBD.cerrar();
        }

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

            try
            {
                conexionBD.abrir();
                string query = "ModificarEmpleado";
                SqlCommand command = conexionBD.obtenerComando(query);
                command.CommandType = System.Data.CommandType.StoredProcedure;
                SqlParameter errorParameter = new SqlParameter("@ErrorMsg", SqlDbType.VarChar, 255)
                {
                    Direction = ParameterDirection.Output
                };

                command.Parameters.AddWithValue("@cedula", Empleado.cedula);
                command.Parameters.AddWithValue("@nombre", Empleado.nombre);
                command.Parameters.AddWithValue("@apellido1", Empleado.apellido1);
                command.Parameters.AddWithValue("@apellido2", Empleado.apellido2);
                command.Parameters.AddWithValue("@fecha_nacimiento", Empleado.fecha_nacimiento);
                command.Parameters.AddWithValue("@genero", Empleado.genero);
                command.Parameters.AddWithValue("@residencia", Empleado.residencia);
                command.Parameters.AddWithValue("@fecha_ingreso", Empleado.fecha_ingreso);
                command.Parameters.AddWithValue("@departamento", Empleado.departamento);
                command.Parameters.AddWithValue("@permiso_vendedor", Empleado.permiso_vendedor);
                command.Parameters.AddWithValue("@numero_telefono", Empleado.numero_telefono);
                command.Parameters.AddWithValue("@salario_actual", Empleado.salario_actual);
                command.Parameters.AddWithValue("@puesto", Empleado.puesto);
                command.Parameters.Add(errorParameter);

                command.ExecuteNonQuery();
                string ErrorMesage = (string)command.Parameters["@ErrorMsg"].Value;

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
        }
    }
}