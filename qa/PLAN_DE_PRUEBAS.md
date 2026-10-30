# Plan de Pruebas y Aseguramiento de Calidad (QA)
**Proyecto:** Aplicación Comida para las Cafeterías del TESE (Modelo Pickup)  
**Rol Encargado:** Dev G (Ingeniero QA & Pruebas Multiplataforma)  
**Versión:** 1.0.0  

---

## 1. Introducción y Objetivo
El presente documento establece la estrategia formal de aseguramiento de calidad y pruebas de software para el sistema Pickup del TESE. El objetivo principal es garantizar que la aplicación móvil (Flutter), la plataforma web del personal de cocina (KDS) y la infraestructura backend en la nube (AWS Serverless) cumplan con los requisitos funcionales (`RF01-RF08`) y no funcionales (`RNF01-RNF04`), asegurando alta disponibilidad y sincronización en tiempo real durante las horas pico de receso escolar.

---

## 2. Alcance de las Pruebas

### 2.1 Componentes Incluidos en el Alcance
* **Aplicación Móvil Cliente (Android / iOS - Flutter):** Flujos de autenticación institucional, exploración de menú, personalización de platillos, selección de slots de recolección, pasarela de pagos y visualización de código QR.
* **Plataforma Web KDS (Flutter Web):** Recepción de comandas en tiempo real, cambio de estados de pedidos en 1 tap, deshabilitación instantánea de insumos agotados y escáner de códigos QR de entrega.
* **Backend y Middleware (AWS Serverless):** Validación de endpoints en API Gateway, funciones AWS Lambda, persistencia en Amazon DynamoDB, almacenamiento en caché con ElastiCache (Redis) y canales bidireccionales por WebSockets.

### 2.2 Componentes Fuera del Alcance
* Mantenimiento físico de hardware (tablets de cafetería o servidores locales).
* Procesamiento interno de redes bancarias externas fuera de la pasarela de pagos integrados.

---

## 3. Tipos y Niveles de Pruebas

| Tipo de Prueba | Objetivo | Herramientas / Entorno |
| :--- | :--- | :--- |
| **Pruebas Funcionales (E2E)** | Validar que los flujos completos de usuario (desde el inicio de sesión hasta la recolección en barra) se ejecuten sin errores de lógica. | Flutter Integration Test, Emuladores Android/iOS, Chrome DevTools |
| **Pruebas de Tiempo Real (WebSockets)** | Verificar que la actualización del menú y cambio de estados de pedidos ocurra en $< 1$ segundo en todos los clientes conectados. | AWS API Gateway WebSocket Execution Logs, Postman (WebSocket collection) |
| **Pruebas de Carga y Concurrencia** | Simular picos masivos de demanda (300 a 500 solicitudes simultáneas) en los recesos del TESE para medir tiempos de respuesta y autoescalado. | k6 / Apache JMeter |
| **Pruebas de Interfaz y Usabilidad (UI/UX)** | Confirmar el enfoque *Mobile-First*, responsividad en pantallas táctiles de cocina y tiempos de flujo de orden en $< 3$ minutos. | Figma / Pruebas exploratorias en dispositivos físicos |
| **Pruebas de Seguridad** | Validar la restricción de dominios no institucionales (`@tese.edu.mx`) y la integridad del hash cifrado en los códigos QR. | OWASP ZAP, Postman Auth Testing |

---

## 4. Entornos de Prueba

* **Entorno de Desarrollo (Dev):** Emuladores locales de Flutter y servicios AWS en sandbox.
* **Entorno de Pruebas (Staging / QA):** Compilaciones APK e IPA distribuidas a través de Firebase App Distribution / TestFlight y despliegue web en URL de pruebas de AWS CloudFront.

---

## 5. Criterios de Aceptación y Cierre de QA (Definition of Done)

Para considerar que un incremento o módulo está listo para producción, debe cumplir con:
1. **0 Errores Críticos (Bloqueantes):** Sin fallas que impidan completar una orden o autenticarse.
2. **Latencia de WebSockets:** Tiempos de propagación de cambio de inventario $\le 1000$ ms.
3. **Tiempo de Flujo de Compra:** Finalización de pedido en la app cliente en máximo 4 clics / 3 minutos.
4. **Tasa de Éxito de Carga:** $99.5\%$ de peticiones exitosas bajo simulación de 300 usuarios simultáneos.
