using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;

namespace ERP.Pages.Cotizacion.CotizacionTarea
{
    public class CotizacionTareaListModel : PageModel
    {
        public List<TareaCotizacionInfo> listaTareas = new List<TareaCotizacionInfo>();
        public Conexion conexionBD = new Conexion();  // Utilizamos la clase Conexion previamente definida

        public void OnGet()
        {
            try
            {
                conexionBD.abrir(); // Abrimos la conexión

                string sql = @"SELECT codigo_tarea, descripcion, num_cotizacion 
                               FROM TareaCotizacion"; // La tabla TareaCotizacion

                SqlCommand command = conexionBD.obtenerComando(sql); // Obtenemos el comando

                using (SqlDataReader reader = command.ExecuteReader()) // Ejecutamos el lector
                {
                    while (reader.Read())
                    {
                        TareaCotizacionInfo tarea = new TareaCotizacionInfo
                        {
                            codigo_tarea = reader.GetInt32(0).ToString(),
                            descripcion = reader.GetString(1),
                            num_cotizacion = reader.GetInt32(2).ToString()
                        };

                        listaTareas.Add(tarea); // Añadimos cada tarea a la lista
                    }
                }
            }
            catch (SqlException ex)
            {
                Console.WriteLine($"SQL Server Error: {ex.Message}, Código de Error: {ex.Number}");
            }
            finally
            {
                conexionBD.cerrar(); // Cerramos la conexión
            }
        }
    }

    // Clase que representa la estructura de la Tarea de Cotización
    public class TareaCotizacionInfo
    {
        public string codigo_tarea { get; set; }
        public string descripcion { get; set; }
        public string num_cotizacion { get; set; }
    }
}
