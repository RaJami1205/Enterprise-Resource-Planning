using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;
using System.Data;
using System.Reflection.Metadata;

namespace ERP.Pages.Inventario.Entrada
{
    public class Entrada_formModel : PageModel
    {
        public EntradaInfo Entrada { get; set; } = new EntradaInfo(); // Lista que guarda toda la información de los requests
        public Conexion conexionBD = new Conexion(); // Instancia de la clase Conexion para manejar la conexión a la base de datos
        public List<string> listaBodegas { get; set; } = new List<string>();
        public List<string> listaEmpleados { get; set; } = new List<string>();
        public List<string> listaArticulos { get; set; } = new List<string>();
        public List<string> listaArticulosEnBodega { get; set; } = new List<string>();
        public List<string> listaCodigosFamilias { get; set; } = new List<string>();
        public string mensaje_error = ""; // Variable para almacenar mensajes de error
        public string mensaje_exito = ""; // Variable para almacenar mensajes de éxito

        /// <summary>
        /// Método que se ejecuta cuando se ingresa al formulario (GET request).
        /// Objetivo: Extraer los datos de los códigos de bodegas y artículos y la cédulas de los empleados y manejar errores.
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
            string ubicacion_bodega = Request.Form["bodega_destino"];
            string nombre_articulo = Request.Form["codigo_articulo"];

            conexionBD.abrir();
            String sqlAsignarCodigoBodega = "SELECT codigo_bodega FROM Bodega WHERE ubicacion = @ubicacion_bodega";
            SqlCommand command_bodega = conexionBD.obtenerComando(sqlAsignarCodigoBodega);
            command_bodega.Parameters.AddWithValue("@ubicacion_bodega", ubicacion_bodega);
            using (SqlDataReader reader = command_bodega.ExecuteReader())
            {
                while (reader.Read())
                {
                    Entrada.codigo_bodega = reader.GetInt32(0).ToString();
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
                    Entrada.codigo_articulo = reader.GetInt32(0).ToString();
                }
            }
            conexionBD.cerrar();

            Entrada.id = Request.Form["id"];
            Entrada.fecha_hora = Request.Form["fecha_hora"];
            Entrada.cedula_administrador = Request.Form["cedula_empleado"];
            Entrada.cantidad = Request.Form["cantidad"];
            string codigo_familia_articulo = "";
            int capacidad_bodega = 0;
            int cantidad_bodega = 0;
            bool check_codigo_familia = false;
            bool validar_existencia_articulo = false;

            conexionBD.abrir();
            String sqlVerificacion0 = "SELECT codigo_articulo FROM BodegaArticulo WHERE codigo_bodega = @codigo_bodega";
            SqlCommand command_0 = conexionBD.obtenerComando(sqlVerificacion0);
            command_0.Parameters.AddWithValue("@codigo_bodega", Entrada.codigo_bodega);
            using (SqlDataReader reader = command_0.ExecuteReader())
            {
                while (reader.Read())
                {
                    listaCodigosFamilias.Add("" + reader.GetInt32(0));
                }
            }
            conexionBD.cerrar();

            conexionBD.abrir();
            String sqlVerificacion1 = "SELECT codigo_familia FROM BodegaFamilia WHERE codigo_bodega = @codigo_bodega";
            SqlCommand command_1 = conexionBD.obtenerComando(sqlVerificacion1);
            command_1.Parameters.AddWithValue("@codigo_bodega", Entrada.codigo_bodega);
            using (SqlDataReader reader = command_1.ExecuteReader())
            {
                while (reader.Read())
                {
                    listaCodigosFamilias.Add("" + reader.GetInt32(0));
                }
            }
            conexionBD.cerrar();

            conexionBD.abrir();
            String sqlVerificacion2 = "SELECT capacidad FROM Bodega WHERE codigo_bodega = @codigo_bodega";
            SqlCommand command_2 = conexionBD.obtenerComando(sqlVerificacion2);
            command_2.Parameters.AddWithValue("@codigo_bodega", Entrada.codigo_bodega);
            using (SqlDataReader reader = command_2.ExecuteReader())
            {
                while (reader.Read())
                {
                    capacidad_bodega = reader.GetInt32(0);
                }
            }
            conexionBD.cerrar();

