using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;
using System.Data;

namespace ERP.Pages.Cotizacion.CotizacionArticulo
{
    public class CotizacionArticuloFormModel : PageModel
    {
        public CotizacionArticuloInfo CotizacionArticulo { get; set; } = new CotizacionArticuloInfo();
        public List<int> NumerosCotizacion { get; set; } = new List<int>();
        public List<int> CodigosArticulo { get; set; } = new List<int>();

        public string mensaje_error = "";
        public string mensaje_exito = "";

        public Conexion conexionBD = new Conexion(); // Instancia para la conexión a la base de datos

        /// <summary>
        /// Método que se ejecuta cuando se accede a la página (GET request).
        /// Cargar las listas de números de cotización y códigos de artículo.
        /// </summary>
        public void OnGet()
        {
            try
            {
                // Obtener Números de Cotización
                conexionBD.abrir();
                string queryCotizaciones = "SELECT num_cotizacion FROM Cotizacion";
                SqlCommand commandCotizacion = conexionBD.obtenerComando(queryCotizaciones);
                using (SqlDataReader reader = commandCotizacion.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        NumerosCotizacion.Add(reader.GetInt32(0));
                    }
                }
                conexionBD.cerrar();

                // Obtener Códigos de Artículo
                conexionBD.abrir();
                string queryArticulos = "SELECT codigo FROM Articulo";
                SqlCommand commandArticulo = conexionBD.obtenerComando(queryArticulos);
                using (SqlDataReader reader = commandArticulo.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        CodigosArticulo.Add(reader.GetInt32(0));
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

        /// <summary>
        /// Método que se ejecuta cuando se envía el formulario (POST request).
        /// Insertar una nueva entrada en la tabla CotizacionArticulo utilizando el procedimiento almacenado.
        /// </summary>
        public void OnPost()
        {
            CotizacionArticulo.num_cotizacion = int.Parse(Request.Form["num_cotizacion"]);
            CotizacionArticulo.codigo_articulo = int.Parse(Request.Form["codigo_articulo"]);
            CotizacionArticulo.cantidad = int.Parse(Request.Form["cantidad"]);
            CotizacionArticulo.monto = decimal.Parse(Request.Form["monto"]);

            try
            {
                conexionBD.abrir();
                string query = "InsertarCotizacionArticulo";
                SqlCommand command = conexionBD.obtenerComando(query);
                command.CommandType = CommandType.StoredProcedure;

                // Declarar parámetro de error para capturar un posible mensaje de error
                SqlParameter errorParameter = new SqlParameter("@ErrorMsg", SqlDbType.VarChar, 255)
                {
                    Direction = ParameterDirection.Output
                };

                // Agregar parámetros al procedimiento almacenado
                command.Parameters.AddWithValue("@num_cotizacion", CotizacionArticulo.num_cotizacion);
                command.Parameters.AddWithValue("@codigo_articulo", CotizacionArticulo.codigo_articulo);
                command.Parameters.AddWithValue("@cantidad", CotizacionArticulo.cantidad);
                command.Parameters.AddWithValue("@monto", CotizacionArticulo.monto);
                command.Parameters.Add(errorParameter);

                // Ejecutar el procedimiento almacenado
                command.ExecuteNonQuery();

                // Capturar el mensaje de error, si existe
                string errorMsg = (string)command.Parameters["@ErrorMsg"].Value;

                if (string.IsNullOrEmpty(errorMsg))
                {
                    mensaje_exito = "Artículo agregado a la cotización exitosamente.";
                }
                else
                {
                    mensaje_error = $"Error al agregar el artículo: {errorMsg}";
                }
                conexionBD.cerrar();
            }
            catch (Exception ex)
            {
                mensaje_error = ex.Message;
                conexionBD.cerrar();
            }

            // Volver a cargar las listas en caso de error
            OnGet();
        }

        // Clase que representa la estructura de CotizacionArticulo
        public class CotizacionArticuloInfo
        {
            public int num_cotizacion { get; set; }
            public int codigo_articulo { get; set; }
            public int cantidad { get; set; }
            public decimal monto { get; set; }
        }
    }
}