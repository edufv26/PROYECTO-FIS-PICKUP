import http from 'k6/http';
import { check, sleep } from 'k6';

// Configuración del escenario de carga para el TESE (Picos de Receso)
export const options = {
  stages: [
    { duration: '30s', target: 50 },   // Subida gradual a 50 usuarios simultáneos
    { duration: '1m',  target: 300 },  // Pico masivo de receso: 300 usuarios concurrentes
    { duration: '30s', target: 500 },  // Prueba de estrés máxima: 500 usuarios
    { duration: '30s', target: 0 },    // Bajada y cierre de conexiones
  ],
  thresholds: {
    http_req_duration: ['p(95)<2000'], // El 95% de las peticiones debe responder en < 2 segundos (RNF01)
    http_req_failed: ['rate<0.01'],    // Tasa de error inferior al 1%
  },
};

// URL base configurada para la API en AWS API Gateway
const BASE_URL = 'https://api.tese-pickup.com/v1';

export default function () {
  const headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer TOKEN_JWT_DE_PRUEBA',
  };

  // 1. Simulación: Consultar menú dinámico de cafeterías (RF02)
  const resMenu = http.get(`${BASE_URL}/productos?cafeteria_id=1`, { headers });
  check(resMenu, {
    'Consulta de menú exitosa (200)': (r) => r.status === 200,
    'Tiempo de respuesta en menú < 1000ms': (r) => r.timings.duration < 1000,
  });

  sleep(1); // El estudiante revisa el menú por 1 segundo

  // 2. Simulación: Creación de pedido tipo Pickup (RF03)
  const payloadPedido = JSON.stringify({
    cafeteria_id: 1,
    productos: [
      { id_producto: 10, cantidad: 1, notas: 'Sin cebolla' }
    ],
    hora_pickup: '11:15:00',
    metodo_pago: 'monedero_tese'
  });

  const resPedido = http.post(`${BASE_URL}/pedidos`, payloadPedido, { headers });
  check(resPedido, {
    'Pedido creado exitosamente (201)': (r) => r.status === 201,
    'Código QR generado correctamente': (r) => r.json('codigo_qr_hash') !== undefined,
  });

  sleep(2); // Tiempo entre iteraciones por usuario virtual
}
