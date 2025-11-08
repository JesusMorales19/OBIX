import { query } from '../config/db.js';

/**
 * Actualiza la ubicación de un contratista
 */
export const actualizarUbicacionContratista = async (req, res) => {
  try {
    const { email, latitud, longitud } = req.body;

    // Validar campos requeridos
    if (!email || latitud === undefined || longitud === undefined) {
      return res.status(400).json({
        success: false,
        error: 'Email, latitud y longitud son requeridos',
      });
    }

    // Validar rangos de coordenadas
    if (latitud < -90 || latitud > 90 || longitud < -180 || longitud > 180) {
      return res.status(400).json({
        success: false,
        error: 'Coordenadas inválidas',
      });
    }

    // Actualizar ubicación del contratista
    const result = await query(
      `UPDATE contratistas 
       SET latitud = $1, longitud = $2, ubicacion_actualizada = CURRENT_TIMESTAMP
       WHERE email = $3
       RETURNING email, latitud, longitud, ubicacion_actualizada`,
      [latitud, longitud, email]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        error: 'Contratista no encontrado',
      });
    }

    res.status(200).json({
      success: true,
      message: 'Ubicación actualizada exitosamente',
      data: result.rows[0],
    });
  } catch (error) {
    console.error('Error al actualizar ubicación del contratista:', error);
    res.status(500).json({
      success: false,
      error: 'Error interno del servidor',
      details: error.message,
    });
  }
};

/**
 * Actualiza la ubicación de un trabajador
 */
export const actualizarUbicacionTrabajador = async (req, res) => {
  try {
    const { email, latitud, longitud } = req.body;

    // Validar campos requeridos
    if (!email || latitud === undefined || longitud === undefined) {
      return res.status(400).json({
        success: false,
        error: 'Email, latitud y longitud son requeridos',
      });
    }

    // Validar rangos de coordenadas
    if (latitud < -90 || latitud > 90 || longitud < -180 || longitud > 180) {
      return res.status(400).json({
        success: false,
        error: 'Coordenadas inválidas',
      });
    }

    // Actualizar ubicación del trabajador
    const result = await query(
      `UPDATE trabajadores 
       SET latitud = $1, longitud = $2, ubicacion_actualizada = CURRENT_TIMESTAMP
       WHERE email = $3
       RETURNING email, latitud, longitud, ubicacion_actualizada`,
      [latitud, longitud, email]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        error: 'Trabajador no encontrado',
      });
    }

    res.status(200).json({
      success: true,
      message: 'Ubicación actualizada exitosamente',
      data: result.rows[0],
    });
  } catch (error) {
    console.error('Error al actualizar ubicación del trabajador:', error);
    res.status(500).json({
      success: false,
      error: 'Error interno del servidor',
      details: error.message,
    });
  }
};

/**
 * Busca trabajadores cercanos a un contratista (radio de 500km)
 * Devuelve solo 1 trabajador por categoría (el más cercano)
 */
export const buscarTrabajadoresCercanos = async (req, res) => {
  try {
    const { email, radio = 500 } = req.query;

    if (!email) {
      return res.status(400).json({
        success: false,
        error: 'Email del contratista es requerido',
      });
    }

    const contratistaResult = await query(
      'SELECT latitud, longitud FROM contratistas WHERE email = $1',
      [email]
    );

    if (contratistaResult.rows.length === 0) {
      return res.status(404).json({
        success: false,
        error: 'Contratista no encontrado',
      });
    }

    const { latitud: lat1, longitud: lon1 } = contratistaResult.rows[0];

    if (!lat1 || !lon1) {
      return res.status(400).json({
        success: false,
        error: 'El contratista no tiene ubicación registrada',
      });
    }

    // Obtener solo 1 trabajador por categoría (el más cercano)
    // Usamos subconsulta para poder filtrar por distancia_km
    const trabajadoresResult = await query(
      `SELECT DISTINCT ON (categoria)
        nombre, apellido, username, email, telefono, 
        categoria, experiencia, latitud, longitud, 
        disponible, calificacion_promedio, distancia_km
       FROM (
         SELECT 
           t.nombre, t.apellido, t.username, t.email, t.telefono, 
           c.nombre as categoria, t.experiencia,
           t.latitud, t.longitud, t.disponible, t.calificacion_promedio,
           (6371 * acos(
             cos(radians($1)) * cos(radians(t.latitud)) * 
             cos(radians(t.longitud) - radians($2)) + 
             sin(radians($1)) * sin(radians(t.latitud))
           )) AS distancia_km
         FROM trabajadores t
         INNER JOIN categorias c ON t.categoria = c.id_categoria
         WHERE t.latitud IS NOT NULL AND t.longitud IS NOT NULL
       ) AS trabajadores_con_distancia
       WHERE distancia_km <= $3
       ORDER BY categoria, distancia_km ASC`,
      [lat1, lon1, radio]
    );

    // Agrupar por categoría
    const trabajadoresPorCategoria = {};
    trabajadoresResult.rows.forEach(trabajador => {
      const categoria = trabajador.categoria;
      if (!trabajadoresPorCategoria[categoria]) {
        trabajadoresPorCategoria[categoria] = [];
      }
      trabajadoresPorCategoria[categoria].push(trabajador);
    });

    res.status(200).json({
      success: true,
      total: trabajadoresResult.rows.length,
      radio_km: radio,
      trabajadores: trabajadoresResult.rows,
      trabajadores_por_categoria: trabajadoresPorCategoria,
    });
  } catch (error) {
    console.error('Error al buscar trabajadores cercanos:', error);
    res.status(500).json({
      success: false,
      error: 'Error interno del servidor',
      details: error.message,
    });
  }
};

