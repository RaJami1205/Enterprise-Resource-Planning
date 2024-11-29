using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;
using System.Data;

namespace ERP.Pages.Factura.FacturaArticulo
{
    public class FacturaArticuloFormModel : PageModel
    {
        public FacturaArticuloInfo FacturaArticulo { get; set; } = new FacturaArticuloInfo();
        public List<int> NumerosFactura { get; set; } = new List<int>();
        public List<int> CodigosArticulo { get; set; } = new List<int>();

        public string mensaje_error = "";
        public string mensaje_exito = "";

        public Conexion conexionBD = new Conexion();

        public void OnGet()
        {
            try
            {
                // Obtener números de factura
                conexionBD.abrir();
                string queryFacturas = "SELECT num_facturacion FROM Factura";
                SqlCommand commandFactura = conexionBD.obtenerComando(queryFacturas);
                using (SqlDataReader reader = commandFactura.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        NumerosFactura.Add(reader.GetInt32(0));
                    }
                }
                conexionBD.cerrar();

                // Obtener códigos de artículo
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

        public void OnPost()
        {
            FacturaArticulo.num_factura = Request.Form["num_factura"];
            FacturaArticulo.codigo_articulo = Request.Form["codigo_articulo"];
            FacturaArticulo.cantidad = Request.Form["cantidad"];
            FacturaArticulo.monto = Request.Form["monto"];

            try
            {
                conexionBD.abrir();
                string query = "InsertarArticuloFactura"; // Procedimiento almacenado para insertar artículo en factura
                SqlCommand command = conexionBD.obtenerComando(query);
                command.CommandType = CommandType.StoredProcedure;

                // Parámetro de error para capturar posibles errores
                SqlParameter errorParameter = new SqlParameter("@ErrorMsg", SqlDbType.VarChar, 255)
                {
                    Direction = ParameterDirection.Output
                };

                // Agregar parámetros al procedimiento almacenado
                command.Parameters.AddWithValue("@num_factura", FacturaArticulo.num_factura);
                command.Parameters.AddWithValue("@codigo_articulo", FacturaArticulo.codigo_articulo);
                command.Parameters.AddWithValue("@cantidad", FacturaArticulo.cantidad);
                command.Parameters.AddWithValue("@monto", FacturaArticulo.monto);
                command.Parameters.Add(errorParameter);

                command.ExecuteNonQuery();

                string errorMsg = (string)command.Parameters["@ErrorMsg"].Value;

                mensaje_exito = "Artículo agregado a la factura exitosamente.";

                conexionBD.cerrar();
            }
            catch (Exception ex)
            {
                mensaje_error = ex.Message;
                conexionBD.cerrar();
            }

            OnGet();
        }

        // Clase para representar los datos del artículo de factura
        public class FacturaArticuloInfo
        {
            public string num_factura { get; set; }
            public string codigo_articulo { get; set; }
            public string cantidad { get; set; }
            public string monto { get; set; }
        }
    }
}
