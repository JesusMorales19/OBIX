import { query } from '../config/db.js';
import { comparePassword } from '../utils/passwordUtils.js';
import jwt from 'jsonwebtoken';

/**
 * Inicia sesión de un contratista o trabajador
 * Permite login con email o username
 * Detecta automáticamente el tipo de usuario buscando en ambas tablas
 */
export const login = async (req, res) => {
  try {
    const { emailOrUsername, password } = req.body;

    // Validar campos requeridos
    if (!emailOrUsername || !password) {
      return res.status(400).json({
        success: false,
        error: 'Email/username y contraseña son requeridos',
      });
    }

    let user = null;
    let tipoUsuario = null;

    // Buscar primero en contratistas
    const contratistaResult = await query(
      `SELECT nombre, apellido, username, email, password 
       FROM contratistas 
       WHERE email = $1 OR username = $1`,
      [emailOrUsername]
    );

    if (contratistaResult.rows.length > 0) {
      user = contratistaResult.rows[0];
      tipoUsuario = 'contratista';
    } else {
      // Si no se encontró en contratistas, buscar en trabajadores
      const trabajadorResult = await query(
        `SELECT nombre, apellido, username, email, password 
         FROM trabajadores 
         WHERE email = $1 OR username = $1`,
        [emailOrUsername]
      );

      if (trabajadorResult.rows.length > 0) {
        user = trabajadorResult.rows[0];
        tipoUsuario = 'trabajador';
      }
    }

    // Verificar si el usuario existe
    if (!user) {
      return res.status(401).json({
        success: false,
        error: 'Credenciales inválidas',
      });
    }

    // Verificar contraseña
    const isPasswordValid = await comparePassword(password, user.password);

    if (!isPasswordValid) {
      return res.status(401).json({
        success: false,
        error: 'Credenciales inválidas',
      });
    }

    // Generar JWT token (usando email como identificador único ya que no hay id)
    const token = jwt.sign(
      {
        email: user.email,
        username: user.username,
        tipoUsuario: tipoUsuario,
      },
      process.env.JWT_SECRET || 'tu_secreto_jwt_muy_seguro_cambiar_en_produccion',
      {
        expiresIn: '7d', // El token expira en 7 días
      }
    );

    // Preparar datos del usuario (sin contraseña)
    const userData = {
      nombre: user.nombre,
      apellido: user.apellido,
      username: user.username,
      email: user.email,
      tipoUsuario: tipoUsuario,
    };

    res.status(200).json({
      success: true,
      message: 'Login exitoso',
      token: token,
      user: userData,
    });
  } catch (error) {
    console.error('Error al hacer login:', error);
    res.status(500).json({
      success: false,
      error: 'Error interno del servidor',
      details: error.message,
    });
  }
};

/**
 * Verifica si un token JWT es válido
 */
export const verifyToken = async (req, res) => {
  try {
    const token = req.headers.authorization?.split(' ')[1]; // Bearer token

    if (!token) {
      return res.status(401).json({
        success: false,
        error: 'Token no proporcionado',
      });
    }

    const decoded = jwt.verify(
      token,
      process.env.JWT_SECRET || 'tu_secreto_jwt_muy_seguro_cambiar_en_produccion'
    );

    res.status(200).json({
      success: true,
      user: decoded,
    });
  } catch (error) {
    if (error.name === 'TokenExpiredError') {
      return res.status(401).json({
        success: false,
        error: 'Token expirado',
      });
    }

    res.status(401).json({
      success: false,
      error: 'Token inválido',
    });
  }
};

