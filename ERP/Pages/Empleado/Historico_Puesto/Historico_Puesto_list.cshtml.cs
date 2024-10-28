using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;

namespace ERP.Pages.Empleado.Historico_Puesto
{
    public class Historico_Puesto_listModel : PageModel
    {
        public List<HistoricoPuestoVista> listaHistoricoPuestos = new List<HistoricoPuestoVista>(); // Lista que almacena los datos de los Empleados
        public Conexion conexionBD = new Conexion(); // Instancia de la clase Conexion para manejar la conexión a la base de datos

        /// <summary>
        /// Método que se ejecuta cuando se accede a la página (GET request).
        /// Objetivo: Recuperar la lista de historicos de puestos desde la base de datos y lo almacena en la listaHistoricoPuestos.
        /// Salidas: Una lista de objetos HistoricoPuestoVista que contienen información básica de los históricos de puestos.
        /// Restricciones: En caso de error, el programa manejará la excepción, cerrando la conexión y mostrando un mensaje.
        /// </summary>
        public void OnGet()
        {
            try
            {
                conexionBD.abrir();
                String sql = "SELECT ID_historico, Cedula,  Nombre, PrimerApellido, SegundoApellido, Puesto, Departamento, FechaInicio, FechaFin FROM VistaHistorialPuesto";
                SqlCommand command = conexionBD.obtenerComando(sql);
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {

                        HistoricoPuestoVista HistoricoPuesto = new HistoricoPuestoVista();
                        HistoricoPuesto.id = reader.GetInt32(0).ToString();
                        HistoricoPuesto.cedula = reader.GetInt32(1).ToString();
                        HistoricoPuesto.nombre = reader.GetString(2);
                        HistoricoPuesto.apellido1 = reader.GetString(3);
                        HistoricoPuesto.apellido2 = reader.GetString(4);
                        HistoricoPuesto.puesto = reader.GetString(5);
                        HistoricoPuesto.departamento = reader.GetString(6);
                        HistoricoPuesto.fecha_inicio = reader.GetDateTime(7).ToString("yyyy-MM-dd");
                        HistoricoPuesto.fecha_final = reader.GetDateTime(8).ToString("yyyy-MM-dd");

                        listaHistoricoPuestos.Add(HistoricoPuesto);
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
        public class HistoricoPuestoVista
        {
            public string id { get; set; }
            public string cedula { get; set; }
            public string nombre { get; set; }
            public string apellido1 { get; set; }
            public string apellido2 { get; set; }
            public string puesto { get; set; }
            public string departamento { get; set; }
            public string fecha_inicio { get; set; }
            public string fecha_final { get; set; }
        }
    }
}