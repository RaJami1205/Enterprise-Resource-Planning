﻿using System.Data.SqlClient;

namespace ERP.Pages
{
    public class Conexion
    {
        string cadena = "Data source=" + Environment.MachineName + "; Initial Catalog=ERP; Integrated Security=True";


        public SqlConnection ConectarBD = new SqlConnection();

        public Conexion()
        {
            ConectarBD.ConnectionString = cadena;

        }

        public void abrir()
        {
            try
            {
                ConectarBD.Open();
                Console.WriteLine("Conexion abierta");
            }
            catch (Exception ex)
            {
                Console.WriteLine("ERROR: No se pudo abrir la BD " + ex.Message);
            }
        }

        public void cerrar()
        {
            ConectarBD.Close();
        }

        public SqlCommand obtenerComando(string sql)
        {
            SqlCommand command = new SqlCommand(sql, ConectarBD);
            return command;
        }
    }
}