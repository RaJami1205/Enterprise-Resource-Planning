using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;
using System.Data;
using System.Linq;

namespace ERP.Pages.Inventario.Movimiento
{
    public class Movimiento_formModel : PageModel
    {
        public MovimientoInfo Movimiento { get; set; } = new MovimientoInfo(); // Lista que guarda toda la información de los requests
        public Conexion conexionBD = new Conexion(); // Instancia de la clase Conexion para manejar la conexión a la base de datos
        public List<string> listaBodegas { get; set; } = new List<string>();
        public List<string> listaEmpleados { get; set; } = new List<string>();
        public List<string> listaArticulos { get; set; } = new List<string>();
        public List<string> listaArticulosBodegaOrigen { get; set; } = new List<string>();
        public List<string> listaFamiliasBodegaDestino { get; set; } = new List<string>();
        public List<string> listaArticulosBodegaDestino { get; set; } = new List<string>();
        public string mensaje_error = ""; // Variable para almacenar mensajes de error
        public string mensaje_exito = ""; // Variable para almacenar mensajes de éxito

        /// <summary>
        /// Método que se ejecuta cuando se ingresa al formulario (GET request).
        /// Objetivo: Extraer los datos de los ID de puesto y departamento y manejar errores.
        /// Entradas: Ninguna.
        /// Salidas: Mensaje de éxito o mensaje de error.
        /// </summary>
        public void OnGet()
        {
            conexionBD.abrir();
            string sqlBodega = "SELECT ubicacion FROM Bodega";
            SqlCommand command_bodega = conexionBD.obtenerComando(sqlBodega);
            using (SqlDataReader reader = command_bodega.ExecuteReader())
            {
                while (reader.Read())
                {
                    listaBodegas.Add("" + reader.GetString(0));
                }
            }
            conexionBD.cerrar();

            conexionBD.abrir();
            string sqlEmpleado = "SELECT cedula FROM Empleado";
            SqlCommand command_empleado = conexionBD.obtenerComando(sqlEmpleado);
            using (SqlDataReader reader = command_empleado.ExecuteReader())
            {
                while (reader.Read())
                {
                    listaEmpleados.Add("" + reader.GetInt32(0));
                }
            }
            conexionBD.cerrar();

            conexionBD.abrir();
            string sqlArticulo = "SELECT nombre FROM Articulo";
            SqlCommand command_articulo = conexionBD.obtenerComando(sqlArticulo);
            using (SqlDataReader reader = command_articulo.ExecuteReader())
            {
                while (reader.Read())
                {
                    listaArticulos.Add("" + reader.GetString(0));
                }
            }
            conexionBD.cerrar();
        }

