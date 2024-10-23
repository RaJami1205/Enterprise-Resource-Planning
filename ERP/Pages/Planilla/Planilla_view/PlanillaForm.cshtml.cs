using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
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
                string query = "SELECT cedula, nombre FROM Empleado";
                SqlCommand commandEmpleado = conexionBD.obtenerComando(query);
                using (SqlDataReader reader = commandEmpleado.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        Empleados.Add(new EmpleadoInfo
                        {
                            cedula = reader.GetInt32(0).ToString(),
                            nombre = reader.GetString(1)
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
            anno = Request.Form["anno"];
            mes = Request.Form["mes"];

            foreach (var empleado in Empleados)
            {
                string horasTrabajadas = Request.Form["horas_" + empleado.cedula];
                string montoPago = Request.Form["pago_" + empleado.cedula];

                try
                {
                    conexionBD.abrir();
                    string query = "INSERT INTO SalarioMensual (anno, mes, pago, cantidad_horas, cedula_empleado) VALUES (@anno, @mes, @pago, @horas, @cedula)";
                    SqlCommand command = conexionBD.obtenerComando(query);
                    command.Parameters.AddWithValue("@anno", anno);
                    command.Parameters.AddWithValue("@mes", mes);
                    command.Parameters.AddWithValue("@pago", montoPago);
                    command.Parameters.AddWithValue("@horas", horasTrabajadas);
                    command.Parameters.AddWithValue("@cedula", empleado.cedula);

                    command.ExecuteNonQuery();
                    conexionBD.cerrar();
                }
                catch (Exception ex)
                {
                    mensaje_error = ex.Message;
                    conexionBD.cerrar();
                }
            }

            mensaje_exito = "Planilla registrada exitosamente.";
        }
    }

    public class EmpleadoInfo
    {
        public string cedula { get; set; }
        public string nombre { get; set; }
    }
}
