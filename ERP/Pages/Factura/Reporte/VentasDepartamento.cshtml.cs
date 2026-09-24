using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;
using System.Collections.Generic;
using System;

namespace ERP.Pages.Factura.Reporte
{
    public class VentasDepartamentoModel : PageModel
    {
        public List<VentaPorDepartamento> VentasData { get; set; } = new List<VentaPorDepartamento>();
        public string mensajeError = "";
        public DateTime FechaInicio { get; set; }
        public DateTime FechaFin { get; set; }
        public double TotalCantidad { get; set; } // Nueva propiedad para almacenar el monto total

        public void OnPost()
        {
            if (DateTime.TryParse(Request.Form["FechaInicio"], out DateTime fechaInicio) &&
                DateTime.TryParse(Request.Form["FechaFin"], out DateTime fechaFin))
            {
                FechaInicio = fechaInicio;
                FechaFin = fechaFin;

                Conexion conexionBD = new Conexion();
                try
                {
                    conexionBD.abrir();

                    // Obtener Ventas por Departamento
                    string query = "SELECT Departamento, CantidadTotal FROM ObtenerVentasPorDepartamentoPorcentual(@FechaInicio, @FechaFin)";
                    SqlCommand command = conexionBD.obtenerComando(query);
                    command.Parameters.AddWithValue("@FechaInicio", FechaInicio);
                    command.Parameters.AddWithValue("@FechaFin", FechaFin);

                    SqlDataReader reader = command.ExecuteReader();
                    while (reader.Read())
                    {
                        VentasData.Add(new VentaPorDepartamento
                        {
                            Departamento = reader.GetString(0),
                            cantidadTotal = (double) reader.GetInt32(1)
                        });
                    }
                    reader.Close();

                    // Calcular el total de los montos
                    TotalCantidad = VentasData.Sum(v => v.cantidadTotal);
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
            else
            {
                mensajeError = "Fechas no válidas.";
            }
        }

        public class VentaPorDepartamento
        {
            public string Departamento { get; set; }
            public double cantidadTotal { get; set; }
        }
    }
}
