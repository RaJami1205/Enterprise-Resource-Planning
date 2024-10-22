using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;
using System.Data;

namespace ERP.Pages.Cotizacion.Cotizacion_view
{
    public class Cotizacion_view_formModel : PageModel
    {
        public CotizacionInfo Cotizacion { get; set; } = new CotizacionInfo();
        public List<string> Zonas { get; set; } = new List<string>();
        public List<string> Sectores { get; set; } = new List<string>();
        public List<string> EstadosCotizacion { get; set; } = new List<string>();
        public List<string> TiposCotizacion { get; set; } = new List<string>();
        public List<int> Clientes { get; set; } = new List<int>();
        public List<int> Empleados { get; set; } = new List<int>();

        public string mensaje_error = "";
        public string mensaje_exito = "";

        public Conexion conexionBD = new Conexion(); // Instancia para la conexión a la base de datos

        /// <summary>
        /// Método que se ejecuta cuando se accede a la página (GET request).
        /// Objetivo: Cargar las listas de Zonas, Sectores, Estados de Cotización y Tipos de Cotización.
        /// </summary>
        public void OnGet()
        {
            try
            {
                // Obtener Zonas
                conexionBD.abrir();
                string query = "SELECT nombre FROM Zona";
                SqlCommand commandZona = conexionBD.obtenerComando(query);
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
                string query1 = "SELECT nombre FROM Sector";
                SqlCommand commandSector = conexionBD.obtenerComando(query1);
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
                string query2 = "SELECT nombre FROM EstadoCotizacion";
                SqlCommand commandEstado = conexionBD.obtenerComando(query2);
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
                string query3 = "SELECT nombre FROM TipoCotizacion";
                SqlCommand commandTipo = conexionBD.obtenerComando(query3);
                using (SqlDataReader reader = commandTipo.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        TiposCotizacion.Add(reader.GetString(0));
                    }
                }
                conexionBD.cerrar();

                conexionBD.abrir();
                string query4 = "SELECT cedula FROM Empleado";
                SqlCommand commandEmpleado = conexionBD.obtenerComando(query4);
                using (SqlDataReader reader = commandEmpleado.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        Empleados.Add(reader.GetInt32(0));
                    }
                }
                conexionBD.cerrar();

                conexionBD.abrir();
                string query5 = "SELECT cedula_juridica FROM Cliente";
                SqlCommand commandCliente = conexionBD.obtenerComando(query5);
                using (SqlDataReader reader = commandCliente.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        Clientes.Add(reader.GetInt32(0));
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
        /// Objetivo: Registrar una nueva cotización utilizando un procedimiento almacenado.
        /// </summary>
        public void OnPost()
        {
            Cotizacion.num_cotizacion = Request.Form["num_cotizacion"];
            Cotizacion.orden_compra = Request.Form["orden_compra"];
            Cotizacion.descripcion = Request.Form["descripcion"];
            Cotizacion.monto_total = Request.Form["monto_total"];
            Cotizacion.mes_cierre = Request.Form["mes_cierre"];
            Cotizacion.probabilidad = Request.Form["probabilidad"];
            Cotizacion.cedula_vendedor = Request.Form["empleado"];
            Cotizacion.cedula_cliente = Request.Form["cliente"];
            Cotizacion.zona = Request.Form["zona"];
            Cotizacion.sector = Request.Form["sector"];
            Cotizacion.estado = Request.Form["estado"];
            Cotizacion.tipo = Request.Form["tipo"];

            try
            {
                conexionBD.abrir();
                string query = "InsertarCotizacion";
                SqlCommand command = conexionBD.obtenerComando(query);
                command.CommandType = CommandType.StoredProcedure;

                // Declarar parámetro de error para capturar un posible mensaje de error
                SqlParameter errorParameter = new SqlParameter("@ErrorMsg", SqlDbType.VarChar, 255)
                {
                    Direction = ParameterDirection.Output
                };

                // Agregar parámetros al procedimiento almacenado
                command.Parameters.AddWithValue("@num_cotizacion", Cotizacion.num_cotizacion);
                command.Parameters.AddWithValue("@orden_compra", Cotizacion.orden_compra);
                command.Parameters.AddWithValue("@descripcion", Cotizacion.descripcion);
                command.Parameters.AddWithValue("@monto_total", Cotizacion.monto_total);
                command.Parameters.AddWithValue("@mes_cierre", Cotizacion.mes_cierre);
                command.Parameters.AddWithValue("@probabilidad", Cotizacion.probabilidad);
                command.Parameters.AddWithValue("@cedula_vendedor", Cotizacion.cedula_vendedor);
                command.Parameters.AddWithValue("@cedula_cliente", Cotizacion.cedula_cliente);
                command.Parameters.AddWithValue("@zona", Cotizacion.zona);
                command.Parameters.AddWithValue("@sector", Cotizacion.sector);
                command.Parameters.AddWithValue("@estado", Cotizacion.estado);
                command.Parameters.AddWithValue("@tipo", Cotizacion.tipo);
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

    // Clase que representa la estructura de la cotización
    public class CotizacionInfo
    {
        public string num_cotizacion { get; set; }
        public string orden_compra { get; set; }
        public string descripcion { get; set; }
        public string monto_total { get; set; }
        public string mes_cierre { get; set; }
        public string probabilidad { get; set; }
        public string cedula_vendedor { get; set; }
        public string cedula_cliente { get; set; }
        public string zona { get; set; }
        public string sector { get; set; }
        public string estado { get; set; }
        public string tipo { get; set; }
    }
}