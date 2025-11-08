import 'package:flutter/material.dart';
import '../../widgets/custom_bottom_nav.dart';
import '../../widgets/header_bar.dart';
import '../../widgets/contratista/jobs_active/job_card_widgets.dart';
import '../../widgets/contratista/jobs_active/search_and_filter_bar_jobs.dart';
import '../../../services/api_service.dart';
import '../../../services/storage_service.dart';

class JobsActive extends StatefulWidget {
  const JobsActive({super.key});

  @override
  State<JobsActive> createState() => _JobsActiveState();
}

class _JobsActiveState extends State<JobsActive> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedFilter;
  List<Map<String, dynamic>> _allJobs = [];
  List<Map<String, dynamic>> _filteredJobs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterJobs);
    _cargarTrabajosContratista();
  }

  double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  String _formatearFecha(dynamic valor) {
    if (valor == null) return 'No especificada';
    final texto = valor.toString();
    if (texto.isEmpty) return 'No especificada';
    if (texto.contains('T')) {
      return texto.split('T').first;
    }
    return texto;
  }

  /// Cargar trabajos de largo plazo del contratista desde la API
  Future<void> _cargarTrabajosContratista() async {
    try {
      setState(() => _isLoading = true);

      final user = await StorageService.getUser();
      if (user == null) {
        setState(() => _isLoading = false);
        return;
      }

      final emailContratista = user['email'];

      final resultados = await Future.wait([
        ApiService.obtenerTrabajosContratista(emailContratista),
        ApiService.obtenerTrabajosCortoContratista(emailContratista),
      ]);

      final resultadoLargo = resultados[0] as Map<String, dynamic>;
      final resultadoCorto = resultados[1] as Map<String, dynamic>;

      final List<Map<String, dynamic>> trabajosCombinados = [];

      if (resultadoLargo['success'] == true) {
        final trabajosLargos = resultadoLargo['trabajos'] as List<dynamic>;
        trabajosCombinados.addAll(trabajosLargos.map((t) {
          return {
            'type': 'largo',
            'id': t['id_trabajo_largo'],
            'title': t['titulo'] ?? '',
            'descripcion': t['descripcion'] ?? '',
            'frecuenciaPago': t['frecuencia'] ?? 'No especificado',
            'vacantesDisponibles': t['vacantes_disponibles']?.toString() ?? '0',
            'tipoObra': t['tipo_obra'] ?? 'No especificado',
            'fechaInicio': _formatearFecha(t['fecha_inicio']),
            'fechaFinal': _formatearFecha(t['fecha_fin']),
            'estado': t['estado'] ?? 'activo',
            'latitud': _parseDouble(t['latitud']),
            'longitud': _parseDouble(t['longitud']),
            'direccion': t['direccion'],
          };
        }));
      } else {
        print('Error al cargar trabajos largos: ${resultadoLargo['error']}');
      }

      if (resultadoCorto['success'] == true) {
        final trabajosCortos = resultadoCorto['trabajos'] as List<dynamic>;
        trabajosCombinados.addAll(trabajosCortos.map((t) {
          return {
            'type': 'corto',
            'id': t['id_trabajo_corto'],
            'title': t['titulo'] ?? '',
            'descripcion': t['descripcion'] ?? '',
            'rangoPrecio': t['rango_pago'] ?? 'No especificado',
            'especialidad': t['especialidad'] ?? 'No especificado',
            'disponibilidad': t['disponibilidad'] ?? 'No especificada',
            'estado': t['estado'] ?? 'activo',
            'latitud': _parseDouble(t['latitud']),
            'longitud': _parseDouble(t['longitud']),
            'direccion': t['direccion'],
            'vacantesDisponibles': t['vacantes_disponibles']?.toString() ?? '0',
            'fechaCreacion': _formatearFecha(t['created_at']),
          };
        }));
      } else {
        print('Error al cargar trabajos cortos: ${resultadoCorto['error']}');
      }

      setState(() {
        _allJobs = trabajosCombinados;
        _filteredJobs = List.from(trabajosCombinados);
        _isLoading = false;
      });
    } catch (e) {
      print('Error al cargar trabajos: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterJobs() {
    setState(() {
      final searchQuery = _searchController.text.toLowerCase().trim();
      
      _filteredJobs = _allJobs.where((job) {
        // Filtrar por tipo (largo/corto)
        if (_selectedFilter != null) {
          if (job['type'] != _selectedFilter) {
            return false;
          }
        }
        
        // Filtrar por nombre (título)
        if (searchQuery.isNotEmpty) {
          final title = job['title']?.toString().toLowerCase() ?? '';
          if (!title.contains(searchQuery)) {
            return false;
          }
        }
        
        return true;
      }).toList();
    });
  }

  void _onFilterChanged(String? value) {
    setState(() {
      _selectedFilter = value;
    });
    _filterJobs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const CustomBottomNav(
        role: 'contratista',
        currentIndex: 1,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const HeaderBar(tipoUsuario: 'contratista'),
            const SizedBox(height: 10),

            // Línea con inner shadow debajo del título
            const DividerWithShadow(),

            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                'Trabajos Activos',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Barra de búsqueda y selector
            SearchAndFilterBar(
              searchController: _searchController,
              selectedFilter: _selectedFilter,
              onFilterChanged: _onFilterChanged,
              onSearchChanged: (_) => _filterJobs(),
            ),

            const SizedBox(height: 40),

            // Lista scrollable de trabajos
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredJobs.isEmpty
                      ? const Center(
                          child: Text(
                            'No tienes trabajos registrados',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: _filteredJobs.map((job) {
                          if (job['type'] == 'largo') {
                            return JobCardLargo(
                              title: job['title'] ?? '',
                              frecuenciaPago: job['frecuenciaPago'] ?? '',
                              vacantesDisponibles: job['vacantesDisponibles'] ?? '',
                              tipoObra: job['tipoObra'] ?? '',
                              fechaInicio: job['fechaInicio'] ?? '',
                              fechaFinal: job['fechaFinal'] ?? '',
                              latitud: job['latitud'] as double?,
                              longitud: job['longitud'] as double?,
                              direccion: job['direccion'] as String?,
                            );
                          } else {
                            return JobCardCorto(
                              title: job['title'] ?? '',
                              rangoPrecio: job['rangoPrecio'] ?? '',
                              especialidad: job['especialidad'] ?? '',
                              disponibilidad: job['disponibilidad'] ?? '',
                              latitud: job['latitud'] as double?,
                              longitud: job['longitud'] as double?,
                              vacantesDisponibles: job['vacantesDisponibles'] ?? '',
                              fechaCreacion: job['fechaCreacion'] as String?,
                            );
                          }
                        }).toList(),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// Línea con sombra
class DividerWithShadow extends StatelessWidget {
  const DividerWithShadow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 1,
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            spreadRadius: -2,
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
    );
  }
}
