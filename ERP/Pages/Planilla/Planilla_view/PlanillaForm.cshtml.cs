using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data;
using System.Data.SqlClient;

namespace ERP.Pages.Planilla.Planilla_view
{
    public class PlanillaFormModel : PageModel
    {
        public List<EmpleadoInfo> Empleados { get; set; } = new List<EmpleadoInfo>();
        public string anno { get; set; }
        public string mes { get; set; }
        public string mensaje_error = "";
        public string mensaje_exito = "";

        public Conexion conexionBD = new Conexion(); // Instancia para la conexión a la base de datos

        public void OnGet()
        {
            try
            {
                // Obtener la lista de empleados
                conexionBD.abrir();
                string query = "SELECT cedula, nombre, salario_actual FROM Empleado";
                SqlCommand commandEmpleado = conexionBD.obtenerComando(query);
                using (SqlDataReader reader = commandEmpleado.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        Empleados.Add(new EmpleadoInfo
                        {
                            cedula = reader.GetInt32(0).ToString(),
                            nombre = reader.GetString(1),
                            salario_actual = reader.GetDouble(2).ToString(),
                            horas = ""
                        });
                    }
                }
                conexionBD.cerrar();
            }
            catch (Exception ex)
            {
                mensaje_error = ex.Message;
                conexionBD.cerrar();
            }
        }

        public void OnPost()
        {
            OnGet();
            anno = Request.Form["anno"];
            mes = Request.Form["mes"];

            foreach (var empleado in Empleados)
            {
                // Almacena las horas trabajadas en la propiedad horas del objeto EmpleadoInfo
                empleado.horas = Request.Form["horas_" + empleado.cedula];

                try
                {
                    conexionBD.abrir();
                    string query = "InsertarSalarioMensual";
                    SqlCommand command = conexionBD.obtenerComando(query);
                    command.CommandType = CommandType.StoredProcedure;

                    // Parámetro de error de salida
                    SqlParameter errorParameter = new SqlParameter("@ErrorMsg", SqlDbType.NVarChar, 255)
                    {
                        Direction = ParameterDirection.Output
                    };

                    // Agregar parámetros al procedimiento almacenado
                    command.Parameters.AddWithValue("@anno", anno);
                    command.Parameters.AddWithValue("@mes", mes);
                    command.Parameters.AddWithValue("@pago", empleado.salario_actual); // El pago se calculará en el SP
                    command.Parameters.AddWithValue("@cantidad_horas", empleado.horas);
                    command.Parameters.AddWithValue("@cedula_empleado", empleado.cedula);
                    command.Parameters.Add(errorParameter);

                    // Ejecutar el procedimiento almacenado
                    command.ExecuteNonQuery();

                    // Capturar el mensaje de error, si existe
                    string errorMsg = (string)command.Parameters["@ErrorMsg"].Value;

                    if (string.IsNullOrEmpty(errorMsg))
                    {
                        mensaje_exito = "Planilla registrada exitosamente.";
                    }

                    conexionBD.cerrar();
                }
                catch (Exception ex)
                {
                    mensaje_error = ex.Message;
                    conexionBD.cerrar();
                }
            }
        }
    }

    public class EmpleadoInfo
    {
        public string cedula { get; set; }
        public string nombre { get; set; }
        public string salario_actual { get; set; }
        public string horas { get; set; } // Nueva propiedad para almacenar horas trabajadas
    }
}
