import { query } from '../config/db.js';

/**
 * Registrar un nuevo trabajo de largo plazo
 */
export const registrarTrabajoLargoPlazo = async (req, res) => {
  try {
    const {
      emailContratista,
      titulo,
      descripcion,
      latitud,
      longitud,
      direccion,
      fechaInicio,
      fechaFin,
      vacantesDisponibles,
      tipoObra,
      frecuencia,
    } = req.body;

    console.log('Registrando trabajo largo plazo:', { titulo, emailContratista });

    // Validaciones básicas
    if (!emailContratista || !titulo || !descripcion || !fechaInicio || !fechaFin || !vacantesDisponibles) {
      return res.status(400).json({
        success: false,
        error: 'Faltan campos requeridos',
      });
    }

    // Validar que las coordenadas estén presentes
    if (!latitud || !longitud) {
      return res.status(400).json({
        success: false,
        error: 'Se requieren las coordenadas (latitud y longitud) del trabajo',
      });
    }

    // Verificar que el contratista existe
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

    // Insertar el trabajo
    const result = await query(
      `INSERT INTO trabajos_largo_plazo (
        email_contratista,
        titulo,
        descripcion,
        latitud,
        longitud,
        direccion,
        fecha_inicio,
        fecha_fin,
        estado,
        vacantes_disponibles,
        tipo_obra,
        frecuencia,
        created_at
      ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, CURRENT_TIMESTAMP)
      RETURNING 
        id_trabajo_largo,
        email_contratista,
        titulo,
        descripcion,
        latitud,
        longitud,
        direccion,
        fecha_inicio,
        fecha_fin,
        estado,
        vacantes_disponibles,
        tipo_obra,
        frecuencia,
        created_at`,
      [
        emailContratista,
        titulo,
        descripcion,
        latitud,
        longitud,
        direccion || null,
        fechaInicio,
        fechaFin,
        'activo', // Estado inicial
        vacantesDisponibles,
        tipoObra || null,
        frecuencia || null,
      ]
    );

    console.log('✅ Trabajo registrado exitosamente');

    res.status(201).json({
      success: true,
      message: 'Trabajo de largo plazo registrado exitosamente',
      data: result.rows[0],
    });
  } catch (error) {
    console.error('❌ Error al registrar trabajo largo plazo:', error);
    res.status(500).json({
      success: false,
      error: 'Error interno del servidor',
      details: error.message,
    });
  }
};

/**
 * Obtener trabajos de largo plazo de un contratista
 */
export const obtenerTrabajosPorContratista = async (req, res) => {
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
        tlp.*,
        c.nombre as nombre_contratista,
        c.apellido as apellido_contratista
       FROM trabajos_largo_plazo tlp
       INNER JOIN contratistas c ON tlp.email_contratista = c.email
       WHERE tlp.email_contratista = $1
       ORDER BY tlp.created_at DESC`,
      [emailContratista]
    );

    res.status(200).json({
      success: true,
      total: result.rows.length,
      trabajos: result.rows,
    });
  } catch (error) {
    console.error('❌ Error al obtener trabajos:', error);
    res.status(500).json({
      success: false,
      error: 'Error interno del servidor',
      details: error.message,
    });
  }
};

/**
 * Buscar trabajos cercanos (para trabajadores)
 */
export const buscarTrabajosCercanos = async (req, res) => {
  try {
    const { emailTrabajador, radio = 500 } = req.query;

    if (!emailTrabajador) {
      return res.status(400).json({
        success: false,
        error: 'Email del trabajador es requerido',
      });
    }

    // Obtener ubicación del trabajador
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

    // Buscar trabajos cercanos usando la fórmula de Haversine
    // Buscar trabajos cercanos usando subconsulta para evitar error con distancia_km
    const result = await query(
      `SELECT 
        id_trabajo_largo,
        email_contratista,
        titulo,
        descripcion,
        latitud,
        longitud,
        direccion,
        fecha_inicio,
        fecha_fin,
        estado,
        vacantes_disponibles,
        tipo_obra,
        frecuencia,
        created_at,
        nombre_contratista,
        apellido_contratista,
        telefono_contratista,
        email_contratista as email_contratista_full,
        distancia_km
       FROM (
         SELECT 
           tlp.*,
           c.nombre as nombre_contratista,
           c.apellido as apellido_contratista,
           c.telefono as telefono_contratista,
           (6371 * acos(
             cos(radians($1)) * cos(radians(tlp.latitud)) * 
             cos(radians(tlp.longitud) - radians($2)) + 
             sin(radians($1)) * sin(radians(tlp.latitud))
           )) AS distancia_km
         FROM trabajos_largo_plazo tlp
         INNER JOIN contratistas c ON tlp.email_contratista = c.email
         WHERE tlp.latitud IS NOT NULL 
         AND tlp.longitud IS NOT NULL
         AND tlp.estado = 'activo'
         AND tlp.vacantes_disponibles > 0
       ) AS trabajos_con_distancia
       WHERE distancia_km <= $3
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
    console.error('❌ Error al buscar trabajos cercanos:', error);
    res.status(500).json({
      success: false,
      error: 'Error interno del servidor',
      details: error.message,
    });
  }
};

/**
 * Actualizar estado de un trabajo
 */
export const actualizarEstadoTrabajo = async (req, res) => {
  try {
    const { idTrabajo } = req.params;
    const { estado } = req.body;

    if (!estado) {
      return res.status(400).json({
        success: false,
        error: 'El estado es requerido',
      });
    }

    const result = await query(
      `UPDATE trabajos_largo_plazo 
       SET estado = $1
       WHERE id_trabajo_largo = $2
       RETURNING *`,
      [estado, idTrabajo]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        error: 'Trabajo no encontrado',
      });
    }

    res.status(200).json({
      success: true,
      message: 'Estado actualizado correctamente',
      data: result.rows[0],
    });
  } catch (error) {
    console.error('❌ Error al actualizar estado:', error);
    res.status(500).json({
      success: false,
      error: 'Error interno del servidor',
      details: error.message,
    });
  }
};

