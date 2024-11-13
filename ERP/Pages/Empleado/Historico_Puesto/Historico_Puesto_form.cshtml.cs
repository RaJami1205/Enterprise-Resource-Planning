using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;
using System.Data;

namespace ERP.Pages.Empleado.Historico_Puesto
{
    public class Historico_Puesto_formModel : PageModel
    {
        public HistoricoPuestoInfo HistoricoPuesto { get; set; } = new HistoricoPuestoInfo(); // Lista que guarda toda la informaci�n de los requests
        public Conexion conexionBD = new Conexion(); // Instancia de la clase Conexion para manejar la conexi�n a la base de datos
        public List<string> listaEmpleados { get; set; } = new List<string>();
        public List<string> listaPuestos { get; set; } = new List<string>();
        public List<string> listaDepartamentos { get; set; } = new List<string>();
        public string mensaje_error = ""; // Variable para almacenar mensajes de error
        public string mensaje_exito = ""; // Variable para almacenar mensajes de �xito

        /// <summary>
        /// M�todo que se ejecuta cuando se ingresa al formulario (GET request).
        /// Objetivo: Extraer los datos de los ID de puesto y departamento y manejar errores.
        /// Entradas: Ninguna.
        /// Salidas: Mensaje de �xito o mensaje de error.
        /// </summary>
        public void OnGet()
        {
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
            string sqlPuesto = "SELECT puesto FROM Puesto";
            SqlCommand command_puesto = conexionBD.obtenerComando(sqlPuesto);
            using (SqlDataReader reader = command_puesto.ExecuteReader())
            {
                while (reader.Read())
                {
                    listaPuestos.Add("" + reader.GetString(0));
                }
            }
            conexionBD.cerrar();

            conexionBD.abrir();
            string sqlDepartamento = "SELECT nombre FROM Departamento";
            SqlCommand command_Departamento = conexionBD.obtenerComando(sqlDepartamento);
            using (SqlDataReader reader = command_Departamento.ExecuteReader())
            {
                while (reader.Read())
                {
                    listaDepartamentos.Add("" + reader.GetString(0));
                }
            }
            conexionBD.cerrar();
        }

        /// <summary>
        /// M�todo que se ejecuta cuando se env�a el formulario (POST request).
        /// Objetivo: Recibir los datos del formulario de Hist�ricos de salarios, insertarlos en la base de datos y manejar errores.
        /// Entradas: Datos del formulario (HistoricoPuesto_id, fecha_inicio, fecha_cierre, monto, cedula, puesto y departamento).
        /// Salidas: Mensaje de �xito o mensaje de error.
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
                string sqlHistoricoPuesto = "InsertarHistoricoPuesto";
                SqlCommand command = conexionBD.obtenerComando(sqlHistoricoPuesto);
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
                HistoricoPuesto.id = "";
                HistoricoPuesto.cedula = "";
                HistoricoPuesto.fecha_inicio = "";
                HistoricoPuesto.fecha_final = "";
                HistoricoPuesto.puesto = "";
                HistoricoPuesto.departamento = "";

                mensaje_exito = "Hist�rico registrado exitosamente";
            }
            catch (Exception ex)
            {
                mensaje_error = ex.Message;
                conexionBD.cerrar();
                OnGet();
            }
        }

        // Clase que representa el modelo de vista para la lista de hist�ricos de salarios
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