import { query } from '../config/db.js';

/**
 * Obtiene todas las categorías disponibles
 */
export const getCategorias = async (req, res) => {
  try {
    const result = await query(
      'SELECT id_categoria, nombre FROM categorias ORDER BY nombre ASC'
    );

    res.status(200).json({
      success: true,
      data: result.rows,
    });
  } catch (error) {
    console.error('Error al obtener categorías:', error);
    res.status(500).json({
      success: false,
      error: 'Error interno del servidor',
      details: error.message,
    });
  }
};



