using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;

namespace ERP.Pages.Inventario.Entrada
{
    public class Entrada_listModel : PageModel
    {
        public List<EntradaVistaInfo> listaEntradas = new List<EntradaVistaInfo>(); // Lista que almacena los datos de los Empleados
        public Conexion conexionBD = new Conexion(); // Instancia de la clase Conexion para manejar la conexión a la base de datos

        /// <summary>
        /// Método que se ejecuta cuando se accede a la página (GET request).
        /// Objetivo: Recuperar la lista de entradas desde la base de datos y lo almacena en la listaEmpleados.
        /// Salidas: Una lista de objetos EntradaListaInfor que contienen información básica de las entradas.
        /// Restricciones: En caso de error, el programa manejará la excepción, cerrando la conexión y mostrando un mensaje.
        /// </summary>
        public void OnGet()
        {
            try
            {
                conexionBD.abrir();
                String sql = "SELECT cedula, administrador, fecha, articulo, cantidad_ingresada, ubicacion_bodega FROM VistaEntradas";
                SqlCommand command = conexionBD.obtenerComando(sql);
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {

                        EntradaVistaInfo entrada = new EntradaVistaInfo();
                        entrada.cedula = reader.GetInt32(0).ToString();
                        entrada.administrador = reader.GetString(1);
                        entrada.fecha = reader.GetDateTime(2).ToString("dd/MM/yyyy HH:mm");
                        entrada.articulo = reader.GetString(3);
                        entrada.cantidad = reader.GetInt32(4).ToString();
                        entrada.ubicacion = reader.GetString(5);

                        listaEntradas.Add(entrada);
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

        // Clase que representa el modelo de vista para la lista de entradas
        public class EntradaVistaInfo
        {
            public string cedula { get; set; }
            public string administrador { get; set; }
            public string fecha { get; set; }
            public string articulo { get; set; }
            public string cantidad { get; set; }
            public string ubicacion { get; set; }
        }
    }
}
