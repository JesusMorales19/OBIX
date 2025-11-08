import 'package:flutter/material.dart';
import '../../widgets/custom_bottom_nav.dart';
import '../../widgets/header_bar.dart';
import '../../widgets/main_banner.dart';
import '../../widgets/trabajador/jobs_employee/job_category.dart';
import '../../widgets/trabajador/home_view/worker_card.dart';
import '../../../services/api_service.dart';
import '../../../services/storage_service.dart';
import '../../../models/trabajo_largo_model.dart';
import '../../../models/trabajo_corto_model.dart';

class HomeViewEmployee extends StatefulWidget {
  const HomeViewEmployee({super.key});

  @override
  State<HomeViewEmployee> createState() => _HomeViewEmployeeState();
}

class _HomeViewEmployeeState extends State<HomeViewEmployee> {
  List<TrabajoLargoModel> _trabajosLargo = [];
  List<TrabajoCortoModel> _trabajosCorto = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarTrabajosCercanos();
  }

  /// Formatear fecha para mostrar solo YYYY-MM-DD
  String _formatearFecha(String? fecha) {
    if (fecha == null || fecha.isEmpty) return 'No especificada';
    
    try {
      // Si viene en formato ISO (2025-01-15T06:00:00.000Z), extraer solo la fecha
      if (fecha.contains('T')) {
        return fecha.split('T')[0];
      }
      return fecha;
    } catch (e) {
      return fecha;
    }
  }

  /// Cargar trabajos cercanos desde la API
  Future<void> _cargarTrabajosCercanos() async {
    try {
      setState(() => _isLoading = true);

      final user = await StorageService.getUser();
      if (user == null) {
        setState(() => _isLoading = false);
        return;
      }

      final emailTrabajador = user['email'];

      final results = await Future.wait([
        ApiService.buscarTrabajosCercanos(emailTrabajador, radio: 500),
        ApiService.buscarTrabajosCortoCercanos(emailTrabajador, radio: 500),
      ]);

      final resultadoLargo = results[0] as Map<String, dynamic>;
      final resultadoCorto = results[1] as Map<String, dynamic>;

      setState(() {
        if (resultadoLargo['success'] == true) {
          final trabajos = resultadoLargo['trabajos'] as List<dynamic>;
          _trabajosLargo = trabajos.map((t) => TrabajoLargoModel.fromJson(t)).toList();
        } else {
          print('Error al cargar trabajos largos: ${resultadoLargo['error']}');
        }

        if (resultadoCorto['success'] == true) {
          final trabajosCorto = resultadoCorto['trabajos'] as List<dynamic>;
          _trabajosCorto = trabajosCorto.map((t) => TrabajoCortoModel.fromJson(t)).toList();
        } else {
          print('Error al cargar trabajos cortos: ${resultadoCorto['error']}');
        }

        _isLoading = false;
      });
    } catch (e) {
      print('Error al cargar trabajos cercanos: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const CustomBottomNav(
        role: 'trabajador',
        currentIndex: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const HeaderBar(tipoUsuario: 'trabajador'),
            const SizedBox(height: 15),
            const MainBanner(),
            const SizedBox(height: 25),
            
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _trabajosLargo.isEmpty && _trabajosCorto.isEmpty
                      ? const Center(
                          child: Text(
                            'No hay trabajos cercanos disponibles',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 0, bottom: 20),
                                child: Text(
                                  'Trabajos disponibles',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              
                              // Trabajos Rápidos (Corto Plazo) - Solo datos estáticos por ahora
                              JobCategory(
                                title: 'Trabajos Rápidos',
                                tipoUsuario: 'trabajador',
                                jobs: _trabajosCorto.isNotEmpty
                                    ? _trabajosCorto.take(1).map((trabajo) {
                                        final contratistaNombre =
                                            [trabajo.nombreContratista, trabajo.apellidoContratista]
                                                .where((element) => element != null && element!.isNotEmpty)
                                                .join(' ');
                                        return WorkerCard(
                                          title: trabajo.titulo,
                                          status: trabajo.estado == 'activo' ? 'Disponible' : 'No disponible',
                                          statusColor: trabajo.estado == 'activo' ? Colors.green : Colors.grey,
                                          ubication: trabajo.direccion ?? 'Sin dirección',
                                          payout: trabajo.rangoPago,
                                          payoutLabel: 'Rango de pago',
                                          isLongTerm: false,
                                          vacancies: trabajo.vacantesDisponibles,
                                          contratista: contratistaNombre.isEmpty ? null : contratistaNombre,
                                          descripcion: trabajo.descripcion,
                                          fechaInicio: null,
                                          fechaFinal: null,
                                          imagenesBase64: trabajo.imagenesBase64,
                                          disponibilidad: trabajo.disponibilidad,
                                          especialidad: trabajo.especialidad,
                                          latitud: trabajo.latitud,
                                          longitud: trabajo.longitud,
                                        );
                                      }).toList()
                                    : const [
                                        Padding(
                                          padding: EdgeInsets.symmetric(vertical: 12),
                                          child: Text(
                                            'No hay trabajos rápidos disponibles',
                                            style: TextStyle(color: Colors.grey),
                                          ),
                                        ),
                                      ],
                              ),
                              
                              const SizedBox(height: 25),
                              
                              // Trabajos de Largo Plazo - Solo mostrar el primero
                              if (_trabajosLargo.isNotEmpty)
                                JobCategory(
                                  title: 'Trabajos Largo Plazo',
                                  tipoUsuario: 'trabajador',
                                  jobs: _trabajosLargo.take(1).map((trabajo) {
                                    final contratistaNombre =
                                        [trabajo.nombreContratista, trabajo.apellidoContratista]
                                            .where((element) => element != null && element!.isNotEmpty)
                                            .join(' ');

                                    return WorkerCard(
                                      title: trabajo.titulo,
                                      status: trabajo.estado == 'activo' ? 'Disponible' : 'No disponible',
                                      statusColor: trabajo.estado == 'activo' ? Colors.green : Colors.grey,
                                      ubication: trabajo.direccion ?? 'Sin dirección',
                                      payout: trabajo.frecuencia ?? 'No especificado',
                                      payoutLabel: 'Frecuencia de trabajo',
                                      isLongTerm: true,
                                      vacancies: trabajo.vacantesDisponibles,
                                      contratista: contratistaNombre.isEmpty ? null : contratistaNombre,
                                      tipoObra: trabajo.tipoObra,
                                      fechaInicio: _formatearFecha(trabajo.fechaInicio),
                                      fechaFinal: _formatearFecha(trabajo.fechaFin),
                                      descripcion: trabajo.descripcion,
                                      latitud: trabajo.latitud,
                                      longitud: trabajo.longitud,
                                    );
                                  }).toList(),
                                ),
                              const SizedBox(height: 80),
                            ],
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
