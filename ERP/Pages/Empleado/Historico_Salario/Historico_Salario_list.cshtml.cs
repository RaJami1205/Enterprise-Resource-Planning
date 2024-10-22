using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace ERP.Pages.Empleado.Historico_Salario
{
    public class Historico_Salario_listModel : PageModel
    {
        public List<HistoricoSalarioInfo> listaHistoricoSalarios = new List<HistoricoSalarioInfo>(); // Lista que almacena los datos de los Empleados
        public Conexion conexionBD = new Conexion(); // Instancia de la clase Conexion para manejar la conexi�n a la base de datos

        /// <summary>
        /// M�todo que se ejecuta cuando se accede a la p�gina (GET request).
        /// Objetivo: Recuperar la lista de historicos de salarios desde la base de datos y lo almacena en la listaHistoricoSalarios.
        /// Salidas: Una lis|ta de objetos HistoricoSalarioInfo que contienen informaci�n b�sica de los hist�ricos de salarios.
        /// Restricciones: En caso de error, el programa manejar� la excepci�n, cerrando la conexi�n y mostrando un mensaje.
        /// </summary>
        public void OnGet()
        {
        }

        // Clase que representa el modelo de vista para la lista de empleados
        public class HistoricoSalarioInfo
        {
            public string nombre { get; set; }
            public string apellido1 { get; set; }
            public string apellido2 { get; set; }
            public string puesto { get; set; }
            public string departamento { get; set; }
            public string monto { get; set; }
            public string fecha_inicio { get; set; }
            public string fecha_final { get; set; }
        }
    }
}
