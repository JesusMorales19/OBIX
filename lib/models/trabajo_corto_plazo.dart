class TrabajoCortoModel {
  final int? idTrabajoCorto;
  final String emailContratista;
  final String titulo;
  final String descripcion;
  final String rangoPrecio;
  final double latitud;
  final double longitud;
  final String? direccion;
  final String? disponibilidad;
  final String estado;
  final DateTime? fechaPublicacion;
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
    required this.rangoPrecio,
    required this.latitud,
    required this.longitud,
    this.direccion,
    this.disponibilidad,
    this.estado = 'activo',
    this.fechaPublicacion,
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
      rangoPrecio: json['rango_precio'] ?? json['rangoPrecio'] ?? '',
      latitud: _parseDouble(json['latitud']),
      longitud: _parseDouble(json['longitud']),
      direccion: json['direccion'],
      disponibilidad: json['disponibilidad'],
      estado: json['estado'] ?? 'activo',
      fechaPublicacion: json['fecha_publicacion'] != null
          ? DateTime.tryParse(json['fecha_publicacion'].toString())
          : null,
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
      'rangoPrecio': rangoPrecio,
      'latitud': latitud,
      'longitud': longitud,
      'direccion': direccion,
      'disponibilidad': disponibilidad,
      'imagenes': imagenesBase64,
    };
  }

  TrabajoCortoModel copyWith({
    int? idTrabajoCorto,
    String? emailContratista,
    String? titulo,
    String? descripcion,
    String? rangoPrecio,
    double? latitud,
    double? longitud,
    String? direccion,
    String? disponibilidad,
    String? estado,
    DateTime? fechaPublicacion,
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
      rangoPrecio: rangoPrecio ?? this.rangoPrecio,
      latitud: latitud ?? this.latitud,
      longitud: longitud ?? this.longitud,
      direccion: direccion ?? this.direccion,
      disponibilidad: disponibilidad ?? this.disponibilidad,
      estado: estado ?? this.estado,
      fechaPublicacion: fechaPublicacion ?? this.fechaPublicacion,
      createdAt: createdAt ?? this.createdAt,
      imagenesBase64: imagenesBase64 ?? List.of(this.imagenesBase64),
      nombreContratista: nombreContratista ?? this.nombreContratista,
      apellidoContratista: apellidoContratista ?? this.apellidoContratista,
      telefonoContratista: telefonoContratista ?? this.telefonoContratista,
      distanciaKm: distanciaKm ?? this.distanciaKm,
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }
}

