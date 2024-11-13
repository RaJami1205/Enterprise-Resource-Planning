using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;
using System.Data;

namespace ERP.Pages.Empleado.Historico_Salario
{
    public class Historico_Salario_editModel : PageModel
    {
        public HistoricoSalarioInfo HistoricoSalario { get; set; } = new HistoricoSalarioInfo(); // Lista que guarda toda la informaci�n de los requests
        public Conexion conexionBD = new Conexion(); // Instancia de la clase Conexion para manejar la conexi�n a la base de datos
        public List<string> listaEmpleados { get; set; } = new List<string>();
        public List<string> listaPuestos { get; set; } = new List<string>();
        public List<string> listaDepartamentos { get; set; } = new List<string>();
        public string mensaje_error = ""; // Variable para almacenar mensajes de error
        public string mensaje_exito = ""; // Variable para almacenar mensajes de �xito

        /// <summary>
        /// M�todo que se ejecuta cuando se ingresa al formulario (GET request).
        /// Objetivo: Extraer los datos de los ID de puesto y departamento y manejar errores. Adem�s extrae las cedulas de los empleados y los ID de los departamentos y los puestos
        /// Entradas: Ninguna.
        /// Salidas: Mensaje de �xito o mensaje de error.
        /// </summary>
        public void OnGet()
        {
            string ID_hs = Request.Query["id"];

            try
            {
                conexionBD.abrir();
                String sql = "SELECT HistoricoSalario_id, puesto, fecha_inicio, fecha_fin, departamento, monto, cedula_empleado FROM HistoricoSalario WHERE HistoricoSalario_id = @ID_hs";
                SqlCommand command = conexionBD.obtenerComando(sql);
                command.Parameters.AddWithValue("@ID_hs", ID_hs);
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        HistoricoSalario.id = reader.GetInt32(0).ToString();
                        HistoricoSalario.puesto = reader.GetInt32(1).ToString();
                        HistoricoSalario.fecha_inicio = reader.GetDateTime(2).ToString("yyyy-MM-dd");
                        HistoricoSalario.fecha_final = reader.GetDateTime(3).ToString("yyyy-MM-dd");
                        HistoricoSalario.departamento = reader.GetInt32(4).ToString();
                        HistoricoSalario.monto = reader.GetDouble(5).ToString();
                        HistoricoSalario.cedula = reader.GetInt32(6).ToString();
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
        /// M�todo que se ejecuta cuando se env�a el formulario (POST request).
        /// Objetivo: Recibir los datos del formulario de Hist�ricos de salarios, insertarlos en la base de datos y manejar errores.
        /// Entradas: Datos del formulario (HistoricoSalario_id, fecha_inicio, fecha_cierre, monto, cedula, puesto y departamento).
        /// Salidas: Mensaje de �xito o mensaje de error.
        /// Restricciones: Todos los campos deben estar debidamente validados antes de enviarse.
        /// </summary>
        public void OnPost()
        {
            HistoricoSalario.id = Request.Form["id"];
            HistoricoSalario.fecha_inicio = Request.Form["fecha_inicio"];
            HistoricoSalario.fecha_final = Request.Form["fecha_final"];
            HistoricoSalario.monto = Request.Form["monto"];
            HistoricoSalario.cedula = Request.Form["cedula"];
            HistoricoSalario.puesto = Request.Form["puesto"];
            HistoricoSalario.departamento = Request.Form["departamento"];

            try
            {
                conexionBD.abrir();
                string sqlHistoricoSalario = "ModificarHistoricoSalario";
                SqlCommand command = conexionBD.obtenerComando(sqlHistoricoSalario);
                command.CommandType = System.Data.CommandType.StoredProcedure;
                SqlParameter errorParameter = new SqlParameter("@ErrorMsg", SqlDbType.VarChar, 255)
                {
                    Direction = ParameterDirection.Output
                };

                command.Parameters.AddWithValue("@id", HistoricoSalario.id);
                command.Parameters.AddWithValue("@puesto", HistoricoSalario.puesto);
                command.Parameters.AddWithValue("@fecha_inicio", HistoricoSalario.fecha_inicio);
                command.Parameters.AddWithValue("@fecha_fin", HistoricoSalario.fecha_final);
                command.Parameters.AddWithValue("@departamento", HistoricoSalario.departamento);
                command.Parameters.AddWithValue("@monto", HistoricoSalario.monto);
                command.Parameters.AddWithValue("@cedula_empleado", HistoricoSalario.cedula);
                command.Parameters.Add(errorParameter);

                command.ExecuteNonQuery();
                string ErrorMesage = (string)command.Parameters["@ErrorMsg"].Value;

                conexionBD.cerrar();

                // Limpieza del formulario
                HistoricoSalario.cedula = "";
                HistoricoSalario.fecha_inicio = "";
                HistoricoSalario.fecha_final = "";
                HistoricoSalario.monto = "";
                HistoricoSalario.puesto = "";
                HistoricoSalario.departamento = "";

                mensaje_exito = "Hist�rico modificado exitosamente";
            }
            catch (Exception ex)
            {
                mensaje_error = ex.Message;
                conexionBD.cerrar();
                OnGet();
            }
        }

        // Clase que representa el modelo de vista para la lista de hist�ricos de salarios
        public class HistoricoSalarioInfo
        {
            public string id { get; set; }
            public string fecha_inicio { get; set; }
            public string fecha_final { get; set; }
            public string monto { get; set; }
            public string cedula { get; set; }
            public string puesto { get; set; }
            public string departamento { get; set; }
        }
    }
}