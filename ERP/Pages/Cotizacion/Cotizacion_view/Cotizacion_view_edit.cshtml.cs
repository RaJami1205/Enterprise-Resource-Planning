using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;

namespace ERP.Pages.Cotizacion.Cotizacion_view
{
    public class Cotizacion_view_editModel : PageModel
    {
        public Conexion conexionBD = new Conexion();
        public List<CotizacionInfo> listaCotizaciones = new List<CotizacionInfo>();
        public string mensaje_error = "";
        public string mensaje_exito = "";
        public List<string> Zonas { get; set; } = new List<string>();
        public List<string> Sectores { get; set; } = new List<string>();
        public List<string> EstadosCotizacion { get; set; } = new List<string>();
        public List<string> TiposCotizacion { get; set; } = new List<string>();
        public List<string> Clientes { get; set; } = new List<string>();
        public List<string> Empleados { get; set; } = new List<string>();
        public CotizacionInfo Cotizacion { get; set; } = new CotizacionInfo();
        public void OnGet()
        {
            try
            {
                string id =Request.Query["num_cotizacion"];
                conexionBD.abrir();
                string query = "SELECT * FROM VistaCotizacion WHERE num_cotizacion=@id";
                SqlCommand comando = conexionBD.obtenerComando(query);
                using (SqlDataReader reader = comando.ExecuteReader()) // Ejecutamos el lector
                {
                    if(reader.Read())
                    {
                        Cotizacion.num_cotizacion = reader.GetInt32(0).ToString();
                        Cotizacion.orden_compra = reader.GetString(1);
                        Cotizacion.descripcion = reader.GetString(2);
                        Cotizacion.monto_total = reader.GetDecimal(3).ToString();
                        Cotizacion.mes_cierre = reader.GetInt32(4).ToString();
                        Cotizacion.probabilidad = reader.GetDecimal(5).ToString();
                        Cotizacion.fecha_inicio = reader.GetDateTime(6).ToString("yyyy-MM-dd");
                        Cotizacion.fecha_cierre = reader.GetDateTime(7).ToString("yyyy-MM-dd");
                        Cotizacion.razon_negacion = !reader.IsDBNull(8) ? reader.GetString(8) : null;
                        Cotizacion.cedula_vendedor = reader.GetInt32(9).ToString();
                        Cotizacion.cedula_cliente = reader.GetInt32(10).ToString();
                        Cotizacion.zona = reader.GetString(11);
                        Cotizacion.sector = reader.GetString(12);
                        Cotizacion.estado = reader.GetString(13);
                        Cotizacion.tipo = reader.GetString(14);
                    }
                }

                // Obtener Zonas
                conexionBD.abrir();
                string query1 = "SELECT nombre FROM Zona";
                SqlCommand commandZona = conexionBD.obtenerComando(query1);
                using (SqlDataReader reader = commandZona.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        Zonas.Add(reader.GetString(0));
                    }
                }
                conexionBD.cerrar();

                // Obtener Sectores
                conexionBD.abrir();
                string query2 = "SELECT nombre FROM Sector";
                SqlCommand commandSector = conexionBD.obtenerComando(query2);
                using (SqlDataReader reader = commandSector.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        Sectores.Add(reader.GetString(0));
                    }
                }
                conexionBD.cerrar();

                // Obtener Estados de Cotización
                conexionBD.abrir();
                string query3 = "SELECT nombre FROM EstadoCotizacion";
                SqlCommand commandEstado = conexionBD.obtenerComando(query3);
                using (SqlDataReader reader = commandEstado.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        EstadosCotizacion.Add(reader.GetString(0));
                    }
                }
                conexionBD.cerrar();

