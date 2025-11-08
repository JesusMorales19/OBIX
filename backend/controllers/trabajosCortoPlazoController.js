import { query } from '../config/db.js';

/**
 * Registrar un nuevo trabajo de corto plazo
 */
export const registrarTrabajoCortoPlazo = async (req, res) => {
  try {
    const {
      emailContratista,
      titulo,
      descripcion,
      rangoPago,
      latitud,
      longitud,
      direccion,
      disponibilidad,
      vacantesDisponibles,
      especialidad,
      imagenes = [],
    } = req.body;

    if (!emailContratista || !titulo || !descripcion || !rangoPago) {
      return res.status(400).json({
        success: false,
        error: 'Faltan campos requeridos',
      });
    }

    if (vacantesDisponibles === undefined || vacantesDisponibles === null) {
      return res.status(400).json({
        success: false,
        error: 'El número de vacantes es requerido',
      });
    }

    if (!latitud || !longitud) {
      return res.status(400).json({
        success: false,
        error: 'Se requieren coordenadas del trabajo',
      });
    }

    const contratistaResult = await query(
      'SELECT email FROM contratistas WHERE email = $1',
      [emailContratista]
    );

    if (contratistaResult.rows.length === 0) {
      return res.status(404).json({
        success: false,
        error: 'Contratista no encontrado',
      });
    }

    const trabajoResult = await query(
      `INSERT INTO trabajos_corto_plazo (
        email_contratista,
        titulo,
        descripcion,
        latitud,
        longitud,
        direccion,
        rango_pago,
        estado,
        vacantes_disponibles,
        disponibilidad,
        especialidad
      ) VALUES ($1, $2, $3, $4, $5, $6, $7, 'activo', $8, $9, $10)
      RETURNING *`,
      [
        emailContratista,
        titulo,
        descripcion,
        latitud,
        longitud,
        direccion || null,
        rangoPago,
        vacantesDisponibles,
        disponibilidad || null,
        especialidad || null,
      ]
    );

    const trabajo = trabajoResult.rows[0];

    if (Array.isArray(imagenes) && imagenes.length > 0) {
      const insertPromises = imagenes
        .filter((img) => typeof img === 'string' && img.trim().length > 0)
        .map((img) =>
          query(
            `INSERT INTO trabajos_corto_plazo_imagenes (id_trabajo_corto, imagen_base64)
             VALUES ($1, $2)`,
            [trabajo.id_trabajo_corto, img]
          )
        );
      await Promise.all(insertPromises);
    }

    res.status(201).json({
      success: true,
      message: 'Trabajo de corto plazo registrado',
      data: trabajo,
    });
  } catch (error) {
    console.error('❌ Error al registrar trabajo corto plazo:', error);
    res.status(500).json({
      success: false,
      error: 'Error interno del servidor',
      details: error.message,
    });
  }
};

/**
 * Obtener trabajos de corto plazo del contratista
 */
export const obtenerTrabajosCortoPorContratista = async (req, res) => {
  try {
    const { emailContratista } = req.query;

    if (!emailContratista) {
      return res.status(400).json({
        success: false,
        error: 'Email del contratista es requerido',
      });
    }

    const result = await query(
      `SELECT 
        tcp.*,
        COALESCE(
          json_agg(json_build_object(
            'id_imagen', tci.id_imagen,
            'imagen_base64', tci.imagen_base64
          ) ORDER BY tci.id_imagen)
          FILTER (WHERE tci.id_imagen IS NOT NULL),
          '[]'::json
        ) AS imagenes
       FROM trabajos_corto_plazo tcp
       LEFT JOIN trabajos_corto_plazo_imagenes tci ON tcp.id_trabajo_corto = tci.id_trabajo_corto
       WHERE tcp.email_contratista = $1
       GROUP BY tcp.id_trabajo_corto
       ORDER BY tcp.created_at DESC`,
      [emailContratista]
    );

    res.status(200).json({
      success: true,
      total: result.rows.length,
      trabajos: result.rows,
    });
  } catch (error) {
    console.error('❌ Error al obtener trabajos cortos:', error);
    res.status(500).json({
      success: false,
      error: 'Error interno del servidor',
      details: error.message,
    });
  }
};

/**
 * Buscar trabajos de corto plazo cercanos a un trabajador
 */
export const buscarTrabajosCortoCercanos = async (req, res) => {
  try {
    const { emailTrabajador, radio = 500 } = req.query;

    if (!emailTrabajador) {
      return res.status(400).json({
        success: false,
        error: 'Email del trabajador es requerido',
      });
    }

    const trabajadorResult = await query(
      'SELECT latitud, longitud FROM trabajadores WHERE email = $1',
      [emailTrabajador]
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

    const result = await query(
      `SELECT 
        trabajos.id_trabajo_corto,
        trabajos.email_contratista,
        trabajos.titulo,
        trabajos.descripcion,
        trabajos.rango_pago,
        trabajos.latitud,
        trabajos.longitud,
        trabajos.direccion,
        trabajos.estado,
        trabajos.vacantes_disponibles,
        trabajos.disponibilidad,
        trabajos.especialidad,
        trabajos.created_at,
        trabajos.nombre_contratista,
        trabajos.apellido_contratista,
        trabajos.telefono_contratista,
        trabajos.distancia_km,
        COALESCE(
          json_agg(json_build_object(
            'id_imagen', tci.id_imagen,
            'imagen_base64', tci.imagen_base64
          ) ORDER BY tci.id_imagen)
          FILTER (WHERE tci.id_imagen IS NOT NULL),
          '[]'::json
        ) AS imagenes
       FROM (
         SELECT 
           tcp.*,
           c.nombre AS nombre_contratista,
           c.apellido AS apellido_contratista,
           c.telefono AS telefono_contratista,
           (6371 * acos(
             cos(radians($1)) * cos(radians(tcp.latitud)) * 
             cos(radians(tcp.longitud) - radians($2)) + 
             sin(radians($1)) * sin(radians(tcp.latitud))
           )) AS distancia_km
         FROM trabajos_corto_plazo tcp
         INNER JOIN contratistas c ON tcp.email_contratista = c.email
         WHERE tcp.latitud IS NOT NULL 
           AND tcp.longitud IS NOT NULL
           AND tcp.estado = 'activo'
       ) AS trabajos
       LEFT JOIN trabajos_corto_plazo_imagenes tci ON trabajos.id_trabajo_corto = tci.id_trabajo_corto
       WHERE distancia_km <= $3
       GROUP BY trabajos.id_trabajo_corto,
                trabajos.email_contratista,
                trabajos.titulo,
                trabajos.descripcion,
                trabajos.rango_pago,
                trabajos.latitud,
                trabajos.longitud,
                trabajos.direccion,
                trabajos.estado,
                trabajos.vacantes_disponibles,
                trabajos.disponibilidad,
                trabajos.especialidad,
                trabajos.created_at,
                trabajos.nombre_contratista,
                trabajos.apellido_contratista,
                trabajos.telefono_contratista,
                trabajos.distancia_km
       ORDER BY distancia_km ASC`,
      [lat1, lon1, radio]
    );

    res.status(200).json({
      success: true,
      total: result.rows.length,
      radio_km: radio,
      trabajos: result.rows,
    });
  } catch (error) {
    console.error('❌ Error al buscar trabajos cortos cercanos:', error);
    res.status(500).json({
      success: false,
      error: 'Error interno del servidor',
      details: error.message,
    });
  }
};