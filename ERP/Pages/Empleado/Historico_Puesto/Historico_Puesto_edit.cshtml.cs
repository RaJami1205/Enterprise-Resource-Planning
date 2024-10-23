using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;
using System.Data;

namespace ERP.Pages.Empleado.Historico_Puesto
{
    public class Historico_Puesto_editModel : PageModel
    {
        public HistoricoPuestoInfo HistoricoPuesto { get; set; } = new HistoricoPuestoInfo(); // Lista que guarda toda la información de los requests
        public Conexion conexionBD = new Conexion(); // Instancia de la clase Conexion para manejar la conexión a la base de datos
        public List<string> listaEmpleados { get; set; } = new List<string>();
        public List<string> listaPuestos { get; set; } = new List<string>();
        public List<string> listaDepartamentos { get; set; } = new List<string>();
        public string mensaje_error = ""; // Variable para almacenar mensajes de error
        public string mensaje_exito = ""; // Variable para almacenar mensajes de éxito

        /// <summary>
        /// Método que se ejecuta cuando se ingresa al formulario (GET request).
        /// Objetivo: Extraer los datos de los ID de puesto y departamento y manejar errores. Además extrae las cedulas de los empleados y los ID de los departamentos y los puestos
        /// Entradas: Ninguna.
        /// Salidas: Mensaje de éxito o mensaje de error.
        /// </summary>
        public void OnGet()
        {
            string ID_hp = Request.Query["id"];

            try
            {
                conexionBD.abrir();
                String sql = "SELECT HistoricoPuesto_id, puesto, fecha_inicio, fecha_fin, departamento, cedula_empleado FROM HistoricoPuesto WHERE HistoricoPuesto_id = @ID_hp";
                SqlCommand command = conexionBD.obtenerComando(sql);
                command.Parameters.AddWithValue("@ID_hp", ID_hp);
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        HistoricoPuesto.id = reader.GetInt32(0).ToString();
                        HistoricoPuesto.puesto = reader.GetInt32(1).ToString();
                        HistoricoPuesto.fecha_inicio = reader.GetDateTime(2).ToString("yyyy-MM-dd");
                        HistoricoPuesto.fecha_final = reader.GetDateTime(3).ToString("yyyy-MM-dd");
                        HistoricoPuesto.departamento = reader.GetInt32(4).ToString();
                        HistoricoPuesto.cedula = reader.GetInt32(5).ToString();
                    }
                }
                conexionBD.cerrar();
            }
            catch (Exception ex)
            {
                mensaje_error = ex.Message;
                conexionBD.cerrar();
            }

            conexionBD.abrir();
            string sqlCedula = "SELECT cedula FROM Empleado";
            SqlCommand command_cedula = conexionBD.obtenerComando(sqlCedula);
            using (SqlDataReader reader = command_cedula.ExecuteReader())
            {
                while (reader.Read())
                {
                    listaEmpleados.Add("" + reader.GetInt32(0));
                }
            }
            conexionBD.cerrar();

            conexionBD.abrir();
            string sqlPuesto = "SELECT puesto_id FROM Puesto";
            SqlCommand command_puesto = conexionBD.obtenerComando(sqlPuesto);
            using (SqlDataReader reader = command_puesto.ExecuteReader())
            {
                while (reader.Read())
                {
                    listaPuestos.Add("" + reader.GetInt32(0));
                }
            }
            conexionBD.cerrar();

            conexionBD.abrir();
            string sqlDepartamento = "SELECT departamento_id FROM Departamento";
            SqlCommand command_Departamento = conexionBD.obtenerComando(sqlDepartamento);
            using (SqlDataReader reader = command_Departamento.ExecuteReader())
            {
                while (reader.Read())
                {
                    listaDepartamentos.Add("" + reader.GetInt32(0));
                }
            }
            conexionBD.cerrar();
        }

        /// <summary>
        /// Método que se ejecuta cuando se envía el formulario (POST request).
        /// Objetivo: Recibir los datos del formulario de Históricos de puestos, insertarlos en la base de datos y manejar errores.
        /// Entradas: Datos del formulario (HistoricoPuesto_id, fecha_inicio, fecha_cierre, cedula, puesto y departamento).
        /// Salidas: Mensaje de éxito o mensaje de error.
        /// Restricciones: Todos los campos deben estar debidamente validados antes de enviarse.
        /// </summary>
        public void OnPost()
        {
            HistoricoPuesto.id = Request.Form["id"];
            HistoricoPuesto.fecha_inicio = Request.Form["fecha_inicio"];
            HistoricoPuesto.fecha_final = Request.Form["fecha_final"];
            HistoricoPuesto.cedula = Request.Form["cedula"];
            HistoricoPuesto.puesto = Request.Form["puesto"];
            HistoricoPuesto.departamento = Request.Form["departamento"];

            try
            {
                conexionBD.abrir();
                string sqlHistoricoSalario = "ModificarHistoricoPuesto";
                SqlCommand command = conexionBD.obtenerComando(sqlHistoricoSalario);
                command.CommandType = System.Data.CommandType.StoredProcedure;
                SqlParameter errorParameter = new SqlParameter("@ErrorMsg", SqlDbType.VarChar, 255)
                {
                    Direction = ParameterDirection.Output
                };

                command.Parameters.AddWithValue("@id", HistoricoPuesto.id);
                command.Parameters.AddWithValue("@puesto", HistoricoPuesto.puesto);
                command.Parameters.AddWithValue("@fecha_inicio", HistoricoPuesto.fecha_inicio);
                command.Parameters.AddWithValue("@fecha_fin", HistoricoPuesto.fecha_final);
                command.Parameters.AddWithValue("@departamento", HistoricoPuesto.departamento);
                command.Parameters.AddWithValue("@cedula_empleado", HistoricoPuesto.cedula);
                command.Parameters.Add(errorParameter);

                command.ExecuteNonQuery();
                string ErrorMesage = (string)command.Parameters["@ErrorMsg"].Value;

                conexionBD.cerrar();

                // Limpieza del formulario
                HistoricoPuesto.cedula = "";
                HistoricoPuesto.fecha_inicio = "";
                HistoricoPuesto.fecha_final = "";
                HistoricoPuesto.puesto = "";
                HistoricoPuesto.departamento = "";

                mensaje_exito = "Histórico modificado exitosamente";
            }
            catch (Exception ex)
            {
                mensaje_error = ex.Message;
                conexionBD.cerrar();
                OnGet();
            }
        }

        // Clase que representa el modelo de vista para la lista de históricos de salarios
        public class HistoricoPuestoInfo
        {
            public string id { get; set; }
            public string fecha_inicio { get; set; }
            public string fecha_final { get; set; }
            public string cedula { get; set; }
            public string puesto { get; set; }
            public string departamento { get; set; }
        }
    }
}