            conexionBD.abrir();
            String sqlVerificacion3 = "SELECT codigo_familia FROM Articulo WHERE codigo = @codigo_articulo";
            SqlCommand command_3 = conexionBD.obtenerComando(sqlVerificacion3);
            command_3.Parameters.AddWithValue("@codigo_articulo", Entrada.codigo_articulo);
            using (SqlDataReader reader = command_3.ExecuteReader())
            {
                while (reader.Read())
                {
                    codigo_familia_articulo = reader.GetInt32(0).ToString();
                }
            }
            conexionBD.cerrar();

            conexionBD.abrir();
            String sqlCantidad = "SELECT cantidad FROM BodegaArticulo WHERE codigo_bodega = @codigo_bodega AND codigo_articulo = @codigo_articulo";
            SqlCommand command_cantidad = conexionBD.obtenerComando(sqlCantidad);
            command_cantidad.Parameters.AddWithValue("@codigo_bodega", Entrada.codigo_bodega);
            command_cantidad.Parameters.AddWithValue("@codigo_articulo", Entrada.codigo_articulo);
            using (SqlDataReader reader = command_cantidad.ExecuteReader())
            {
                while (reader.Read())
                {
                    cantidad_bodega = reader.GetInt32(0);
                }
            }
            conexionBD.cerrar();

            check_codigo_familia = listaCodigosFamilias.Contains(codigo_familia_articulo);
            validar_existencia_articulo = listaArticulos.Contains(Entrada.codigo_articulo);

            if (capacidad_bodega == 0)
            {
                mensaje_error = "Error: No hay espacio disponible en la bodega";
                conexionBD.cerrar();
                OnGet();
                return;
            }

            if (int.Parse(Entrada.cantidad) > capacidad_bodega)
            {
                mensaje_error = "Error: La cantidad ingresada supera la capacidad actual de la bodega";
                conexionBD.cerrar();
                OnGet();
                return;
            }

            if (!check_codigo_familia)
            {
                mensaje_error = "Error: El artículo no coincide con ninguna familia de la bodega";
                conexionBD.cerrar();
                OnGet();
                return;
            }

