using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data.SqlClient;
using static ERP.Pages.Cliente.Cliente_view.Cliente_view_formModel;

namespace ERP.Pages.Cliente.Cliente_view
{
    public class Cliente_view_listModel : PageModel
    {
        public List<ClienteInfo> listaClientes = new List<ClienteInfo>();
        public Conexion conexionBD = new Conexion();

        public void OnGet()
        {
            try
            {
                conexionBD.abrir();
                String sql = "SELECT cedula, nombre, zona, sector FROM Cliente";
                SqlCommand command = conexionBD.obtenerComando(sql);
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        ClienteInfo cliente = new ClienteInfo();
                        cliente.cedula = "" + reader.GetInt32(0);
                        cliente.nombre = "" + reader.GetString(1);
                        cliente.zona = "" + reader.GetString(2);
                        cliente.sector = "" + reader.GetString(3);
 
                        listaClientes.Add(cliente);
                    }
                }
                conexionBD.cerrar();
            }
            catch (Exception ex)
            {
                // Aquí se maneja el error
                Console.WriteLine("Error: " + ex.Message);
                conexionBD.cerrar();
            }
        }

        public class ClienteInfo
        {
            public string cedula { get; set; }
            public string nombre { get; set; }
            public string apellido1 { get; set; }
            public string apellido2 { get; set; }
            public string correo { get; set; }
            public string telefono { get; set; }
            public string celular { get; set; }
            public string fax { get; set; }
            public string zona { get; set; }
            public string sector { get; set; }
        }
    }
}
