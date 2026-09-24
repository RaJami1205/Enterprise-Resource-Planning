using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;
using System.Collections.Generic;
using System;

namespace ERP.Pages.Planilla.ReportesPlanilla
{
    public class ReporteDepartamentoMesModel : PageModel
    {
        public List<DepartamentoMonto> DepartamentoMontoData { get; set; } = new List<DepartamentoMonto>();
        public string mensajeError = "";
        public string Mes { get; set; }
        public string Anno { get; set; }

        public void OnPost()
        {
            Mes = Request.Form["Mes"];
            Anno = Request.Form["Anno"];

            Conexion conexionBD = new Conexion();
            try
            {
                conexionBD.abrir();
                string query = "SELECT Departamento, MontoTotal FROM ObtenerMontosPorDepartamentoMes(@Mes, @Anno)";
                SqlCommand command = conexionBD.obtenerComando(query);
                command.Parameters.AddWithValue("@Mes", Mes);
                command.Parameters.AddWithValue("@Anno", Anno);

                SqlDataReader reader = command.ExecuteReader();
                while (reader.Read())
                {
                    DepartamentoMontoData.Add(new DepartamentoMonto
                    {
                        Departamento = reader.GetString(0),
                        MontoTotal = reader.GetDouble(1)
                    });
                }
            }
            catch (Exception ex)
            {
                mensajeError = ex.Message;
            }
            finally
            {
                conexionBD.cerrar();
            }
        }

        public class DepartamentoMonto
        {
            public string Departamento { get; set; }
            public double MontoTotal { get; set; }
        }
    }
}
