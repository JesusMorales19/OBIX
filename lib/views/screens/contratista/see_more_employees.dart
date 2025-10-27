import 'package:flutter/material.dart';
import '../../widgets/header_bar.dart';
import '../../widgets/main_banner.dart';
import '../../widgets/contratista/home_view/worker_card.dart';
import '../../widgets/contratista/home_view/filter_modal_see_more.dart';

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

  final List<Map<String, dynamic>> allWorkers = [
    {'name': 'Jesus Morales Hernandez','edad': 28,'categoria': 'Albañil','descripcion': 'Especialista en muros y losas. Trabajo profesional.','status': 'Disponible','statusColor': Colors.green,'image': 'assets/images/albañil.png','rating': 4.8,'experiencia': 6},
    {'name': 'Carlos López','edad': 32,'categoria': 'Carpintero','descripcion': 'Experto en muebles y acabados finos.','status': 'Ocupado','statusColor': Colors.red,'image': 'assets/images/carpintero.png','rating': 4.6,'experiencia': 8},
    {'name': 'Luis García','edad': 40,'categoria': 'Electricista','descripcion': 'Instalaciones eléctricas residenciales y comerciales.','status': 'Disponible','statusColor': Colors.green,'image': 'assets/images/electricista.png','rating': 4.9,'experiencia': 10},
    {'name': 'Pedro Díaz','edad': 24,'categoria': 'Albañil','descripcion': 'Ayudante con 2 años de experiencia.','status': 'Disponible','statusColor': Colors.green,'image': 'assets/images/albañil.png','rating': 4.2,'experiencia': 2},
  ];

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
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.category, style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 22)),
                    const SizedBox(height: 20),
                    if (filteredWorkers.isEmpty)
                      const Text('No hay empleados que coincidan con los filtros seleccionados.', style: TextStyle(color: Colors.grey)),
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