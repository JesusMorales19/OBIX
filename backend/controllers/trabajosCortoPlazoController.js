import { query } from '../config/db.js';
<<<<<<< HEAD
=======
import { handleDatabaseError, handleValidationError } from '../services/errorHandler.js';
>>>>>>> feature/App-Terminada

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
<<<<<<< HEAD
=======
      moneda = 'MXN',
>>>>>>> feature/App-Terminada
      latitud,
      longitud,
      direccion,
      disponibilidad,
      vacantesDisponibles,
      especialidad,
      imagenes = [],
    } = req.body;

    if (!emailContratista || !titulo || !descripcion || !rangoPago) {
<<<<<<< HEAD
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
=======
      return handleValidationError(res, 'Faltan campos requeridos');
    }

    if (vacantesDisponibles === undefined || vacantesDisponibles === null) {
      return handleValidationError(res, 'El número de vacantes es requerido');
    }

    // Validar que tenga al menos dirección o coordenadas
    if ((!latitud || !longitud) && (!direccion || direccion.trim() === '')) {
      return handleValidationError(res, 'Se requiere la ubicación del trabajo (coordenadas o dirección)');
>>>>>>> feature/App-Terminada
    }

    const contratistaResult = await query(
      'SELECT email FROM contratistas WHERE email = $1',
      [emailContratista]
    );

    if (contratistaResult.rows.length === 0) {
<<<<<<< HEAD
      return res.status(404).json({
        success: false,
        error: 'Contratista no encontrado',
      });
=======
      return handleValidationError(res, 'Contratista no encontrado', 404);
>>>>>>> feature/App-Terminada
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
<<<<<<< HEAD
=======
        moneda,
>>>>>>> feature/App-Terminada
        estado,
        vacantes_disponibles,
        disponibilidad,
        especialidad
<<<<<<< HEAD
      ) VALUES ($1, $2, $3, $4, $5, $6, $7, 'activo', $8, $9, $10)
=======
      ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, 'activo', $9, $10, $11)
>>>>>>> feature/App-Terminada
      RETURNING *`,
      [
        emailContratista,
        titulo,
        descripcion,
<<<<<<< HEAD
        latitud,
        longitud,
        direccion || null,
        rangoPago,
=======
        latitud || null,
        longitud || null,
        direccion || null,
        rangoPago,
        moneda,
>>>>>>> feature/App-Terminada
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
<<<<<<< HEAD
    console.error('❌ Error al registrar trabajo corto plazo:', error);
    res.status(500).json({
      success: false,
      error: 'Error interno del servidor',
      details: error.message,
    });
=======
    handleDatabaseError(error, res, 'Error al registrar trabajo corto plazo');
>>>>>>> feature/App-Terminada
  }
};

/**
 * Obtener trabajos de corto plazo del contratista
 */
export const obtenerTrabajosCortoPorContratista = async (req, res) => {
  try {
    const { emailContratista } = req.query;

    if (!emailContratista) {
<<<<<<< HEAD
      return res.status(400).json({
        success: false,
        error: 'Email del contratista es requerido',
      });
=======
      return handleValidationError(res, 'Email del contratista es requerido');
>>>>>>> feature/App-Terminada
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
<<<<<<< HEAD
    console.error('❌ Error al obtener trabajos cortos:', error);
    res.status(500).json({
      success: false,
      error: 'Error interno del servidor',
      details: error.message,
    });
=======
    handleDatabaseError(error, res, 'Error al obtener trabajos cortos');
>>>>>>> feature/App-Terminada
  }
};

/**
 * Buscar trabajos de corto plazo cercanos a un trabajador
 */
export const buscarTrabajosCortoCercanos = async (req, res) => {
  try {
    const { emailTrabajador, radio = 500 } = req.query;

    if (!emailTrabajador) {
<<<<<<< HEAD
      return res.status(400).json({
        success: false,
        error: 'Email del trabajador es requerido',
      });
    }

    const trabajadorResult = await query(
      'SELECT latitud, longitud FROM trabajadores WHERE email = $1',
=======
      return handleValidationError(res, 'Email del trabajador es requerido');
    }

    const trabajadorResult = await query(
      `SELECT t.latitud, t.longitud, c.nombre AS categoria_nombre
       FROM trabajadores t
       LEFT JOIN categorias c ON t.categoria = c.id_categoria
       WHERE t.email = $1`,
>>>>>>> feature/App-Terminada
      [emailTrabajador]
    );

    if (trabajadorResult.rows.length === 0) {
<<<<<<< HEAD
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
=======
      return handleValidationError(res, 'Trabajador no encontrado', 404);
    }

    const { latitud: lat1, longitud: lon1, categoria_nombre: categoriaNombreRaw } =
      trabajadorResult.rows[0];

    if (!lat1 || !lon1) {
      return handleValidationError(res, 'El trabajador no tiene ubicación registrada');
    }

    const categoriaNombre =
      typeof categoriaNombreRaw === 'string' && categoriaNombreRaw.trim().length > 0
        ? categoriaNombreRaw.trim()
        : null;

    if (!categoriaNombre) {
      return res.status(200).json({
        success: true,
        total: 0,
        radio_km: Number(radio),
        trabajos: [],
>>>>>>> feature/App-Terminada
      });
    }

    const result = await query(
      `SELECT 
        trabajos.id_trabajo_corto,
        trabajos.email_contratista,
        trabajos.titulo,
        trabajos.descripcion,
        trabajos.rango_pago,
