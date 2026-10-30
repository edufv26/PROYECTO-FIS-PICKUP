# Matriz de Casos de Prueba (QA)
**Proyecto:** Aplicación Comida para las Cafeterías del TESE (Modelo Pickup)  
**Módulo:** Cobertura de Requisitos Funcionales (`RF01-RF08`) y No Funcionales (`RNF01-RNF04`)  
**Responsable:** Dev G (Ingeniero QA)  

---

## 1. Casos de Prueba Funcionales (Móvil / Web / Backend)

| ID Caso | Módulo / Requisito | Descripción del Escenario | Precondiciones | Pasos de Ejecución | Resultado Esperado | Estatus |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **TC-01** | `RF01` Auth | Validación de dominio institucional | App cliente iniciada | 1. Ingresar correo no institucional (`@gmail.com`).<br>2. Intentar registrar/loguear. | El sistema rechaza el acceso solicitando un correo `@tese.edu.mx`. | `Pendiente` |
| **TC-02** | `RF01` Auth | Inicio de sesión exitoso con SSO | Cuenta institucional activa | 1. Ingresar credenciales institucionales válidas.<br>2. Presionar "Ingresar". | Acceso concedido y redirección a la pantalla principal según el rol (Estudiante/Cocina). | `Pendiente` |
| **TC-03** | `HU-F02` / `RF06` KDS | Deshabilitar platillo agotado en 1 Tap | Usuario cocina en la plataforma Web KDS | 1. Identificar platillo sin insumos.<br>2. Presionar el botón "Agotado" en la interfaz. | El estado cambia a "No disponible" en el backend (AWS Lambda) en $< 1$ segundo. | `Pendiente` |
| **TC-04** | `RF02` / WebSockets | Sincronización en tiempo real de menú | App móvil abierta en catálogo | 1. Cocina deshabilita platillo desde el KDS.<br>2. Observar pantalla móvil sin recargar. | El producto se inhabilita en la app cliente inmediatamente vía WebSockets. | `Pendiente` |
| **TC-05** | `RF03` Pickup | Selección y reserva de slot de recolección | Carrito de compra con productos | 1. Seleccionar cafetería.<br>2. Elegir horario de entrega interclase. | El sistema asigna la ventana de tiempo si la capacidad máxima del slot no ha sido superada. | `Pendiente` |
| **TC-06** | `RF03` / `RF08` | Generación y escaneo de Código QR | Pedido confirmado y pagado | 1. Abrir ticket digital en la app.<br>2. Escanear QR desde el dispositivo de cocina. | El KDS valida el hash cifrado y cambia el estado del pedido a "Entregado". | `Pendiente` |

---

## 2. Casos de Prueba No Funcionales (Rendimiento, Carga y Seguridad)

| ID Caso | Requisito No Funcional | Tipo de Prueba | Criterio de Aceptación / Métricas Target | Herramienta | Estatus |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **TC-NF01** | `RNF01` Rendimiento | Prueba de Carga Masiva (Horas Pico) | Simulación de 300 a 500 solicitudes simultáneas en periodos de 15 min. Tiempos de respuesta $< 2000$ ms en el $95\%$ de peticiones. | k6 / Apache JMeter | `Pendiente` |
| **TC-NF02** | `RNF02` Usabilidad | Tiempo de Flujo de Compra | Un usuario completa la orden (*Catálogo $\rightarrow$ Selección de Slot $\rightarrow$ Confirmación*) en menos de 3 minutos / 4 clics. | Pruebas de campo UI/UX | `Pendiente` |
| **TC-NF03** | `RNF03` Disponibilidad | Resiliencia Serverless en AWS | Mantener disponibilidad del $99.5\%$ ante caídas simuladas de instancias o picos repentinos con autoescalado. | AWS CloudWatch Logs | `Pendiente` |
| **TC-NF04** | `RNF04` Seguridad | Encriptación y Protección de Datos | Tráfico $100\%$ cifrado bajo HTTPS/TLS 1.3 y tokens JWT expirables para sesiones de usuario. | OWASP ZAP / Postman | `Pendiente` |
