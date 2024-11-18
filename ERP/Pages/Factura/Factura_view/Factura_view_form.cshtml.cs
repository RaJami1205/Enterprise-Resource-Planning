using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;
using System.Data;

namespace ERP.Pages.Factura.Factura_view
{
    public class Factura_formModel : PageModel
    {
        public FacturaInfo Factura { get; set; } = new FacturaInfo();
        public List<string> EstadosFactura { get; set; } = new List<string>();
        public List<string> Clientes { get; set; } = new List<string>();
        public List<string> Empleados { get; set; } = new List<string>();
        public List<string> Bodegas { get; set; } = new List<string>();

        public List<string> Cotizaciones { get; set; } = new List<string>();
        public string mensaje_error = "";
        public string mensaje_exito = "";
        public Conexion conexionBD = new Conexion();

        public void OnGet()
        {
            try
            {
                // Obtener los estados de factura
                conexionBD.abrir();
                string queryEstado = "SELECT nombre FROM EstadoFactura";
                SqlCommand commandEstado = conexionBD.obtenerComando(queryEstado);
                using (SqlDataReader reader = commandEstado.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        EstadosFactura.Add(reader.GetString(0));
                    }
                }
                conexionBD.cerrar();

                // Obtener empleados
                conexionBD.abrir();
                string queryEmpleado = "SELECT cedula FROM Empleado";
                SqlCommand commandEmpleado = conexionBD.obtenerComando(queryEmpleado);
                using (SqlDataReader reader = commandEmpleado.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        Empleados.Add(reader.GetInt32(0).ToString());
                    }
                }
                conexionBD.cerrar();

                // Obtener clientes
                conexionBD.abrir();
                string queryCliente = "SELECT cedula_juridica FROM Cliente";
                SqlCommand commandCliente = conexionBD.obtenerComando(queryCliente);
                using (SqlDataReader reader = commandCliente.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        Clientes.Add(reader.GetInt32(0).ToString());
                    }
                }
                conexionBD.cerrar();

                conexionBD.abrir();
                string queryCot = "SELECT num_cotizacion FROM Cotizacion";
                SqlCommand commandCot = conexionBD.obtenerComando(queryCot);
                using (SqlDataReader reader = commandCot.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        Cotizaciones.Add(reader.GetInt32(0).ToString());
                    }
                }
                conexionBD.cerrar();

                conexionBD.abrir();
                string queryBod = "SELECT codigo_bodega FROM Bodega";
                SqlCommand commandBod = conexionBD.obtenerComando(queryBod);
                using (SqlDataReader reader = commandBod.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        Bodegas.Add(reader.GetInt32(0).ToString());
                    }
                }
                mensaje_exito = "Cotización registrada exitosamente.";

                conexionBD.cerrar();
            }
            catch (Exception ex)
            {
                mensaje_error = $"Error al registrar la factura";
                conexionBD.cerrar();
            }
        }

        public void OnPost()
        {
            Factura.num_facturacion = Request.Form["num_facturacion"];
            Factura.telefono_local = Request.Form["telefono_local"];
            Factura.nombre_local = Request.Form["nombre_local"];
            Factura.fecha = Request.Form["fecha"];
            Factura.estado = Request.Form["estado"];
            Factura.cedula_vendedor = Request.Form["cedula_vendedor"];
            Factura.cedula_juridica = Request.Form["cedula_juridica"];
            Factura.num_cotizacion = Request.Form["num_cotizacion"];
            Factura.bodega = Request.Form["bodega"];

            try
            {
                conexionBD.abrir();



                // Insertar Factura
                string queryFactura = "InsertarFactura";
                SqlCommand commandFactura = conexionBD.obtenerComando(queryFactura);
                commandFactura.CommandType = CommandType.StoredProcedure;

                // Parámetro de error de salida para factura
                SqlParameter facturaErrorParameter = new SqlParameter("@ErrorMsg", SqlDbType.NVarChar, 255) { Direction = ParameterDirection.Output };

                // Parámetros para insertar factura
                commandFactura.Parameters.AddWithValue("@num_facturacion", Factura.num_facturacion);
                commandFactura.Parameters.AddWithValue("@telefono_local", Factura.telefono_local);
                commandFactura.Parameters.AddWithValue("@cedula_juridica", Factura.cedula_juridica);
                commandFactura.Parameters.AddWithValue("@nombre_local", Factura.nombre_local);
                commandFactura.Parameters.AddWithValue("@fecha", Factura.fecha);
                commandFactura.Parameters.AddWithValue("@estado", Factura.estado);
                commandFactura.Parameters.AddWithValue("@cedula_vendedor", Factura.cedula_vendedor);
                commandFactura.Parameters.AddWithValue("@num_cotizacion", string.IsNullOrEmpty(Factura.num_cotizacion) ? (object)DBNull.Value : Factura.num_cotizacion);
                commandFactura.Parameters.Add(facturaErrorParameter);

                // Ejecutar procedimiento de inserción de factura
                commandFactura.ExecuteNonQuery();
                string facturaErrorMsg = (string)commandFactura.Parameters["@ErrorMsg"].Value;

                // Insertar Salida asociada
                string querySalida = "InsertarSalida";
                SqlCommand commandSalida = conexionBD.obtenerComando(querySalida);
                commandSalida.CommandType = CommandType.StoredProcedure;

                // Parámetro de error de salida para salida
                SqlParameter salidaErrorParameter = new SqlParameter("@ErrorMsg", SqlDbType.NVarChar, 255) { Direction = ParameterDirection.Output };

                // Parámetros para insertar salida
                commandSalida.Parameters.AddWithValue("@cedula_vendedor", Factura.cedula_vendedor);
                commandSalida.Parameters.AddWithValue("@codigo_bodega", Factura.bodega);
                commandSalida.Parameters.AddWithValue("@factura", Factura.num_facturacion);
                commandSalida.Parameters.Add(salidaErrorParameter);

                // Ejecutar procedimiento de inserción de salida
                commandSalida.ExecuteNonQuery();
                string salidaErrorMsg = (string)commandSalida.Parameters["@ErrorMsg"].Value;

                if (string.IsNullOrEmpty(salidaErrorMsg))
                {
                    mensaje_exito = "Factura y salida registradas exitosamente.";
                }
                else
                {
                    mensaje_error = $"Factura registrada, pero ocurrió un error al registrar la salida: {salidaErrorMsg}";
                }

                conexionBD.cerrar();
            }
            catch (Exception ex)
            {
                mensaje_error = ex.Message;
                conexionBD.cerrar();
            }
        }

    }
}

