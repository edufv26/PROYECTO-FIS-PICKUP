# 🍽️ TESE-Eats | Web Admin Cafeterías (Dev C)

Plataforma web administrativa desarrollada en **Flutter Web** para la gestión en tiempo real de las 3 cafeterías del Tecnológico de Estudios Superiores de Ecatepec (Cafetería Principal Grande, Cafetería Pequeña 1 y Cafetería Pequeña 2).

## 🚀 Funcionalidades Principales

1. **Autenticación por Sucursal (`LoginScreen`):**
   - Acceso diferenciado para el personal administrativo de cada una de las 3 cafeterías (`CAF_GRANDE`, `CAF_CHICA_1`, `CAF_CHICA_2`).
2. **Monitor de Cola de Pedidos - Kanban (`_KanbanView`):**
   - Tablero en tiempo real organizado cronológicamente para evitar cuellos de botella en horas pico.
   - Flujo de estados: `PENDIENTE` ➔ `EN_PREPARACION` ➔ `LISTO` ➔ `ENTREGADO`.
   - Indicador visual de tiempo de espera (alerta en rojo tras 10 minutos).
3. **Gestión de Inventario y Menú (`_MenuManagementView`):**
   - Alta y edición de platillos del día mediante modales interactivos.
   - Barra de búsqueda en tiempo real y filtrado dinámico por categorías (`ChoiceChip`).
4. **Sincronización Instantánea vía WebSockets (`CafeteriaProvider`):**
   - Interruptor **"Agotado / Disponible"** que emite eventos inmediatos por WebSocket para ocultar platillos al instante en la aplicación móvil de los estudiantes.

---

## 🧱 Arquitectura del Módulo (`lib/`)

El proyecto sigue una arquitectura limpia separada por responsabilidades con el patrón `Provider`:

```text
web-admin/lib/
├── models/
│   ├── pedido.dart            # Modelo de datos y serialización JSON de órdenes y enum EstadoPedido
│   └── platillo.dart          # Modelo de datos y serialización JSON del menú
├── providers/
│   ├── auth_provider.dart     # Manejo de sesión activa e identificador de sucursal
│   └── cafeteria_provider.dart# Estado global del Kanban, menú y canal WebSocket
├── screens/
│   ├── login_screen.dart      # Interfaz de acceso institucional
│   └── dashboard_screen.dart  # Layout principal con NavigationRail, Kanban y Menú
├── services/
│   └── aws_api_service.dart   # Cliente HTTP REST para consumo de endpoints en AWS API Gateway
├── widgets/
│   ├── pedido_card.dart       # Componente modular de tarjeta para columnas Kanban
│   └── platillo_tile.dart     # Componente modular de fila de inventario con switch WS
└── main.dart                  # Inyección de dependencias (MultiProvider) y configuración de tema
