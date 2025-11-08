import 'package:flutter/material.dart';
import '../../widgets/trabajador/home_view/worker_card.dart';
import '../../widgets/header_bar.dart';
import '../../widgets/main_banner.dart';
import '../../widgets/trabajador/home_view/search_bar.dart';
import '../../../services/api_service.dart';
import '../../../services/storage_service.dart';

class VerMasScreen extends StatefulWidget {
  final String tipoUsuario; // 'trabajador' o 'contratista'
  final String categoria; // "Trabajos de corto plazo" o "Trabajos de largo plazo"

  const VerMasScreen({
    super.key,
    required this.tipoUsuario,
    required this.categoria,
  });

  @override
  State<VerMasScreen> createState() => _VerMasScreenState();
}

class _VerMasScreenState extends State<VerMasScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _trabajos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterJobs);
    if (widget.categoria == 'Trabajos Largo Plazo') {
      _cargarTrabajosLargoPlazo();
    } else if (widget.categoria == 'Trabajos Rápidos') {
      _cargarTrabajosCortoPlazo();
    } else {
      setState(() => _isLoading = false);
    }
  }

  /// Formatear fecha para mostrar solo YYYY-MM-DD
  String _formatearFecha(String? fecha) {
    if (fecha == null || fecha.isEmpty) return 'No especificada';
    
    try {
      if (fecha.contains('T')) {
        return fecha.split('T')[0];
      }
      return fecha;
    } catch (e) {
      return fecha;
    }
  }

  double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  /// Cargar trabajos de largo plazo desde la API
  Future<void> _cargarTrabajosLargoPlazo() async {
    try {
      setState(() => _isLoading = true);

      final user = await StorageService.getUser();
      if (user == null) {
        setState(() => _isLoading = false);
        return;
      }

      final emailTrabajador = user['email'];

      final resultado = await ApiService.buscarTrabajosCercanos(
        emailTrabajador,
        radio: 500,
      );

      if (resultado['success'] == true) {
        final trabajos = resultado['trabajos'] as List<dynamic>;

        setState(() {
          _trabajos = trabajos.map((t) {
            return {
              'title': t['titulo'] ?? '',
              'status': t['estado'] == 'activo' ? 'Disponible' : 'No disponible',
              'statusColor': t['estado'] == 'activo' ? Colors.green : Colors.grey,
              'ubication': t['direccion'] ?? 'Sin dirección',
              'payout': t['frecuencia'] ?? 'No especificado',
              'isLongTerm': true,
              'vacancies': t['vacantes_disponibles'] ?? 0,
              'contratista': '${t['nombre_contratista']} ${t['apellido_contratista']}',
              'tipoObra': t['tipo_obra'] ?? 'No especificado',
              'fechaInicio': t['fecha_inicio']?.toString() ?? '',
              'fechaFinal': t['fecha_fin']?.toString() ?? '',
              'descripcion': t['descripcion'] ?? '',
              'imagenes': const <String>[],
              'disponibilidad': null,
              'especialidad': t['tipo_obra'] ?? 'No especificado',
              'latitud': _parseDouble(t['latitud']),
              'longitud': _parseDouble(t['longitud']),
            };
          }).toList();
          
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('Error al cargar trabajos: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _cargarTrabajosCortoPlazo() async {
    try {
      setState(() => _isLoading = true);

      final user = await StorageService.getUser();
      if (user == null) {
        setState(() => _isLoading = false);
        return;
      }

      final emailTrabajador = user['email'];

      final resultado = await ApiService.buscarTrabajosCortoCercanos(
        emailTrabajador,
        radio: 500,
      );

      if (resultado['success'] == true) {
        final trabajos = resultado['trabajos'] as List<dynamic>;

        setState(() {
          _trabajos = trabajos.map((t) {
            final imagenes = <String>[];
            if (t['imagenes'] is List) {
              for (final img in t['imagenes']) {
                if (img is Map && img['imagen_base64'] != null) {
                  imagenes.add(img['imagen_base64']);
                }
              }
            }

            return {
              'title': t['titulo'] ?? '',
              'status': t['estado'] == 'activo' ? 'Disponible' : 'No disponible',
              'statusColor': t['estado'] == 'activo' ? Colors.green : Colors.grey,
              'ubication': t['direccion'] ?? 'Sin dirección',
              'payout': t['rango_precio'] ?? 'No especificado',
              'isLongTerm': false,
              'vacancies': null,
              'contratista': '${t['nombre_contratista']} ${t['apellido_contratista']}',
              'tipoObra': t['tipo_obra'] ?? 'No especificado',
              'fechaInicio': null,
              'fechaFinal': null,
              'descripcion': t['descripcion'] ?? '',
              'imagenes': imagenes,
              'disponibilidad': t['disponibilidad'] ?? 'No especificada',
              'especialidad': t['tipo_obra'] ?? 'No especificado',
              'latitud': _parseDouble(t['latitud']),
              'longitud': _parseDouble(t['longitud']),
            };
          }).toList();

          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('Error al cargar trabajos cortos: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  List<Map<String, dynamic>> _getAllJobs() {
    if (widget.categoria == "Trabajos Rápidos") {
      return _trabajos;
    } else if (widget.categoria == "Trabajos Largo Plazo") {
      // 🔸 Usa los trabajos cargados de la API
      return _trabajos;
    } else {
      return [];
    }
  }

  void _filterJobs() {
    setState(() {});
  }

  List<Map<String, dynamic>> _getFilteredJobs() {
    final allJobs = _getAllJobs();
    final searchQuery = _searchController.text.toLowerCase().trim();
    
    if (searchQuery.isEmpty) {
      return allJobs;
    }
    
    return allJobs.where((job) {
      final title = job['title']?.toString().toLowerCase() ?? '';
      final especialidad = job['especialidad']?.toString().toLowerCase() ?? '';
      
      // Buscar en el título o en la especialidad
      return title.contains(searchQuery) || especialidad.contains(searchQuery);
    }).toList();
  }

  List<Widget> _getTrabajos() {
    final filteredJobs = _getFilteredJobs();
    
    if (filteredJobs.isEmpty) {
      return [
        const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'No se encontraron trabajos',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
        ),
      ];
    }
    
    return filteredJobs.map((trabajo) {
      final bool esLargo = trabajo['isLongTerm'] ?? false;
      final String label = esLargo ? 'Frecuencia de trabajo' : 'Rango de precio';
      final String payout = trabajo['payout'] ?? 'No especificado';
      final List<String> imagenes = (trabajo['imagenes'] as List?)?.map((e) => e.toString()).toList() ?? const [];
      final String disponibilidad = trabajo['disponibilidad']?.toString() ?? 'No especificada';
      final String especialidad = trabajo['especialidad']?.toString() ?? 'No especificado';
 
      return WorkerCard(
        title: trabajo['title'] ?? '',
        status: trabajo['status'] ?? '',
        statusColor: trabajo['statusColor'] ?? Colors.green,
        ubication: trabajo['ubication'] ?? '',
        payout: payout,
        payoutLabel: label,
        isLongTerm: esLargo,
        vacancies: trabajo['vacancies'],
        contratista: trabajo['contratista'],
        tipoObra: trabajo['tipoObra'],
        fechaInicio: _formatearFecha(trabajo['fechaInicio']),
        fechaFinal: _formatearFecha(trabajo['fechaFinal']),
        descripcion: trabajo['descripcion'],
        imagenesBase64: imagenes,
        disponibilidad: disponibilidad,
        especialidad: especialidad,
        latitud: trabajo['latitud'] as double?,
        longitud: trabajo['longitud'] as double?,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Column(
          children: [
            HeaderBar(tipoUsuario: widget.tipoUsuario),
            const SizedBox(height: 10),
            const MainBanner(),
            const SizedBox(height: 15),
            CustomSearchBar(
              searchController: _searchController,
              onSearchChanged: (_) => _filterJobs(),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.categoria,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 30),
                            ..._getTrabajos(), // 👈 Aquí se muestran dinámicamente
                            const SizedBox(height: 25),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
