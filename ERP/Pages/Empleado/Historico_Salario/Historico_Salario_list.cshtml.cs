using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using static ERP.Pages.Inventario.Articulo.Articulo_listModel;
using System.Data.SqlClient;

namespace ERP.Pages.Empleado.Historico_Salario
{
    public class Historico_Salario_listModel : PageModel
    {
        public List<HistoricoSalarioVista> listaHistoricoSalarios = new List<HistoricoSalarioVista>(); // Lista que almacena los datos de los Empleados
        public Conexion conexionBD = new Conexion(); // Instancia de la clase Conexion para manejar la conexión a la base de datos

        /// <summary>
        /// Método que se ejecuta cuando se accede a la página (GET request).
        /// Objetivo: Recuperar la lista de historicos de salarios desde la base de datos y lo almacena en la listaHistoricoSalarios.
        /// Salidas: Una lista de objetos HistoricoSalarioVista que contienen información básica de los históricos de salarios.
        /// Restricciones: En caso de error, el programa manejará la excepción, cerrando la conexión y mostrando un mensaje.
        /// </summary>
        public void OnGet()
        {
            try
            {
                conexionBD.abrir();
                String sql = "SELECT ID_historico, Cedula,  Nombre, PrimerApellido, SegundoApellido, Puesto, Departamento, Monto, FechaInicio, FechaFin FROM VistaHistorialSalario";
                SqlCommand command = conexionBD.obtenerComando(sql);
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {

                        HistoricoSalarioVista HistoricoSalario = new HistoricoSalarioVista();
                        HistoricoSalario.id = reader.GetInt32(0).ToString();
                        HistoricoSalario.cedula = reader.GetInt32(1).ToString();
                        HistoricoSalario.nombre = reader.GetString(2);
                        HistoricoSalario.apellido1 = reader.GetString(3);
                        HistoricoSalario.apellido2 = reader.GetString(4);
                        HistoricoSalario.puesto = reader.GetString(5);
                        HistoricoSalario.departamento = reader.GetString(6);
                        HistoricoSalario.monto = reader.GetInt32(7).ToString();
                        HistoricoSalario.fecha_inicio = reader.GetDateTime(8).ToString("yyyy-MM-dd");
                        HistoricoSalario.fecha_final = reader.GetDateTime(9).ToString("yyyy-MM-dd");

                        listaHistoricoSalarios.Add(HistoricoSalario);
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

        // Clase que representa el modelo de vista para la lista de históricos de salarios
        public class HistoricoSalarioVista
        {
            public string id { get; set; }
            public string cedula { get; set; }
            public string nombre { get; set; }
            public string apellido1 { get; set; }
            public string apellido2 { get; set; }
            public string puesto { get; set; }
            public string departamento { get; set; }
            public string monto { get; set; }
            public string fecha_inicio { get; set; }
            public string fecha_final { get; set; }
        }
    }
}
