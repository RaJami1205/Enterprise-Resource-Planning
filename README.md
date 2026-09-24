# Enterprise Resource Planning (ERP) - Sistema de Gestión Empresarial 🏢📊

Este repositorio contiene el **Proyecto de Bases de Datos I**, un sistema web enfocado en la simulación y gestión de los recursos operativos de una empresa (ERP). El proyecto abarca desde el modelado relacional de los datos hasta la interfaz de usuario, integrando lógica de negocio transaccional mediante tecnologías de Microsoft.

El software centraliza módulos críticos como facturación, control de registros y gestión de datos generales, garantizando la consistencia y persistencia de la información en un entorno empresarial simulado.

---

## 🛠️ Stack Tecnológico

*   **Backend & Frontend:** .NET (ASP.NET Core / C#) desarrollado en Visual Studio 2022.
*   **Base de Datos:** SQL Server (Transact-SQL).
*   **Diseño de Datos:** Modelado Entidad-Relación (DER), normalización y diseño lógico de bases de datos transaccionales.

---

## 🏗️ Características y Arquitectura de Datos

El núcleo del proyecto se enfoca en resolver los desafíos de un entorno transaccional clásico, asegurando la integridad referencial y la escalabilidad del sistema:

1. **Modelado y Diseño de Base de Datos:** Creación de esquemas relacionales normalizados en SQL Server para mitigar la redundancia de datos.
2. **Lógica Transaccional:** Implementación de scripts estructurados para la manipulación segura de datos (inserciones, actualizaciones y consultas complejas).
3. **Conexión de Capas:** Integración nativa entre el backend desarrollado en C# (.NET) y el motor de SQL Server para el mapeo y persistencia de las entidades de negocio.

---

## 📁 Estructura del Repositorio

El proyecto mantiene una separación limpia entre los scripts de infraestructura de datos y la aplicación transaccional:

*   **`Scripts/`**: Directorio dedicado al almacenamiento de los archivos `.sql`. Incluye scripts de creación de tablas, definición de llaves primarias/foráneas, restricciones de integridad, y cargas masivas de prueba (como `Insertserp.sql`).
*   **`ERP/`**: Solución web principal desarrollada en .NET.
    *   `Program.cs`: Punto de entrada de la aplicación y configuración de los servicios del sistema.
    *   `Pages/`: Vistas y controladores encargados de renderizar la interfaz de usuario y capturar los flujos del sistema (Facturación, Inventario, Reportes).
    *   `appsettings.json`: Configuración de las variables de entorno y cadenas de conexión (*Connection Strings*) hacia la instancia de SQL Server.
*   **`ERP.sln`**: Archivo de solución global para la orquestación del proyecto en Visual Studio 2022.

---

## 🚀 Requisitos para la Ejecución

### Prerrequisitos
*   **Visual Studio 2022** con la carga de trabajo de desarrollo web y ASP.NET activa.
*   **SQL Server Management Studio (SSMS)** o una instancia local activa de SQL Server.
*   **SDK de .NET** compatible con la versión del proyecto.
