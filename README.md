<<<<<<< HEAD
# Integradora App

Aplicación móvil (Flutter) + backend (Node.js/Express) que conecta contratistas y trabajadores, permite registrar trabajos de largo plazo, administrar favoritos, compartir ubicación e intercambiar información de contacto.

---

## Arquitectura general

| Capa | Tecnología | Responsabilidad |
|------|------------|-----------------|
| **Frontend móvil** | Flutter 3.8 (Dart) | UI, navegación, captura de imágenes, permisos, geolocalización, consumo de APIs REST. |
| **Backend REST** | Node.js 20 + Express 5 | Autenticación JWT, registro de usuarios, gestión de trabajos, favoritos, coordinación de ubicaciones. |
| **Base de datos** | PostgreSQL | Persistencia de usuarios, trabajos, favoritos y ubicaciones. |

El patrón usado en la app móvil es **MVC**: vistas (`lib/views`), controladores/servicios (`lib/services`) y modelos (`lib/models`).

---

## Dependencias destacadas

### Flutter
- **flutter_speed_dial**: botón flotante con múltiples acciones.
- **image_picker**: abre cámara/galería y devuelve la foto para convertirla a Base64.
- **permission_handler**: gestiona permisos (cámara, galería, ubicación).
- **geolocator**: obtiene coordenadas GPS del dispositivo.
- **http**: realiza peticiones REST al backend.
- **shared_preferences**: almacena sesión/JWT y datos sencillos.
- **intl**: formatea fechas y textos.
- **firebase_core / firebase_messaging / firebase_database**: base para integrar notificaciones o datos en tiempo real (configurados, listos para usar).

### Backend Node.js
- **express**: servidor HTTP principal.
- **pg**: cliente oficial de PostgreSQL.
- **bcrypt**: hashing de contraseñas.
- **jsonwebtoken**: generación y verificación de JWT.
- **cors**: habilita llamadas desde la app Flutter.
- **dotenv**: carga variables de entorno desde `.env`.

---

## Características implementadas

### Autenticación y usuarios
- Registro de contratistas y trabajadores (`/api/register/*`) con contraseñas encriptadas (`bcrypt`).
- Login por email o username (`/api/auth/login`) emitiendo JWT.
- Sesión persistida en Flutter usando `shared_preferences`.

### Perfil y multimedia
- Carga de foto de perfil desde cámara/galería con `image_picker`.
- Conversión de las imágenes a **Base64** para enviarlas al backend y almacenarlas como texto.
- Permisos de cámara/galería controlados por `permission_handler`.

### Geolocalización
- Captura de coordenadas con `geolocator`.
- Endpoints para guardar ubicación del usuario (`PUT /api/ubicacion/contratista` y `/trabajador`).
- Consultas de trabajadores cercanos usando la fórmula de Haversine en PostgreSQL.

### Trabajos de largo plazo
- Modelo `TrabajoLargoModel` que representa un trabajo (título, descripción, coordenadas, fechas, frecuencia de trabajo, vacantes, etc.).
- Formulario en `HomeViewContractor` que usa el modelo y registra vía `POST /api/trabajos-largo-plazo/registrar`.
- Listados de trabajos del contratista (`GET /contratista`) y trabajos cercanos para el trabajador (`GET /cercanos`).
- Home del trabajador muestra uno por categoría y ofrece botón **Ver más** para cargar todos desde la API.
- Modal de detalles (`ModalTrabajoLargo`) con descripción, contratista, fechas formateadas (`intl`), frecuencia y vacantes.

### Favoritos
- Endpoints `/api/favoritos` para agregar/quitar/ver favoritos.
- Corazón en el perfil del trabajador (en el modal) que guarda/quita usando `CustomNotification` para feedback visual.

### Almacenamiento y scripts SQL
- Tabla `trabajos_largo_plazo` (sin campo de pago, solo frecuencia) con `latitud/longitud/direccion`, fechas y estados.
- Scripts ejecutables:
  - `scripts/recreate_trabajos_largo_plazo.sql`: crea la tabla actualizada.
  - `scripts/update_trabajos_largo_plazo.sql`: agrega columnas y elimina `pago_semanal` si venías de versiones previas.
  - `scripts/add_geolocalizacion.sql`, `add_foto_column.sql`, etc. para ampliar tablas existentes.

---

## Estructura resumida del proyecto

```
integradora/
├── lib/
│   ├── models/
│   │   └── trabajo_largo_model.dart
│   ├── services/
│   │   └── api_service.dart (y otros servicios)
│   └── views/
│       ├── screens/...
│       └── widgets/...
├── backend/
│   ├── controllers/
│   │   ├── trabajosLargoPlazoController.js
│   │   ├── registerController.js
│   │   └── ubicacionController.js
│   ├── routes/
│   │   └── trabajosLargoPlazoRoutes.js
│   ├── scripts/
│   │   └── recreate_trabajos_largo_plazo.sql (entre otros)
│   └── server.js
└── README.md
```

---

## Cómo correr el proyecto