        /// <summary>
        /// Método que se ejecuta cuando se envía el formulario (POST request).
        /// Objetivo: Recibir los datos del formulario de entrada, insertarlos en la base de datos y manejar errores.
        /// Entradas: Datos del formulario (fecha_hora, cedula_empleado, bodega_destino, codigo_articulo, cantidad).
        /// Salidas: Mensaje de éxito o mensaje de error.
        /// Restricciones: Todos los campos deben estar debidamente validados antes de enviarse y debe preservarse la integridad entre los artículos y las bodegas.
        /// </summary>
        public void OnPost()
        {
            string ubicacion_bodega_origen = Request.Form["bodega_origen"];
            string ubicacion_bodega_destino = Request.Form["bodega_destino"];
            string nombre_articulo = Request.Form["codigo_articulo"];

            conexionBD.abrir();
            String sqlAsignarCodigoBodegaOrigen = "SELECT codigo_bodega FROM Bodega WHERE ubicacion = @ubicacion_bodega_origen";
            SqlCommand command_bodega_origen = conexionBD.obtenerComando(sqlAsignarCodigoBodegaOrigen);
            command_bodega_origen.Parameters.AddWithValue("@ubicacion_bodega_origen", ubicacion_bodega_origen);
            using (SqlDataReader reader = command_bodega_origen.ExecuteReader())
            {
                while (reader.Read())
                {
                    Movimiento.codigo_bodega_origen = reader.GetInt32(0).ToString();
                }
            }
            conexionBD.cerrar();

            conexionBD.abrir();
            String sqlAsignarCodigoBodegaDestino = "SELECT codigo_bodega FROM Bodega WHERE ubicacion = @ubicacion_bodega_destino";
            SqlCommand command_bodega_destino = conexionBD.obtenerComando(sqlAsignarCodigoBodegaDestino);
            command_bodega_destino.Parameters.AddWithValue("@ubicacion_bodega_destino", ubicacion_bodega_destino);
            using (SqlDataReader reader = command_bodega_destino.ExecuteReader())
            {
                while (reader.Read())
                {
                    Movimiento.codigo_bodega_destino = reader.GetInt32(0).ToString();
                }
            }
            conexionBD.cerrar();

            conexionBD.abrir();
            String sqlAsignarCodigoArticulo = "SELECT codigo FROM Articulo WHERE nombre = @nombre_articulo";
            SqlCommand command_articulo = conexionBD.obtenerComando(sqlAsignarCodigoArticulo);
            command_articulo.Parameters.AddWithValue("@nombre_articulo", nombre_articulo);
            using (SqlDataReader reader = command_articulo.ExecuteReader())
            {
                while (reader.Read())
                {
                    Movimiento.codigo_articulo = reader.GetInt32(0).ToString();
                }
            }
            conexionBD.cerrar();

            Movimiento.id = Request.Form["id"];
            Movimiento.fecha_hora = Request.Form["fecha_hora"];
            Movimiento.cedula_administrador = Request.Form["cedula_empleado"];
            Movimiento.cantidad = Request.Form["cantidad"];
            string codigo_familia_articulo = "";
            int cantidad_bodega_origen = 0;
            int capacidad_bodega_origen = 0;
            int capacidad_bodega_destino = 0;
            int cantidad_bodega_destino = 0;
            bool check_codigo_familia = false;
            bool check_articulo_existente_origen = false;
            bool check_articulo_existente_destino = false;

            if (Movimiento.codigo_bodega_origen == Movimiento.codigo_bodega_destino)
            {
                mensaje_error = "Error: La bodega de orígen y la bodega de destino no pueden ser la misma";
                OnGet();
                return;
            }

            conexionBD.abrir();
            String sqlVerificacion1 = "SELECT codigo_articulo FROM BodegaArticulo WHERE codigo_bodega = @codigo_bodega";
            SqlCommand command_1 = conexionBD.obtenerComando(sqlVerificacion1);
            command_1.Parameters.AddWithValue("@codigo_bodega", Movimiento.codigo_bodega_origen);
            using (SqlDataReader reader = command_1.ExecuteReader())
            {
                while (reader.Read())
                {
                    listaArticulosBodegaOrigen.Add("" + reader.GetInt32(0));
                }
            }
            conexionBD.cerrar();

            conexionBD.abrir();
            String sqlVerificacion2 = "SELECT codigo_familia FROM BodegaFamilia WHERE codigo_bodega = @codigo_bodega";
            SqlCommand command_2 = conexionBD.obtenerComando(sqlVerificacion2);
            command_2.Parameters.AddWithValue("@codigo_bodega", Movimiento.codigo_bodega_destino);
            using (SqlDataReader reader = command_2.ExecuteReader())
            {
                while (reader.Read())
                {
                    listaFamiliasBodegaDestino.Add("" + reader.GetInt32(0));
                }
            }
            conexionBD.cerrar();

            conexionBD.abrir();
            String sqlVerificacion3 = "SELECT codigo_familia FROM Articulo WHERE codigo = @codigo_articulo";
            SqlCommand command_3 = conexionBD.obtenerComando(sqlVerificacion3);
            command_3.Parameters.AddWithValue("@codigo_articulo", Movimiento.codigo_articulo);
            using (SqlDataReader reader = command_3.ExecuteReader())
            {
                while (reader.Read())
                {
                    codigo_familia_articulo = reader.GetInt32(0).ToString();
                }
            }
            conexionBD.cerrar();

            conexionBD.abrir();
            String sqlCapacidad_origen = "SELECT capacidad FROM Bodega WHERE codigo_bodega = @codigo_bodega";
            SqlCommand command_capacidad_origen = conexionBD.obtenerComando(sqlCapacidad_origen);
            command_capacidad_origen.Parameters.AddWithValue("@codigo_bodega", Movimiento.codigo_bodega_origen);
            using (SqlDataReader reader = command_capacidad_origen.ExecuteReader())
            {
                while (reader.Read())
                {
                    capacidad_bodega_origen = reader.GetInt32(0);
                }
            }
            conexionBD.cerrar();

            conexionBD.abrir();
            String sqlCantidad_origen = "SELECT cantidad FROM BodegaArticulo WHERE codigo_bodega = @codigo_bodega AND codigo_articulo = @codigo_articulo";
            SqlCommand command_cantidad_origen = conexionBD.obtenerComando(sqlCantidad_origen);
            command_cantidad_origen.Parameters.AddWithValue("@codigo_bodega", Movimiento.codigo_bodega_origen);
            command_cantidad_origen.Parameters.AddWithValue("@codigo_articulo", Movimiento.codigo_articulo);
            using (SqlDataReader reader = command_cantidad_origen.ExecuteReader())
            {
                while (reader.Read())
                {
                    cantidad_bodega_origen = reader.GetInt32(0);
                }
            }
            conexionBD.cerrar();

            conexionBD.abrir();
            String sqlCapacidad_destino = "SELECT capacidad FROM Bodega WHERE codigo_bodega = @codigo_bodega";
            SqlCommand command_capacidad_destino = conexionBD.obtenerComando(sqlCapacidad_destino);
            command_capacidad_destino.Parameters.AddWithValue("@codigo_bodega", Movimiento.codigo_bodega_destino);
            using (SqlDataReader reader = command_capacidad_destino.ExecuteReader())
            {
                while (reader.Read())
                {
                    capacidad_bodega_destino = reader.GetInt32(0);
                }
            }
            conexionBD.cerrar();

            conexionBD.abrir();
            String sqlCantidad_destino = "SELECT cantidad FROM BodegaArticulo WHERE codigo_bodega = @codigo_bodega AND codigo_articulo = @codigo_articulo";
            SqlCommand command_cantidad_destino = conexionBD.obtenerComando(sqlCantidad_destino);
            command_cantidad_destino.Parameters.AddWithValue("@codigo_bodega", Movimiento.codigo_bodega_destino);
            command_cantidad_destino.Parameters.AddWithValue("@codigo_articulo", Movimiento.codigo_articulo);
            using (SqlDataReader reader = command_cantidad_destino.ExecuteReader())
            {
                while (reader.Read())
                {
                    cantidad_bodega_destino = reader.GetInt32(0);
                }
            }
            conexionBD.cerrar();

            check_codigo_familia = listaFamiliasBodegaDestino.Contains(codigo_familia_articulo);
            check_articulo_existente_origen = listaArticulosBodegaOrigen.Contains(Movimiento.codigo_articulo);
            check_articulo_existente_destino = listaArticulosBodegaDestino.Contains(Movimiento.codigo_articulo);

            if (cantidad_bodega_origen == 0)
            {
                mensaje_error = "Error: No hay existencias disponibles en la bodega de origen";
                OnGet();
                return;
            }

            if (capacidad_bodega_destino == 0)
            {
                mensaje_error = "Error: No hay espacio disponible en la bodega de destino";
                OnGet();
                return;
            }

            if (cantidad_bodega_origen - int.Parse(Movimiento.cantidad) < 0)
            {
                mensaje_error = "Error: No hay existencias suficientes para la cantidad solicitada";
                OnGet();
                return;
            }

            if (!check_codigo_familia)
            {
                mensaje_error = "Error: El artículo no coincide con ninguna familia de la bodega de destino";
                OnGet();
                return;
            }

            if (!check_articulo_existente_origen)
            {
                mensaje_error = "Error: El artículo seleccionado no pertenece a la bodega de origen";
                OnGet();
                return;
            }

            try
            {
                conexionBD.abrir();
                string query_1 = "InsertarMovimiento";
                SqlCommand command_4 = conexionBD.obtenerComando(query_1);
                command_4.CommandType = System.Data.CommandType.StoredProcedure;
                SqlParameter errorParameter = new SqlParameter("@ErrorMsg", SqlDbType.VarChar, 255)
                {
                    Direction = ParameterDirection.Output
                };

                command_4.Parameters.AddWithValue("@codigo_movimiento", Movimiento.id);
                command_4.Parameters.AddWithValue("@fecha_hora", DateTime.Parse(Movimiento.fecha_hora));
                command_4.Parameters.AddWithValue("@cedula_administrador", Movimiento.cedula_administrador);
                command_4.Parameters.AddWithValue("@codigo_bodega_origen", Movimiento.codigo_bodega_origen);
                command_4.Parameters.AddWithValue("@codigo_bodega_destino", Movimiento.codigo_bodega_destino);
                command_4.Parameters.Add(errorParameter);

                command_4.ExecuteNonQuery();
                string ErrorMesage_1 = (string)command_4.Parameters["@ErrorMsg"].Value;
                conexionBD.cerrar();

                conexionBD.abrir();
                string query_2 = "InsertarMovimientoArticulo";
                SqlCommand command_5 = conexionBD.obtenerComando(query_2);
                command_5.CommandType = System.Data.CommandType.StoredProcedure;
                SqlParameter errorParameter_2 = new SqlParameter("@ErrorMsg", SqlDbType.VarChar, 255)
                {
                    Direction = ParameterDirection.Output
                };

                command_5.Parameters.AddWithValue("@codigo_movimiento", Movimiento.id);
                command_5.Parameters.AddWithValue("@fecha_hora_movimiento", DateTime.Parse(Movimiento.fecha_hora));
                command_5.Parameters.AddWithValue("@cedula_administrador", Movimiento.cedula_administrador);
                command_5.Parameters.AddWithValue("@codigo_bodega_origen", Movimiento.codigo_bodega_origen);
                command_5.Parameters.AddWithValue("@codigo_bodega_destino", Movimiento.codigo_bodega_destino);
                command_5.Parameters.AddWithValue("@codigo_articulo", Movimiento.codigo_articulo);
                command_5.Parameters.AddWithValue("@cantidad", Movimiento.cantidad);
                command_5.Parameters.Add(errorParameter_2);


                command_5.ExecuteNonQuery();
                string ErrorMesage_2 = (string)command_5.Parameters["@ErrorMsg"].Value;
                conexionBD.cerrar();

                int nueva_capacidad_origen = capacidad_bodega_origen + int.Parse(Movimiento.cantidad);
                int nueva_cantidad_origen = cantidad_bodega_origen - int.Parse(Movimiento.cantidad);
                int nueva_capacidad_destino = capacidad_bodega_destino - int.Parse(Movimiento.cantidad);
                int nueva_cantidad_destino = cantidad_bodega_destino + int.Parse(Movimiento.cantidad);

                conexionBD.abrir();
                string query_3 = "ModificarCapacidadBodega";
                SqlCommand command_6 = conexionBD.obtenerComando(query_3);
                command_6.CommandType = System.Data.CommandType.StoredProcedure;
                SqlParameter errorParameter_3 = new SqlParameter("@ErrorMsg", SqlDbType.VarChar, 255)
                {
                    Direction = ParameterDirection.Output
                };

                command_6.Parameters.AddWithValue("@codigo_bodega", Movimiento.codigo_bodega_origen);
                command_6.Parameters.AddWithValue("@nueva_capacidad", nueva_capacidad_origen);
                command_6.Parameters.Add(errorParameter_3);


                command_6.ExecuteNonQuery();
                string ErrorMesage_3 = (string)command_6.Parameters["@ErrorMsg"].Value;
                conexionBD.cerrar();

                conexionBD.abrir();
                string query_4 = "ModificarCapacidadBodega";
                SqlCommand command_7 = conexionBD.obtenerComando(query_4);
                command_7.CommandType = System.Data.CommandType.StoredProcedure;
                SqlParameter errorParameter_4 = new SqlParameter("@ErrorMsg", SqlDbType.VarChar, 255)
                {
                    Direction = ParameterDirection.Output
                };

                command_7.Parameters.AddWithValue("@codigo_bodega", Movimiento.codigo_bodega_destino);
                command_7.Parameters.AddWithValue("@nueva_capacidad", nueva_capacidad_destino);
                command_7.Parameters.Add(errorParameter_4);


                command_7.ExecuteNonQuery();
                string ErrorMesage_4 = (string)command_7.Parameters["@ErrorMsg"].Value;
                conexionBD.cerrar();

                conexionBD.abrir();
                string query_5 = "ModificarCantidadBodega";
                SqlCommand command_8 = conexionBD.obtenerComando(query_5);
                command_8.CommandType = System.Data.CommandType.StoredProcedure;
                SqlParameter errorParameter_5 = new SqlParameter("@ErrorMsg", SqlDbType.VarChar, 255)
                {
                    Direction = ParameterDirection.Output
                };

                command_8.Parameters.AddWithValue("@codigo_articulo", Movimiento.codigo_articulo);
                command_8.Parameters.AddWithValue("@codigo_bodega", Movimiento.codigo_bodega_origen);
                command_8.Parameters.AddWithValue("@nueva_cantidad", nueva_cantidad_origen);
                command_8.Parameters.Add(errorParameter_5);

                command_8.ExecuteNonQuery();
                string ErrorMesage_5 = (string)command_8.Parameters["@ErrorMsg"].Value;
                conexionBD.cerrar();

                conexionBD.abrir();
                string query_11 = "ModificarCantidadBodega";
                SqlCommand command_11 = conexionBD.obtenerComando(query_11);
                command_11.CommandType = System.Data.CommandType.StoredProcedure;
                SqlParameter errorParameter_11 = new SqlParameter("@ErrorMsg", SqlDbType.VarChar, 255)
                {
                    Direction = ParameterDirection.Output
                };

                command_11.Parameters.AddWithValue("@codigo_articulo", Movimiento.codigo_articulo);
                command_11.Parameters.AddWithValue("@codigo_bodega", Movimiento.codigo_bodega_destino);
                command_11.Parameters.AddWithValue("@nueva_cantidad", nueva_cantidad_destino);
                command_11.Parameters.Add(errorParameter_11);


                command_11.ExecuteNonQuery();
                string ErrorMesage_11 = (string)command_11.Parameters["@ErrorMsg"].Value;
                conexionBD.cerrar();

                if (!check_articulo_existente_destino)
                {
                    conexionBD.abrir();
                    string query_6 = "InsertarBodegaArticulo";
                    SqlCommand command_9 = conexionBD.obtenerComando(query_6);
                    command_9.CommandType = System.Data.CommandType.StoredProcedure;
                    SqlParameter errorParameter_6 = new SqlParameter("@ErrorMsg", SqlDbType.VarChar, 255)
                    {
                        Direction = ParameterDirection.Output
                    };

                    command_9.Parameters.AddWithValue("@codigo_articulo", Movimiento.codigo_articulo);
                    command_9.Parameters.AddWithValue("@codigo_bodega", Movimiento.codigo_bodega_destino);
                    command_9.Parameters.AddWithValue("@cantidad", Movimiento.cantidad);
                    command_9.Parameters.Add(errorParameter_6);

                    command_9.ExecuteNonQuery();
                    string ErrorMesage_6 = (string)command_9.Parameters["@ErrorMsg"].Value;
                    conexionBD.cerrar();

                    // Limpieza del formulario
                    Movimiento.id = "";
                    Movimiento.fecha_hora = "";
                    Movimiento.cedula_administrador = "";
                    Movimiento.codigo_bodega_origen = "";
                    Movimiento.codigo_bodega_destino = "";
                    Movimiento.codigo_articulo = "";
                    Movimiento.cantidad = "";

                    mensaje_exito = "Movimiento registrado exitosamente";
                    return;
                }

                conexionBD.abrir();
                string query_7 = "ModificarCantidadBodega";
                SqlCommand command_10 = conexionBD.obtenerComando(query_7);
                command_10.CommandType = System.Data.CommandType.StoredProcedure;
                SqlParameter errorParameter_7 = new SqlParameter("@ErrorMsg", SqlDbType.VarChar, 255)
                {
                    Direction = ParameterDirection.Output
                };

                command_10.Parameters.AddWithValue("@codigo_articulo", Movimiento.codigo_articulo);
                command_10.Parameters.AddWithValue("@codigo_bodega", Movimiento.codigo_bodega_destino);
                command_10.Parameters.AddWithValue("@cantidad", Movimiento.cantidad);
                command_10.Parameters.Add(errorParameter_7);

                command_10.ExecuteNonQuery();
                string ErrorMesage_7 = (string)command_10.Parameters["@ErrorMsg"].Value;
                conexionBD.cerrar();

                // Limpieza del formulario
                Movimiento.id = "";
                Movimiento.fecha_hora = "";
                Movimiento.cedula_administrador = "";
                Movimiento.codigo_bodega_origen = "";
                Movimiento.codigo_bodega_destino = "";
                Movimiento.codigo_articulo = "";
                Movimiento.cantidad = "";

                mensaje_exito = "Movimiento registrado exitosamente";
            }
            catch (Exception ex)
            {
                mensaje_error = ex.Message;
                conexionBD.cerrar();
                OnGet();
            }
        }

        // Clase que representa el modelo de vista para el formulario de Movimiento
        public class MovimientoInfo
        {
            public string id { get; set; }
            public string fecha_hora { get; set; }
            public string codigo_bodega_origen { get; set; }
            public string codigo_bodega_destino { get; set; }
            public string cedula_administrador { get; set; }
            public string codigo_articulo { get; set; }
            public string cantidad { get; set; }
        }
    }
}