            try
            {
                conexionBD.abrir();
                string query_1 = "InsertarEntrada";
                SqlCommand command_4 = conexionBD.obtenerComando(query_1);
                command_4.CommandType = System.Data.CommandType.StoredProcedure;
                SqlParameter errorParameter = new SqlParameter("@ErrorMsg", SqlDbType.VarChar, 255)
                {
                    Direction = ParameterDirection.Output
                };

                command_4.Parameters.AddWithValue("@codigo_entrada", Entrada.id);
                command_4.Parameters.AddWithValue("@fecha_hora", DateTime.Parse(Entrada.fecha_hora));
                command_4.Parameters.AddWithValue("@codigo_bodega", Entrada.codigo_bodega);
                command_4.Parameters.AddWithValue("@cedula_administrador", Entrada.cedula_administrador);
                command_4.Parameters.Add(errorParameter);

                command_4.ExecuteNonQuery();
                string ErrorMesage_1 = (string)command_4.Parameters["@ErrorMsg"].Value;
                conexionBD.cerrar();

                conexionBD.abrir();
                string query_2 = "InsertarEntradaArticulo";
                SqlCommand command_5 = conexionBD.obtenerComando(query_2);
                command_5.CommandType = System.Data.CommandType.StoredProcedure;
                SqlParameter errorParameter_2 = new SqlParameter("@ErrorMsg", SqlDbType.VarChar, 255)
                {
                    Direction = ParameterDirection.Output
                };

                command_5.Parameters.AddWithValue("@codigo_entrada", Entrada.id);
                command_5.Parameters.AddWithValue("@fecha_hora_entrada", DateTime.Parse(Entrada.fecha_hora));
                command_5.Parameters.AddWithValue("@codigo_bodega", Entrada.codigo_bodega);
                command_5.Parameters.AddWithValue("@cedula_administrador", Entrada.cedula_administrador);
                command_5.Parameters.AddWithValue("@codigo_articulo", Entrada.codigo_articulo);
                command_5.Parameters.AddWithValue("@cantidad", Entrada.cantidad);
                command_5.Parameters.Add(errorParameter_2);


                command_5.ExecuteNonQuery();
                string ErrorMesage_2 = (string)command_5.Parameters["@ErrorMsg"].Value;
                conexionBD.cerrar();

                int nueva_capacidad = capacidad_bodega - int.Parse(Entrada.cantidad);
                int nueva_cantidad = cantidad_bodega + int.Parse(Entrada.cantidad);

                conexionBD.abrir();
                string query_3 = "ModificarCapacidadBodega";
                SqlCommand command_6 = conexionBD.obtenerComando(query_3);
                command_6.CommandType = System.Data.CommandType.StoredProcedure;
                SqlParameter errorParameter_3 = new SqlParameter("@ErrorMsg", SqlDbType.VarChar, 255)
                {
                    Direction = ParameterDirection.Output
                };

                command_6.Parameters.AddWithValue("@codigo_bodega", Entrada.codigo_bodega);
                command_6.Parameters.AddWithValue("@nueva_capacidad", nueva_capacidad);
                command_6.Parameters.Add(errorParameter_3);


                command_6.ExecuteNonQuery();
                string ErrorMesage_3 = (string)command_6.Parameters["@ErrorMsg"].Value;
                conexionBD.cerrar();

                if (!validar_existencia_articulo) 

                {
                    conexionBD.abrir();
                    string query_8 = "InsertarBodegaArticulo";
                    SqlCommand command_8 = conexionBD.obtenerComando(query_8);
                    command_8.CommandType = System.Data.CommandType.StoredProcedure;
                    SqlParameter errorParameter_8 = new SqlParameter("@ErrorMsg", SqlDbType.VarChar, 255)
                    {
                        Direction = ParameterDirection.Output
                    };

                    command_8.Parameters.AddWithValue("@codigo_articulo", Entrada.codigo_articulo);
                    command_8.Parameters.AddWithValue("@codigo_bodega", Entrada.codigo_bodega);
                    command_8.Parameters.AddWithValue("@cantidad", Entrada.cantidad);
                    command_8.Parameters.Add(errorParameter_8);


                    command_8.ExecuteNonQuery();
                    string ErrorMesage_8 = (string)command_5.Parameters["@ErrorMsg"].Value;
                    conexionBD.cerrar();

                    // Limpieza del formulario
                    Entrada.id = "";
                    Entrada.fecha_hora = "";
                    Entrada.cedula_administrador = "";
                    Entrada.codigo_bodega = "";
                    Entrada.codigo_articulo = "";
                    Entrada.cantidad = "";

                    mensaje_exito = "Entrada registrada exitosamente";
                    return;
                }

                conexionBD.abrir();
                string query_4 = "ModificarCantidadBodega";
                SqlCommand command_7 = conexionBD.obtenerComando(query_4);
                command_7.CommandType = System.Data.CommandType.StoredProcedure;
                SqlParameter errorParameter_4 = new SqlParameter("@ErrorMsg", SqlDbType.VarChar, 255)
                {
                    Direction = ParameterDirection.Output
                };

                command_7.Parameters.AddWithValue("@codigo_articulo", Entrada.codigo_articulo);
                command_7.Parameters.AddWithValue("@codigo_bodega", Entrada.codigo_bodega);
                command_7.Parameters.AddWithValue("@cantidad", nueva_cantidad);
                command_7.Parameters.Add(errorParameter_4);


                command_7.ExecuteNonQuery();
                string ErrorMesage_4 = (string)command_7.Parameters["@ErrorMsg"].Value;
                conexionBD.cerrar();

                // Limpieza del formulario
                Entrada.id = "";
                Entrada.fecha_hora = "";
                Entrada.cedula_administrador = "";
                Entrada.codigo_bodega = "";
                Entrada.codigo_articulo = "";
                Entrada.cantidad = "";

                mensaje_exito = "Entrada registrada exitosamente";
            }
            catch (Exception ex)
            {
                mensaje_error = ex.Message;
                conexionBD.cerrar();
                OnGet();
            }
        }

        // Clase que representa el modelo de vista para el formulario de empleado
        public class EntradaInfo
        {
            public string id { get; set; }
            public string fecha_hora { get; set; }
            public string codigo_bodega { get; set; }
            public string cedula_administrador { get; set; }
            public string codigo_articulo { get; set; }
            public string cantidad { get; set; }
        }
    }
}