using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;
using System.Data;
using System.Threading;

namespace ERP.Pages.Cotizacion.CotizacionTarea
{
    public class CotizacionTareaFormModel : PageModel
    {
        public TareaCotizacionInfo Tarea { get; set; } = new TareaCotizacionInfo();
        public List<string> cotizaciones { get; set; } = new List<string>(); // Lista de cotizaciones
        public string mensaje_error = "";
        public string mensaje_exito = "";

        public Conexion conexionBD = new Conexion(); // Instancia para la conexión a la base de datos

        public void OnGet()
        {
            try
            {
                // Obtener los números de cotización
                conexionBD.abrir();
                string query = "SELECT num_cotizacion FROM Cotizacion";
                SqlCommand commandCotizacion = conexionBD.obtenerComando(query);
                using (SqlDataReader reader = commandCotizacion.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        cotizaciones.Add(reader.GetInt32(0).ToString());
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
            Tarea.codigo_tarea = Request.Form["codigo_tarea"];
            Tarea.descripcion = Request.Form["descripcion"];
            Tarea.num_cotizacion = Request.Form["num_cotizacion"];

            try
            {
                conexionBD.abrir();
                string query = "InsertarTareaCotizacion"; // Procedimiento almacenado
                SqlCommand command = conexionBD.obtenerComando(query);
                command.CommandType = CommandType.StoredProcedure;

                // Parámetro de error de salida
                SqlParameter errorParameter = new SqlParameter("@ErrorMsg", SqlDbType.NVarChar, 255)
                {
                    Direction = ParameterDirection.Output
                };

                // Agregar parámetros al procedimiento almacenado
                command.Parameters.AddWithValue("@codigo_tarea", Tarea.codigo_tarea);
                command.Parameters.AddWithValue("@descripcion", Tarea.descripcion);
                command.Parameters.AddWithValue("@num_cotizacion", Tarea.num_cotizacion);
                command.Parameters.Add(errorParameter);

                // Ejecutar el procedimiento almacenado
                command.ExecuteNonQuery();

                // Capturar el mensaje de error, si existe
                string errorMsg = (string)command.Parameters["@ErrorMsg"].Value;

                mensaje_exito = "Cotización registrada exitosamente.";

                conexionBD.cerrar();
            }
            catch (Exception ex)
            {
                mensaje_error = $"Error al registrar la cotización";
                conexionBD.cerrar();
            }

            // Volver a cargar las listas en caso de error
            OnGet();
        }
    }
}
