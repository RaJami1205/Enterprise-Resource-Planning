using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;
using static ERP.Pages.Inventario.Entrada.Entrada_listModel;

namespace ERP.Pages.Inventario.Movimiento
{
    public class Movimiento_listModel : PageModel
    {
        public List<MovimientoVistaInfo> listaMovimientos = new List<MovimientoVistaInfo>(); // Lista que almacena los datos de los Empleados
        public Conexion conexionBD = new Conexion(); // Instancia de la clase Conexion para manejar la conexión a la base de datos

        /// <summary>
        /// Método que se ejecuta cuando se accede a la página (GET request).
        /// Objetivo: Recuperar la lista de movimientos desde la base de datos y lo almacena en la listaMovimientos.
        /// Salidas: Una lista de objetos MovimientoVistaInfor que contienen información básica de los movimientos.
        /// Restricciones: En caso de error, el programa manejará la excepción, cerrando la conexión y mostrando un mensaje.
        /// </summary>
        public void OnGet()
        {
            try
            {
                conexionBD.abrir();
                String sql = "SELECT cedula, administrador, fecha, articulo, cantidad_movida, ubicacion_bodega_origen, ubicacion_bodega_destino FROM VistaMovimientos";
                SqlCommand command = conexionBD.obtenerComando(sql);
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {

                        MovimientoVistaInfo movimiento = new MovimientoVistaInfo();
                        movimiento.cedula = reader.GetInt32(0).ToString();
                        movimiento.administrador = reader.GetString(1);
                        movimiento.fecha = reader.GetDateTime(2).ToString("dd/MM/yyyy HH:mm");
                        movimiento.articulo = reader.GetString(3);
                        movimiento.cantidad = reader.GetInt32(4).ToString();
                        movimiento.ubicacion_bodega_origen = reader.GetString(5);
                        movimiento.ubicacion_bodega_destino = reader.GetString(6);

                        listaMovimientos.Add(movimiento);
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

        public class MovimientoVistaInfo
        {
            public string cedula { get; set; }
            public string administrador { get; set; }
            public string fecha { get; set; }
            public string articulo { get; set; }
            public string cantidad { get; set; }
            public string ubicacion_bodega_origen { get; set; }
            public string ubicacion_bodega_destino { get; set; }
        }
    }
}