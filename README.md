# PROYECTO-FIS-PICKUP
repositorio final del proyecto de fundamentos de ingeneria software - TESE Pickup

## Estructura

| Carpeta | Contenido |
|---|---|
| `backend/` | API en Node.js (Lambda + serverless-offline) |
| `database/` | Esquema de PostgreSQL (`schema.sql`) |
| `web-admin/` | Panel web de cafetería (Flutter) |
| `mobile/` | App móvil del estudiante (Flutter) |
| `qa/` | Plan y casos de prueba |
| `docs/` | Documentación |

## Requisitos

- Git
- Node.js 20 o superior
- PostgreSQL (usuario `postgres`, contraseña `postgres`, puerto 5432)
- Flutter en `C:\flutter\bin` y Google Chrome

## Cómo arrancar

Desde la carpeta del proyecto, en PowerShell:

```
.\iniciar.bat
```

La primera vez crea la base de datos. Para borrarla y crearla de nuevo:

```
.\iniciar.bat nuevo
```

Se abren dos ventanas (backend y panel web) que no se deben cerrar.

- API: http://localhost:3000
- Panel web: se abre solo en Chrome

## Cuentas de prueba

| Correo | Contraseña | Rol |
|---|---|---|
| `cocina.grande@tese.edu.mx` | `123456` | Cafetería |
| `carlos@tese.edu.mx` | `123456` | Estudiante |
