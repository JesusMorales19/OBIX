<<<<<<< HEAD
=======
import '../services/format_service.dart';

>>>>>>> feature/App-Terminada
class TrabajoCortoModel {
  final int? idTrabajoCorto;
  final String emailContratista;
  final String titulo;
  final String descripcion;
  final String rangoPago;
<<<<<<< HEAD
  final double latitud;
  final double longitud;
=======
  final String? moneda;
  final double? latitud;
  final double? longitud;
>>>>>>> feature/App-Terminada
  final String? direccion;
  final String? disponibilidad;
  final String? especialidad;
  final String estado;
  final int vacantesDisponibles;
  final DateTime? createdAt;
  final List<String> imagenesBase64;
  final String? nombreContratista;
  final String? apellidoContratista;
  final String? telefonoContratista;
  final double? distanciaKm;

  const TrabajoCortoModel({
    this.idTrabajoCorto,
    required this.emailContratista,
    required this.titulo,
    required this.descripcion,
    required this.rangoPago,
<<<<<<< HEAD
    required this.latitud,
    required this.longitud,
=======
    this.moneda = 'MXN',
    this.latitud,
    this.longitud,
>>>>>>> feature/App-Terminada
    this.direccion,
    this.disponibilidad,
    this.especialidad,
    this.estado = 'activo',
    required this.vacantesDisponibles,
    this.createdAt,
    this.imagenesBase64 = const [],
    this.nombreContratista,
    this.apellidoContratista,
    this.telefonoContratista,
    this.distanciaKm,
  });

  factory TrabajoCortoModel.fromJson(Map<String, dynamic> json) {
    final imagenes = <String>[];
    if (json['imagenes'] is List) {
      for (final img in json['imagenes']) {
        if (img is Map && img['imagen_base64'] != null) {
          imagenes.add(img['imagen_base64']);
        } else if (img is String) {
          imagenes.add(img);
        }
      }
    }

    return TrabajoCortoModel(
      idTrabajoCorto: json['id_trabajo_corto'] as int?,
      emailContratista: json['email_contratista'] ?? json['emailContratista'] ?? '',
      titulo: json['titulo'] ?? '',
      descripcion: json['descripcion'] ?? '',
      rangoPago: json['rango_pago'] ?? json['rangoPago'] ?? '',
<<<<<<< HEAD
      latitud: _parseDouble(json['latitud']),
      longitud: _parseDouble(json['longitud']),
=======
      moneda: json['moneda'] ?? 'MXN',
      latitud: FormatService.parseDoubleNullable(json['latitud']),
      longitud: FormatService.parseDoubleNullable(json['longitud']),
>>>>>>> feature/App-Terminada
      direccion: json['direccion'],
      disponibilidad: json['disponibilidad'],
      especialidad: json['especialidad'],
      estado: json['estado'] ?? 'activo',
<<<<<<< HEAD
      vacantesDisponibles:
          int.tryParse((json['vacantes_disponibles'] ?? json['vacantesDisponibles'] ?? '0').toString()) ?? 0,
=======
      vacantesDisponibles: FormatService.parseInt(json['vacantes_disponibles'] ?? json['vacantesDisponibles'] ?? '0'),
>>>>>>> feature/App-Terminada
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      imagenesBase64: imagenes,
      nombreContratista: json['nombre_contratista'] ?? json['nombreContratista'],
      apellidoContratista: json['apellido_contratista'] ?? json['apellidoContratista'],
      telefonoContratista: json['telefono_contratista'] ?? json['telefonoContratista'],
      distanciaKm: json['distancia_km'] != null
          ? double.tryParse(json['distancia_km'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJsonForCreate() {
    return {
      'emailContratista': emailContratista,
      'titulo': titulo,
      'descripcion': descripcion,
      'rangoPago': rangoPago,
<<<<<<< HEAD
=======
      'moneda': moneda ?? 'MXN',
>>>>>>> feature/App-Terminada
      'latitud': latitud,
      'longitud': longitud,
      'direccion': direccion,
      'disponibilidad': disponibilidad,
      'especialidad': especialidad,
      'vacantesDisponibles': vacantesDisponibles,
      'imagenes': imagenesBase64,
    };
  }

  TrabajoCortoModel copyWith({
    int? idTrabajoCorto,
    String? emailContratista,
    String? titulo,
    String? descripcion,
    String? rangoPago,
<<<<<<< HEAD
=======
    String? moneda,
>>>>>>> feature/App-Terminada
    double? latitud,
    double? longitud,
    String? direccion,
    String? disponibilidad,
    String? especialidad,
    String? estado,
    int? vacantesDisponibles,
    DateTime? createdAt,
    List<String>? imagenesBase64,
    String? nombreContratista,
    String? apellidoContratista,
    String? telefonoContratista,
    double? distanciaKm,
  }) {
    return TrabajoCortoModel(
      idTrabajoCorto: idTrabajoCorto ?? this.idTrabajoCorto,
      emailContratista: emailContratista ?? this.emailContratista,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      rangoPago: rangoPago ?? this.rangoPago,
<<<<<<< HEAD
=======
      moneda: moneda ?? this.moneda,
>>>>>>> feature/App-Terminada
      latitud: latitud ?? this.latitud,
      longitud: longitud ?? this.longitud,
      direccion: direccion ?? this.direccion,
      disponibilidad: disponibilidad ?? this.disponibilidad,
      especialidad: especialidad ?? this.especialidad,
      estado: estado ?? this.estado,
      vacantesDisponibles: vacantesDisponibles ?? this.vacantesDisponibles,
      createdAt: createdAt ?? this.createdAt,
      imagenesBase64: imagenesBase64 ?? List.of(this.imagenesBase64),
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