<<<<<<< HEAD
=======
        trabajos.moneda,
>>>>>>> feature/App-Terminada
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
<<<<<<< HEAD
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
=======
           CASE 
             -- Si el trabajo tiene coordenadas, calcular distancia trabajo → trabajador
             WHEN tcp.latitud IS NOT NULL AND tcp.longitud IS NOT NULL THEN
               (6371 * acos(
                 cos(radians($1)) * cos(radians(tcp.latitud)) * 
                 cos(radians(tcp.longitud) - radians($2)) + 
                 sin(radians($1)) * sin(radians(tcp.latitud))
               ))
             -- Si el trabajo NO tiene coordenadas pero tiene dirección, usar coordenadas del contratista
             WHEN (tcp.latitud IS NULL OR tcp.longitud IS NULL) 
                  AND (tcp.direccion IS NOT NULL AND tcp.direccion != '')
                  AND c.latitud IS NOT NULL AND c.longitud IS NOT NULL THEN
               (6371 * acos(
                 cos(radians($1)) * cos(radians(c.latitud)) * 
                 cos(radians(c.longitud) - radians($2)) + 
                 sin(radians($1)) * sin(radians(c.latitud))
               ))
             ELSE NULL
           END AS distancia_km
         FROM trabajos_corto_plazo tcp
         INNER JOIN contratistas c ON tcp.email_contratista = c.email
         WHERE tcp.estado = 'activo'
           AND LOWER(tcp.especialidad) = LOWER($4)
           AND (
             -- Trabajos con coordenadas dentro del radio
             (tcp.latitud IS NOT NULL AND tcp.longitud IS NOT NULL AND
              (6371 * acos(
                cos(radians($1)) * cos(radians(tcp.latitud)) * 
                cos(radians(tcp.longitud) - radians($2)) + 
                sin(radians($1)) * sin(radians(tcp.latitud))
              )) <= $3)
             OR
             -- Trabajos sin coordenadas pero con dirección: usar coordenadas del contratista
             ((tcp.latitud IS NULL OR tcp.longitud IS NULL) 
              AND (tcp.direccion IS NOT NULL AND tcp.direccion != '')
              AND c.latitud IS NOT NULL AND c.longitud IS NOT NULL
              AND (6371 * acos(
                cos(radians($1)) * cos(radians(c.latitud)) * 
                cos(radians(c.longitud) - radians($2)) + 
                sin(radians($1)) * sin(radians(c.latitud))
              )) <= $3)
           )
       ) AS trabajos
       LEFT JOIN trabajos_corto_plazo_imagenes tci ON trabajos.id_trabajo_corto = tci.id_trabajo_corto
>>>>>>> feature/App-Terminada
       GROUP BY trabajos.id_trabajo_corto,
                trabajos.email_contratista,
                trabajos.titulo,
                trabajos.descripcion,
                trabajos.rango_pago,
<<<<<<< HEAD
=======
                trabajos.moneda,
>>>>>>> feature/App-Terminada
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
<<<<<<< HEAD
       ORDER BY distancia_km ASC`,
      [lat1, lon1, radio]
=======
       ORDER BY 
         CASE WHEN trabajos.distancia_km IS NULL THEN 1 ELSE 0 END,
         trabajos.distancia_km ASC NULLS LAST`,
      [lat1, lon1, Number(radio), categoriaNombre]
>>>>>>> feature/App-Terminada
    );

    res.status(200).json({
      success: true,
      total: result.rows.length,
<<<<<<< HEAD
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
=======
      radio_km: Number(radio),
      trabajos: result.rows,
    });
  } catch (error) {
    handleDatabaseError(error, res, 'Error al buscar trabajos cortos cercanos');
>>>>>>> feature/App-Terminada
  }
};