### Backend
1. Instala dependencias:
   ```bash
   cd backend
   npm install
   ```
2. Configura `.env` con tus credenciales de PostgreSQL (DB_HOST, DB_USER, DB_PASS, DB_NAME, JWT_SECRET, etc.).
3. Ejecuta los scripts SQL necesarios (ej. `recreate_trabajos_largo_plazo.sql`).
4. Ejecuta el servidor:
   ```bash
   npm start
   ```

### App Flutter
1. Instala dependencias:
   ```bash
   flutter pub get
   ```
2. Ajusta `lib/services/config_service.dart` si necesitas cambiar la URL base del backend.
3. Corre la app con:
   ```bash
   flutter run
   ```

---

## Próximos pasos sugeridos
- Integrar registro y carga de trabajos de corto plazo (con fotos y precios). 
- Agregar acción “Contactar por WhatsApp” al confirmar contratación.
- Modelar el estado de trabajadores en trabajos (tabla de contratos con estados `pendiente/en curso/completado`).
- Generar diagrama de arquitectura completo una vez estén esos módulos.

---

## Créditos
Proyecto desarrollado como parte de la materia de integración, combinando Flutter + Node.js + PostgreSQL.
<<<<<<< HEAD
# OBIX
=======
# integradora
=======
# Integradora – Documentación Técnica
>>>>>>> feature/App-Terminada

Este README resume la arquitectura, componentes clave y decisiones de diseño del proyecto Integradora. Está pensado como guía de estudio para responder preguntas técnicas, justificar la estructura actual y planear futuras versiones.

---

## Panorama General

- **Arquitectura cliente-servidor:** Flutter (cliente) consume una API REST Node.js/Express (servidor). Esta separación permite desplegar cada capa por separado y escalar servicios sin recompilar la app.
- **Comunicación:** HTTP + JSON sobre rutas `/api/*`. El frontend centraliza las peticiones en `lib/services/api_service.dart`.
- **Autenticación:** JWT emitido por el backend; se guarda en `shared_preferences` para adjuntarlo en cada petición.
- **Base de datos:** PostgreSQL. La estructura está normalizada hasta 4FN para evitar duplicidad y mantener la consistencia a largo plazo. Los scripts viven en `backend/scripts/`.

---

## Frontend (Flutter)

- **Estructura:**  
  - `lib/views/` pantallas y widgets.  
  - `lib/models/` mapea el JSON del backend (`TrabajoLargoModel`, `TrabajoCortoModel`, `AsignacionTrabajoModel`, etc.).  
  - `lib/services/` consumo de API, almacenamiento local y utilidades.
- **Funcionalidades destacadas:**  
  - Registro y visualización de trabajos corto/largo plazo.  
  - Geolocalización con `geolocator` y apertura de Google Maps.  
  - Captura de imágenes con `image_picker` (Base64).  
  - Manejo de notificaciones push con Firebase Messaging.
- **Patrón:** MVC por módulos; cada pantalla obtiene datos mediante servicios y los presenta con widgets reutilizables.

---

## Backend (Node.js/Express)

- **Entrada principal:** `backend/server.js` monta middlewares (CORS, JSON 50 MB) y registra rutas por dominio.
- **Rutas y controladores:**  
  - `routes/*.js` → `controllers/*.js`. Por ejemplo `asignacionesRoutes` delega en `asignacionesController`.  
  - Uso intensivo de transacciones (`BEGIN/COMMIT/ROLLBACK`) para mantener la integridad en asignaciones, cancelaciones y calificaciones.
- **Servicios auxiliares:**  
  - `services/notificationService.js`: creación y envío de notificaciones.  
  - `services/firebaseService.js`: wrapper de Firebase Admin para FCM.  
  - `services/solicitudesService.js`, `utils/emailUtils.js`, etc.

---

## Base de Datos

> El diagrama entidad-relación (ver imagen adjunta en `docs/diagrama-er.png`) muestra las tablas actuales. Falta únicamente la futura tabla de horas premium.

- **Tablas principales:**  
  - `trabajadores`, `contratistas`: datos personales, ubicación, calificación promedio.  
  - `solicitudes_trabajo`: historial de solicitudes con estados (`pendiente`, `aceptada`, `rechazada`, `expirada`, `cancelada`).  
  - `trabajos_largo_plazo`, `trabajos_corto_plazo`, `trabajos_corto_plazo_imagenes`: ofertas de trabajo según duración.  
  - `asignaciones_trabajo`: vincula contratista ↔ trabajador ↔ trabajo, con control de estado y fechas.  
  - `calificaciones_trabajadores`: reseñas posteriores a cada asignación.  
  - `notificaciones_usuario`: histórico de notificaciones creadas.  
  - `dispositivos_notificaciones`: tokens FCM por usuario y tipo.  
  - `favoritos`, `categorias`: soporte para catálogos y relaciones auxiliares.
