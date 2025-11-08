import 'package:flutter/material.dart';
import '../../widgets/header_bar.dart';
import '../../widgets/main_banner.dart';
import '../../widgets/contratista/home_view/worker_card.dart';
import '../../widgets/contratista/home_view/filter_modal_see_more.dart';
import '../../../services/api_service.dart';
import '../../../services/storage_service.dart';

class SeeMoreEmployees extends StatefulWidget {
  final String category;
  const SeeMoreEmployees({super.key, required this.category});

  @override
  State<SeeMoreEmployees> createState() => _SeeMoreEmployeesState();
}

class _SeeMoreEmployeesState extends State<SeeMoreEmployees> {
  double? minEdad;
  double? maxEdad;
  double? minExperiencia;
  double? minRating;

  final TextEditingController experienciaController = TextEditingController();
  final FocusNode experienciaFocusNode = FocusNode();

  // Lista de trabajadores de la API
  List<Map<String, dynamic>> allWorkers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarTrabajadoresDeCategoria();
  }

  /// Carga TODOS los trabajadores de esta categoría desde la API
  Future<void> _cargarTrabajadoresDeCategoria() async {
    try {
      setState(() => _isLoading = true);

      // Obtener email del usuario logueado
      final user = await StorageService.getUser();
      if (user == null) {
        setState(() => _isLoading = false);
        return;
      }

      final email = user['email'];

      // Buscar todos los trabajadores de esta categoría
      final resultado = await ApiService.buscarTrabajadoresPorCategoria(
        email,
        widget.category,
        radio: 500,
      );

      if (resultado['success'] == true) {
        final data = resultado['data'];
        final trabajadores = data['trabajadores'] as List<dynamic>;

        // Convertir trabajadores de la API al formato de la UI
        setState(() {
          allWorkers = trabajadores.map((t) {
            return {
              'name': '${t['nombre']} ${t['apellido']}',
              'edad': 0, // No tenemos edad en la BD
              'categoria': t['categoria'],
              'descripcion': 'Experiencia: ${t['experiencia']} años',
              'status': t['disponible'] ? 'Disponible' : 'Ocupado',
              'statusColor': t['disponible'] ? Colors.green : Colors.red,
              'image': 'assets/images/construccion.png',
              'rating': (t['calificacion_promedio'] ?? 0.0).toDouble(),
              'experiencia': t['experiencia'] ?? 0,
              'email': t['email'],
              'telefono': t['telefono'],
              'distancia_km': (t['distancia_km'] ?? 0.0).toDouble(),
            };
          }).toList();
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('Error al cargar trabajadores: $e');
      setState(() => _isLoading = false);
    }
  }

  List<Map<String, dynamic>> get filteredWorkers => allWorkers.where((w) {
    final edad = (w['edad'] as num).toDouble();
    final experiencia = (w['experiencia'] as num).toDouble();
    final rating = (w['rating'] as num).toDouble();
    if (w['categoria'] != widget.category) return false;
    if (minEdad != null && edad < minEdad!) return false;
    if (maxEdad != null && edad > maxEdad!) return false;
    if (minExperiencia != null && experiencia < minExperiencia!) return false;
    if (minRating != null && rating < minRating!) return false;
    return true;
  }).toList();

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => FilterModal(
        minEdad: minEdad,
        maxEdad: maxEdad,
        minExperiencia: minExperiencia,
        minRating: minRating,
        experienciaController: experienciaController,
        experienciaFocusNode: experienciaFocusNode,
        onApply: (edad, exp, rating) {
          setState(() {
            minEdad = edad.start;
            maxEdad = edad.end;
            minExperiencia = exp;
            minRating = rating;
          });
        },
        onClear: () {
          setState(() {
            minEdad = null;
            maxEdad = null;
            minExperiencia = null;
            minRating = null;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const HeaderBar(tipoUsuario: 'contratista'),
            const SizedBox(height: 15),
            const MainBanner(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Filtrar empleados", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.black)),
                  IconButton(icon: const Icon(Icons.filter_list,color: Colors.blueAccent,size: 30), onPressed: _openFilterSheet),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.category, style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 22)),
                          const SizedBox(height: 20),
                          if (filteredWorkers.isEmpty)
                            const Text('No hay empleados cercanos en esta categoría.', style: TextStyle(color: Colors.grey)),
                          for (var worker in filteredWorkers)
                            WorkerCard(
                              name: worker['name'],
                              edad: worker['edad'],
                              categoria: worker['categoria'],
                              descripcion: worker['descripcion'],
                              status: worker['status'],
                              statusColor: worker['statusColor'],
                              image: worker['image'],
                              rating: worker['rating'],
                              experiencia: worker['experiencia'],
                              email: worker['email'] ?? '',
                              telefono: worker['telefono'] ?? '',
                            ),
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