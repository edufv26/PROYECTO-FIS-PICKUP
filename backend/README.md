# Backend AWS - Core & Auth (Dev D)

API hecha con funciones Lambda en Node.js y API Gateway, corriendo en local con `serverless-offline`.
Usa la base de datos PostgreSQL de Dev E (`database/schema.sql`).

Todo el sistema corre en **una sola computadora** que funciona como servidor y como cliente:

```
             COMPUTADORA SERVIDOR
 ┌──────────────────────────────────────────┐
 │  PostgreSQL (puerto 5432)                 │
 │        ▲                                  │
 │  API Lambda / API Gateway (puerto 3000)   │
 │        ▲                ▲                 │
 │  Panel web (Chrome)  Emulador Android     │
 └──────────────────────────────────────────┘
            ▲
   Celulares en la misma red WiFi (opcional)
```

## Requisitos de la computadora servidor

- Node.js 20 o superior
- PostgreSQL con usuario `postgres` y contraseña `postgres`

Si la contraseña de PostgreSQL es otra, cámbiala en `src/db.js`.

## 1. Instalar

```bash
cd backend
npm install
```

## 2. Crear la base de datos

```bash
npm run crear-bd
```

Crea la base `tese_pickup` y ejecuta en orden:

1. `../database/schema.sql` (Dev E)
2. `database/cambios_backend.sql`
3. `database/datos_prueba.sql`

Ojo: si la base ya existe la borra y la crea de nuevo.

## 3. Dar de alta al personal de cafetería

Los estudiantes se registran solos con su correo `@tese.edu.mx`.
El personal de cafetería se da de alta a mano:

```bash
npm run alta-cafeteria -- "Doña Mary" mary@cafeteria.com mary123 CAF_GRANDE
```

Cafeterías: `CAF_GRANDE`, `CAF_CHICA_1`, `CAF_CHICA_2`.

## 4. Arrancar la API

```bash
npm start
```

Debe aparecer `Server ready: http://0.0.0.0:3000`.

## URL que debe usar cada cliente

| Cliente | URL |
|---|---|
| Panel web (Dev C) en Chrome, en la misma computadora | `http://localhost:3000` |
| App móvil (Dev B) en el emulador de Android | `http://10.0.2.2:3000` |
| Celular físico conectado al mismo WiFi | `http://IP_DE_LA_COMPUTADORA:3000` |

Para saber la IP de la computadora: `ipconfig` en Windows (dato "Dirección IPv4").
Si un celular no se conecta, hay que permitir el puerto 3000 en el Firewall de Windows.

## Endpoints

| Método | Ruta | Quién | Body |
|---|---|---|---|
| POST | `/auth/registro` | Estudiante | `{ nombre, correo, matricula, password }` |
| POST | `/auth/login` | Todos | `{ correo, password }` |
| GET | `/auth/perfil` | Con token | - |
| GET | `/cafeterias/{id}/menu` | Todos | - |
| POST | `/cafeterias/{id}/menu` | Cafetería | `{ id, nombre, categoria, precio, disponible }` |
| GET | `/cafeterias/{id}/pedidos` | Cafetería | - |
| PATCH | `/cafeterias/{id}/pedidos/{pid}/estado` | Cafetería | `{ estado }` |

El login regresa un `token`. Las rutas protegidas lo necesitan en el encabezado:

```
Authorization: Bearer <token>
```

El token dura 8 horas. Estados de pedido: `PENDIENTE`, `EN_PREPARACION`, `LISTO`, `ENTREGADO`.

## Cambios a la base de datos de Dev E

`database/cambios_backend.sql` se corre después de `schema.sql` y agrega:

- Tabla `cafeterias`
- En `usuarios`: columnas `rol` (`estudiante` o `cafeteria`) e `id_cafeteria`; `matricula` ya no es obligatoria (el personal no tiene)
- En `productos`: columna `id_cafeteria`
- Tablas `pedidos` y `detalle_pedido`
