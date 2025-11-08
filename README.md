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

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
>>>>>>> 58c9d6f (Interfaces terminadas: login, register contratista y trabajador, home trabajador, home contratista, trabajos activos trabajador)
