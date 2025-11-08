import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import { testConnection } from './config/db.js';
import registerRoutes from './routes/registerRoutes.js';
import categoriaRoutes from './routes/categoriaRoutes.js';
import loginRoutes from './routes/loginRoutes.js';
import ubicacionRoutes from './routes/ubicacionRoutes.js';
import favoritosRoutes from './routes/favoritosRoutes.js';
import trabajosLargoPlazoRoutes from './routes/trabajosLargoPlazoRoutes.js';
import trabajosCortoPlazoRoutes from './routes/trabajosCortoPlazoRoutes.js';

// Cargar variables de entorno
dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middlewares
app.use(cors({
  origin: '*', // Permitir todos los orígenes (en producción usar un origen específico)
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'Accept'],
  credentials: true,
}));
// Aumentar el límite de tamaño del body para permitir imágenes en Base64
app.use(express.json({ limit: '50mb' }));
app.use(express.urlencoded({ extended: true, limit: '50mb' }));

// Middleware para logging de peticiones
app.use((req, res, next) => {
  console.log(`📥 ${req.method} ${req.path} - ${new Date().toLocaleTimeString()}`);
  next();
});

// Ruta de prueba para verificar que el servidor está funcionando
app.get('/', (req, res) => {
  res.json({
    message: 'Servidor backend funcionando correctamente',
    database: process.env.DB_NAME || 'AppContractor',
    port: PORT,
  });
});

// Rutas
app.use('/api/register', registerRoutes);
app.use('/api/categorias', categoriaRoutes);
app.use('/api/auth', loginRoutes);
app.use('/api/ubicacion', ubicacionRoutes);
app.use('/api/favoritos', favoritosRoutes);
app.use('/api/trabajos-largo-plazo', trabajosLargoPlazoRoutes);
app.use('/api/trabajos-corto-plazo', trabajosCortoPlazoRoutes);

// Ruta para verificar la conexión a la base de datos
app.get('/api/health', async (req, res) => {
  try {
    const isConnected = await testConnection();
    if (isConnected) {
      res.json({
        status: 'OK',
        message: 'Conexión a la base de datos exitosa',
        database: process.env.DB_NAME || 'AppContractor',
      });
    } else {
      res.status(500).json({
        status: 'ERROR',
        message: 'No se pudo conectar a la base de datos',
      });
    }
  } catch (error) {
    res.status(500).json({
      status: 'ERROR',
      message: error.message,
    });
  }
});

// Iniciar servidor
app.listen(PORT, '0.0.0.0', async () => {
  console.log(`🚀 Servidor corriendo en http://localhost:${PORT}`);
  console.log(`🌐 Accesible desde: http://0.0.0.0:${PORT}`);
  console.log(`📦 Entorno: ${process.env.NODE_ENV || 'development'}`);
  console.log(`📡 Rutas disponibles:`);
  console.log(`   - POST /api/register/contratista`);
  console.log(`   - POST /api/register/trabajador`);
  console.log(`   - POST /api/auth/login`);
  console.log(`   - GET /api/auth/verify`);
  console.log(`   - GET /api/categorias`);
  console.log(`   - PUT /api/ubicacion/contratista`);
  console.log(`   - PUT /api/ubicacion/trabajador`);
  console.log(`   - GET /api/ubicacion/trabajadores-cercanos?email=...&radio=500`);
  console.log(`   - GET /api/ubicacion/trabajadores-por-categoria?email=...&categoria=...&radio=500`);
  console.log(`   - GET /api/ubicacion/contratistas-cercanos?email=...&radio=500`);
  console.log(`   - GET /api/health`);
  
  // Probar conexión a la base de datos al iniciar
  await testConnection();
});

export default app;

