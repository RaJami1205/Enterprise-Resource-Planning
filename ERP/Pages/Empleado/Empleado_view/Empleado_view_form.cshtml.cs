using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;

namespace ERP.Pages.Empleado.Empleado_view
{
    public class Empleado_view_formModel : PageModel
    {
        public EmpleadoInfo Empleado { get; set; } = new EmpleadoInfo();
        public Conexion conexionBD = new Conexion();
        public string mensaje_error = "";
        public string mensaje_exito = "";

        public void OnGet()
        {
        }

        public void OnPost()
        {
            Empleado.cedula = Request.Form["cedula"];
            Empleado.nombre = Request.Form["nombre"];
            Empleado.apellido1 = Request.Form["apellido1"];
            Empleado.apellido2 = Request.Form["apellido2"];
            Empleado.genero = Request.Form["genero"];
            Empleado.fecha_nacimiento = Request.Form["fecha_nacimiento"];
            Empleado.edad = Request.Form["edad"];
            Empleado.fecha_ingreso = Request.Form["fecha_ingreso"];
            Empleado.numero_telefono = Request.Form["numero_telefono"];
            Empleado.salario_actual = Request.Form["salario_actual"];
            Empleado.puesto = Request.Form["puesto"];
            Empleado.departamento = Request.Form["departamento"];
            Empleado.permiso_vendedor = Request.Form["permiso_vendedor"];

            try
            {
                conexionBD.abrir();
                string query = @"
                    INSERT INTO Empleado (cedula, nombre, apellido1, apellido2, fecha_nacimiento, genero, edad, fecha_ingreso, departamento, permiso_vendedor, numero_telefono, salario_actual, puesto)
                    VALUES (@cedula, @nombre, @apellido1, @apellido2, @fecha_nacimiento, @genero, @edad, @fecha_ingreso, @departamento, @permiso_vendedor, @numero_telefono, @salario_actual, @puesto)";
                SqlCommand command = conexionBD.obtenerComando(query);
                command.Parameters.AddWithValue("@cedula", Empleado.cedula);
                command.Parameters.AddWithValue("@nombre", Empleado.nombre);
                command.Parameters.AddWithValue("@apellido1", Empleado.apellido1);
                command.Parameters.AddWithValue("@apellido2", Empleado.apellido2);
                command.Parameters.AddWithValue("@fecha_nacimiento", Empleado.fecha_nacimiento);
                command.Parameters.AddWithValue("@genero", Empleado.genero);
                command.Parameters.AddWithValue("@edad", Empleado.edad);
                command.Parameters.AddWithValue("@fecha_ingreso", Empleado.fecha_ingreso);
                command.Parameters.AddWithValue("@departamento", Empleado.departamento);
                command.Parameters.AddWithValue("@permiso_vendedor", Empleado.permiso_vendedor);
                command.Parameters.AddWithValue("@numero_telefono", Empleado.numero_telefono);
                command.Parameters.AddWithValue("@salario_actual", Empleado.salario_actual);
                command.Parameters.AddWithValue("@puesto", Empleado.puesto);

                command.ExecuteNonQuery();


                // Limpieza del formulario
                Empleado.cedula = "";
                Empleado.nombre = "";
                Empleado.apellido1 = "";
                Empleado.apellido2 = "";
                Empleado.fecha_nacimiento = "";
                Empleado.genero = "";
                Empleado.edad = "";
                Empleado.fecha_ingreso = "";
                Empleado.departamento = "";
                Empleado.permiso_vendedor = "";
                Empleado.numero_telefono = "";
                Empleado.salario_actual = "";
                Empleado.puesto = "";

                mensaje_exito = "Actividad registrada exitosamente";
            }
            catch (Exception ex)
            {
                mensaje_error = ex.Message;
            }
        }

        public class EmpleadoInfo
        {
            public string cedula { get; set; }
            public string nombre { get; set; }
            public string apellido1 { get; set; }
            public string apellido2 { get; set; }
            public string fecha_nacimiento { get; set; }
            public string genero { get; set; }
            public string edad { get; set; }
            public string fecha_ingreso { get; set; }
            public string departamento { get; set; }
            public string permiso_vendedor { get; set; }
            public string numero_telefono { get; set; }
            public string salario_actual { get; set; }
            public string puesto { get; set; }
        }
    }
}
