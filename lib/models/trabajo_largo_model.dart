<<<<<<< HEAD
=======
import '../services/format_service.dart';

>>>>>>> feature/App-Terminada
class TrabajoLargoModel {
  final int? idTrabajoLargo;
  final String emailContratista;
  final String titulo;
  final String descripcion;
<<<<<<< HEAD
  final double latitud;
  final double longitud;
=======
  final double? latitud;
  final double? longitud;
>>>>>>> feature/App-Terminada
  final String? direccion;
  final String fechaInicio; // formato YYYY-MM-DD
  final String fechaFin; // formato YYYY-MM-DD
  final String estado;
  final int vacantesDisponibles;
  final String? tipoObra;
  final String? frecuencia;
  final DateTime? createdAt;

  // Datos enriquecidos para vistas
  final String? nombreContratista;
  final String? apellidoContratista;
  final String? telefonoContratista;
  final double? distanciaKm;

  const TrabajoLargoModel({
    this.idTrabajoLargo,
    required this.emailContratista,
    required this.titulo,
    required this.descripcion,
<<<<<<< HEAD
    required this.latitud,
    required this.longitud,
=======
    this.latitud,
    this.longitud,
>>>>>>> feature/App-Terminada
    this.direccion,
    required this.fechaInicio,
    required this.fechaFin,
    this.estado = 'activo',
    required this.vacantesDisponibles,
    this.tipoObra,
    this.frecuencia,
    this.createdAt,
    this.nombreContratista,
    this.apellidoContratista,
    this.telefonoContratista,
    this.distanciaKm,
  });

  /// Construir desde la respuesta del backend (trabajos cercanos / listados)
  factory TrabajoLargoModel.fromJson(Map<String, dynamic> json) {
    return TrabajoLargoModel(
      idTrabajoLargo: json['id_trabajo_largo'] as int?,
      emailContratista: json['email_contratista'] ?? json['emailContratista'] ?? '',
      titulo: json['titulo'] ?? '',
      descripcion: json['descripcion'] ?? '',
<<<<<<< HEAD
      latitud: _parseDouble(json['latitud']),
      longitud: _parseDouble(json['longitud']),
=======
      latitud: FormatService.parseDoubleNullable(json['latitud']),
      longitud: FormatService.parseDoubleNullable(json['longitud']),
>>>>>>> feature/App-Terminada
      direccion: json['direccion'],
      fechaInicio: (json['fecha_inicio'] ?? json['fechaInicio'] ?? '').toString(),
      fechaFin: (json['fecha_fin'] ?? json['fechaFin'] ?? '').toString(),
      estado: json['estado'] ?? 'activo',
<<<<<<< HEAD
      vacantesDisponibles:
          int.tryParse((json['vacantes_disponibles'] ?? json['vacantesDisponibles'] ?? '0').toString()) ?? 0,
=======
      vacantesDisponibles: FormatService.parseInt(json['vacantes_disponibles'] ?? json['vacantesDisponibles'] ?? '0'),
>>>>>>> feature/App-Terminada
      tipoObra: json['tipo_obra'] ?? json['tipoObra'],
      frecuencia: json['frecuencia'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      nombreContratista: json['nombre_contratista'] ?? json['nombreContratista'],
      apellidoContratista: json['apellido_contratista'] ?? json['apellidoContratista'],
      telefonoContratista: json['telefono_contratista'] ?? json['telefonoContratista'],
      distanciaKm: json['distancia_km'] != null
          ? double.tryParse(json['distancia_km'].toString())
          : null,
    );
  }

  /// Datos necesarios para registrar un trabajo nuevo
  Map<String, dynamic> toJsonForCreate() {
    return {
      'emailContratista': emailContratista,
      'titulo': titulo,
      'descripcion': descripcion,
      'latitud': latitud,
      'longitud': longitud,
      'direccion': direccion,
      'fechaInicio': fechaInicio,
      'fechaFin': fechaFin,
      'vacantesDisponibles': vacantesDisponibles,
      'tipoObra': tipoObra,
      'frecuencia': frecuencia,
    };
  }

  TrabajoLargoModel copyWith({
    int? idTrabajoLargo,
    String? emailContratista,
    String? titulo,
    String? descripcion,
    double? latitud,
    double? longitud,
    String? direccion,
    String? fechaInicio,
    String? fechaFin,
    String? estado,
    int? vacantesDisponibles,
    String? tipoObra,
    String? frecuencia,
    DateTime? createdAt,
    String? nombreContratista,
    String? apellidoContratista,
    String? telefonoContratista,
    double? distanciaKm,
  }) {
    return TrabajoLargoModel(
      idTrabajoLargo: idTrabajoLargo ?? this.idTrabajoLargo,
      emailContratista: emailContratista ?? this.emailContratista,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      latitud: latitud ?? this.latitud,
      longitud: longitud ?? this.longitud,
      direccion: direccion ?? this.direccion,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFin: fechaFin ?? this.fechaFin,
      estado: estado ?? this.estado,
      vacantesDisponibles: vacantesDisponibles ?? this.vacantesDisponibles,
      tipoObra: tipoObra ?? this.tipoObra,
      frecuencia: frecuencia ?? this.frecuencia,
      createdAt: createdAt ?? this.createdAt,
      nombreContratista: nombreContratista ?? this.nombreContratista,
      apellidoContratista: apellidoContratista ?? this.apellidoContratista,
      telefonoContratista: telefonoContratista ?? this.telefonoContratista,
      distanciaKm: distanciaKm ?? this.distanciaKm,
    );
  }

<<<<<<< HEAD
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }
=======
>>>>>>> feature/App-Terminada
}