- **Normalización:**  
  - No existen atributos multivaluados; por ejemplo, imágenes de trabajos cortos en tabla separada.  
  - Dependencias funcionales mantenidas por claves foráneas (`email_trabajador`, `id_trabajo_largo`, etc.).  
  - Los atributos derivados (ej. `calificacion_promedio`) se actualizan con triggers controlados desde el backend para evitar redundancias sincrónicas.  
  - Preparado para 4FN: en tablas como `dispositivos_notificaciones` se separan cada token/plataforma para un email, evitando grupos repetidos.
- **Próxima versión:** se añadirá `horas_trabajadas` (para usuarios premium) relacionada con `asignaciones_trabajo`. La normalización facilita incluir esta tabla sin romper integridad.

---

## Flujo de Notificaciones Push

1. **Registro de dispositivos**  
   - `notificationService.registrarTokenDispositivo` guarda token FCM, email y tipo de usuario en `dispositivos_notificaciones`.  
   - Se ejecuta desde el frontend al iniciar sesión.

2. **Creación de notificaciones**  
   - `notificationService.crearNotificacion` inserta en `notificaciones_usuario` el título, cuerpo, tipo y payload JSON.  
   - Se reutiliza en todos los caso de uso (cancelaciones, calificaciones, etc.).

3. **Envío push**  
   - `sendPushNotification` (Firebase Admin) toma los tokens del destinatario y envía el mensaje con los datos extra (`data`) para que la app abra la vista correspondiente.

4. **Casos específicos**  
   - **Cancelación iniciada por trabajador:**  
     - `asignacionesController.cancelarAsignacion` detecta `iniciadoPorTrabajador`, crea notificación `solicitud_cancelada` para el contratista y envía push.  
   - **Cancelación iniciada por contratista:**  
     - Misma función, rama `else`, genera notificación `desvinculacion` para el trabajador.  
   - **Registro de calificación:**  
     - `calificacionesController.registrarCalificacion` calcula el nuevo promedio, actualiza `trabajadores.calificacion_promedio` y llama `notificarCalificacionTrabajador`, que emite la notificación `calificacion_trabajador`.

---

## Integración Frontend ↔ Backend

- El frontend encapsula las llamadas al backend en `ApiService`, lo que facilita cambiar la URL base o añadir headers sin tocar cada pantalla.
- Cada controlador retorna JSON consistente (`{ success, data, message }`), permitiendo manejo homogéneo de errores.
- Para ambientes:  
  - Desarrollo local usa IP configurable documentada en `CONFIGURACION_IP_AUTOMATICA.md`.  
  - Producción puede apuntar a Render u otra nube simplemente cambiando la URL base.

---

## Flujos Clave

- **Publicar trabajo (contratista):** formulario → `ApiService` → `trabajos*Corto/Largo*Controller` → inserción en BD → respuesta con detalles.  
- **Contratar trabajador:** pantalla `WorkerCard` → `ApiService.asignarTrabajo` → transacción que inserta en `asignaciones_trabajo`, ajusta vacantes y disponibilidad → posible notificación al trabajador.  
- **Cancelar asignación:** `ApiService.cancelarAsignacion` → rollback de vacantes y disponibilidad → creación de notificación y push según quién cancele.  
- **Calificar trabajador:** formulario en la notificación → `calificacionesController.registrarCalificacion` → inserción + recomputo de promedio + notificación al trabajador.

---

## Preparación para Futuras Versiones

- **Horas premium:** se añadirá tabla `horas_trabajadas` (id, id_asignacion, fecha, horas, comentarios). Al estar la asignación y el trabajador separados, basta con una FK a `asignaciones_trabajo`.
- **Escalabilidad:** servicios desacoplados (notificaciones, email) se pueden migrar a colas o microservicios sin reescribir la lógica central.
- **Testing y documentación:** recomendable agregar pruebas de integración para asignaciones y calificaciones, y documentación OpenAPI para facilitar nuevos clientes.

---

## Comandos Útiles

```bash
# Backend
cd backend
npm install
npm run dev     # servidor Express con nodemon

# Base de datos
# Ejecutar scripts en orden según README de scripts (ej. create_tables.sql, create_asignaciones_tables.sql, etc.)

# Frontend Flutter
flutter pub get
flutter run     # emulador o dispositivo conectado
```

Configura las variables de entorno (`.env`) con credenciales de PostgreSQL, claves JWT y parámetros de Firebase (`firebase-service-account.json`).

---

## Recursos de Estudio

- Repasa los controladores `asignacionesController.js` y `calificacionesController.js` para explicar los escenarios de negocio.  
- Consulta `backend/scripts/*.sql` junto con el diagrama ER para justificar la normalización y relaciones.  
- Desde Flutter, sigue el flujo `home_view.dart` → `worker_card.dart` → `assign_modal_work.dart` para explicar la experiencia del contratista.  
- Practica demostraciones manuales: publicar trabajo, asignar, cancelar y calificar para corroborar las notificaciones en ambos roles.

---

Con esta documentación podrás defender la arquitectura, argumentar la normalización de la base de datos y explicar cómo se integran notificaciones, seguridad y flujos principales. Para futuras ampliaciones (como la tabla de horas premium) la estructura actual ya contempla las relaciones necesarias.