                // Obtener Tipos de Cotización
                conexionBD.abrir();
                string query4 = "SELECT nombre FROM TipoCotizacion";
                SqlCommand commandTipo = conexionBD.obtenerComando(query4);
                using (SqlDataReader reader = commandTipo.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        TiposCotizacion.Add(reader.GetString(0));
                    }
                }
                conexionBD.cerrar();

                // Obtener Empleados
                conexionBD.abrir();
                string query5 = "SELECT cedula FROM Empleado";
                SqlCommand commandEmpleado = conexionBD.obtenerComando(query5);
                using (SqlDataReader reader = commandEmpleado.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        Empleados.Add(reader.GetInt32(0).ToString());
                    }
                }
                conexionBD.cerrar();

                // Obtener Clientes
                conexionBD.abrir();
                string query6 = "SELECT cedula_juridica FROM Cliente";
                SqlCommand commandCliente = conexionBD.obtenerComando(query6);
                using (SqlDataReader reader = commandCliente.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        Clientes.Add(reader.GetInt32(0).ToString());
                    }
                }
                conexionBD.cerrar();
            }
            catch (Exception ex) {
                Console.WriteLine($"SQL Server Error: {ex.Message}");
            }
            finally
            {
                conexionBD.cerrar(); // Cerramos la conexión
            }
        }

        public void OnPost()
        {
            Cotizacion.num_cotizacion = Request.Form["num_cotizacion"];
            Cotizacion.orden_compra = Request.Form["orden_compra"];
            Cotizacion.tipo = Request.Form["tipo"];
            Cotizacion.descripcion = Request.Form["descripcion"];
            Cotizacion.zona = Request.Form["zona"];
            Cotizacion.sector = Request.Form["sector"];
            Cotizacion.estado = Request.Form["estado"];
            Cotizacion.monto_total = Request.Form["monto_total"];
            Cotizacion.mes_cierre = Request.Form["mes_cierre"];
            Cotizacion.cedula_vendedor = Request.Form["empleado"];
            Cotizacion.fecha_inicio = Request.Form["fecha_inicio"];
            Cotizacion.fecha_cierre = Request.Form["fecha_cierre"];
            Cotizacion.probabilidad = Request.Form["probabilidad"];
            Cotizacion.razon_negacion = Request.Form["razon_negacion"];
            Cotizacion.cedula_cliente = Request.Form["cliente"];

            try
            {
                conexionBD.abrir();
                string query = "ModificarCotizacion";
                SqlCommand command = conexionBD.obtenerComando(query);
                command.CommandType = CommandType.StoredProcedure;

                // Parámetro de error de salida
                SqlParameter errorParameter = new SqlParameter("@ErrorMsg", SqlDbType.NVarChar, 255)
                {
                    Direction = ParameterDirection.Output
                };

                // Agregar parámetros al procedimiento almacenado
                command.Parameters.AddWithValue("@num_cotizacion", Cotizacion.num_cotizacion);
                command.Parameters.AddWithValue("@orden_compra", Cotizacion.orden_compra);
                command.Parameters.AddWithValue("@tipo", Cotizacion.tipo);
                command.Parameters.AddWithValue("@descripcion", Cotizacion.descripcion);
                command.Parameters.AddWithValue("@zona", Cotizacion.zona);
                command.Parameters.AddWithValue("@sector", Cotizacion.sector);
                command.Parameters.AddWithValue("@estado", Cotizacion.estado);
                command.Parameters.AddWithValue("@monto_total", Cotizacion.monto_total);
                command.Parameters.AddWithValue("@mes_cierre", Cotizacion.mes_cierre);
                command.Parameters.AddWithValue("@cedula_vendedor", Cotizacion.cedula_vendedor);
                command.Parameters.AddWithValue("@fecha_inicio", Cotizacion.fecha_inicio);
                command.Parameters.AddWithValue("@fecha_cierre", Cotizacion.fecha_cierre);
                command.Parameters.AddWithValue("@probabilidad", Cotizacion.probabilidad);
                command.Parameters.AddWithValue("@razon_negacion", Cotizacion.razon_negacion);
                command.Parameters.AddWithValue("@cedula_cliente", Cotizacion.cedula_cliente);
                command.Parameters.Add(errorParameter);

                // Ejecutar el procedimiento almacenado
                command.ExecuteNonQuery();

                // Capturar el mensaje de error, si existe
                string errorMsg = (string)command.Parameters["@ErrorMsg"].Value;

                if (string.IsNullOrEmpty(errorMsg))
                {
                    mensaje_exito = "Cotización registrada exitosamente.";
                }
                else
                {
                    mensaje_error = $"Error al registrar la cotización: {errorMsg}";
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
    }
}