/**
 * Busca TODOS los trabajadores cercanos de una categoría específica
 * Para la vista de "Ver más"
 */
export const buscarTrabajadoresPorCategoria = async (req, res) => {
  try {
    const { email, categoria, radio = 500 } = req.query;

    if (!email || !categoria) {
      return res.status(400).json({
        success: false,
        error: 'Email del contratista y categoría son requeridos',
      });
    }

    const contratistaResult = await query(
      'SELECT latitud, longitud FROM contratistas WHERE email = $1',
      [email]
    );

    if (contratistaResult.rows.length === 0) {
      return res.status(404).json({
        success: false,
        error: 'Contratista no encontrado',
      });
    }

    const { latitud: lat1, longitud: lon1 } = contratistaResult.rows[0];

    if (!lat1 || !lon1) {
      return res.status(400).json({
        success: false,
        error: 'El contratista no tiene ubicación registrada',
      });
    }

    // Buscar TODOS los trabajadores de la categoría especificada
    // Usamos subconsulta para poder filtrar por distancia_km
    const trabajadoresResult = await query(
      `SELECT 
        nombre, apellido, username, email, telefono, 
        categoria, experiencia, latitud, longitud, 
        disponible, calificacion_promedio, distancia_km
       FROM (
         SELECT 
           t.nombre, t.apellido, t.username, t.email, t.telefono, 
           c.nombre as categoria, t.experiencia,
           t.latitud, t.longitud, t.disponible, t.calificacion_promedio,
           (6371 * acos(
             cos(radians($1)) * cos(radians(t.latitud)) * 
             cos(radians(t.longitud) - radians($2)) + 
             sin(radians($1)) * sin(radians(t.latitud))
           )) AS distancia_km
         FROM trabajadores t
         INNER JOIN categorias c ON t.categoria = c.id_categoria
         WHERE t.latitud IS NOT NULL AND t.longitud IS NOT NULL
         AND c.nombre = $4
       ) AS trabajadores_con_distancia
       WHERE distancia_km <= $3
       ORDER BY distancia_km ASC`,
      [lat1, lon1, radio, categoria]
    );

    res.status(200).json({
      success: true,
      total: trabajadoresResult.rows.length,
      radio_km: radio,
      categoria: categoria,
      trabajadores: trabajadoresResult.rows,
    });
  } catch (error) {
    console.error('Error al buscar trabajadores por categoría:', error);
    res.status(500).json({
      success: false,
      error: 'Error interno del servidor',
      details: error.message,
    });
  }
};

/**
 * Busca trabajos/contratistas cercanos a un trabajador (radio de 500km)
 */
export const buscarContratistasCercanos = async (req, res) => {
  try {
    const { email, radio = 500 } = req.query; // Radio por defecto 500km

    // Validar email
    if (!email) {
      return res.status(400).json({
        success: false,
        error: 'Email del trabajador es requerido',
      });
    }

    // Obtener ubicación del trabajador
    const trabajadorResult = await query(
      'SELECT latitud, longitud FROM trabajadores WHERE email = $1',
      [email]
    );

    if (trabajadorResult.rows.length === 0) {
      return res.status(404).json({
        success: false,
        error: 'Trabajador no encontrado',
      });
    }

    const { latitud: lat1, longitud: lon1 } = trabajadorResult.rows[0];

    if (!lat1 || !lon1) {
      return res.status(400).json({
        success: false,
        error: 'El trabajador no tiene ubicación registrada',
      });
    }

    // Buscar contratistas con ubicación registrada
    const contratistasResult = await query(
      `SELECT 
        nombre, apellido, username, email, telefono,
        latitud, longitud,
        (6371 * acos(
          cos(radians($1)) * cos(radians(latitud)) * 
          cos(radians(longitud) - radians($2)) + 
          sin(radians($1)) * sin(radians(latitud))
        )) AS distancia_km
       FROM contratistas
       WHERE latitud IS NOT NULL AND longitud IS NOT NULL
       HAVING distancia_km <= $3
       ORDER BY distancia_km ASC`,
      [lat1, lon1, radio]
    );

    res.status(200).json({
      success: true,
      total: contratistasResult.rows.length,
      radio_km: radio,
      contratistas: contratistasResult.rows,
    });
  } catch (error) {
    console.error('Error al buscar contratistas cercanos:', error);
    res.status(500).json({
      success: false,
      error: 'Error interno del servidor',
      details: error.message,
    });
  }
};
