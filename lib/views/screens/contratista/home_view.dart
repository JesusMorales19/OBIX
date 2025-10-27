import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';

// ---------- IMPORTACIÓN DE TUS COMPONENTES ----------
import '../../widgets/custom_bottom_nav.dart';
import '../../widgets/header_bar.dart';
import '../../widgets/main_banner.dart';
import '../../widgets/contratista/home_view/search_and_filter_bar.dart';
import '../../widgets/contratista/home_view/service_category.dart';
import '../../widgets/contratista/home_view/worker_card.dart';

class HomeViewContractor extends StatelessWidget {
  const HomeViewContractor({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const CustomBottomNav(
        role: 'contratista',
        currentIndex: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const HeaderBar(tipoUsuario: 'contratista'),
            const SizedBox(height: 15),
            const MainBanner(),
            const SizedBox(height: 25),
            const SearchAndFilterBar(),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Servicios A Ofrecer',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 10),
                    ServiceCategory(
                      title: 'Albañil',
                      workers: [
                        WorkerCard(
                          name: 'Jesus Morales Hernandez',
                          edad: 28,
                          categoria: 'Albañil',
                          descripcion:
                              'Especialista en construcción de muros, losas y acabados. Trabajo limpio y profesional.',
                          status: 'Disponible',
                          statusColor: Colors.green,
                          image: 'assets/images/albañil.png',
                          rating: 4.8,
                          experiencia: 6,
                        ),
                      ],
                    ),
                    ServiceCategory(
                      title: 'Electricista',
                      workers: [
                        WorkerCard(
                          name: 'Daniel Estrada',
                          edad: 32,
                          categoria: 'Electricista',
                          descripcion:
                              'Experto en instalaciones residenciales y mantenimiento eléctrico certificado.',
                          status: 'Ocupado',
                          statusColor: Colors.red,
                          image: 'assets/images/electrisista.png',
                          rating: 4.5,
                          experiencia: 4,
                        ),
                      ],
                    ),
                    ServiceCategory(
                      title: 'Carpintero',
                      workers: [
                        WorkerCard(
                          name: 'Fernanda Bonilla Dominguez',
                          edad: 30,
                          categoria: 'Carpintera',
                          descripcion:
                              'Diseño y fabricación de muebles personalizados y trabajos en madera de alta calidad.',
                          status: 'Disponible',
                          statusColor: Colors.green,
                          image: 'assets/images/carpintera.png',
                          rating: 4.7,
                          experiencia: 8,
                        ),
                      ],
                    ),
                    SizedBox(height: 70),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // ---------- BOTÓN FLOTANTE ----------
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        backgroundColor: const Color(0xFFE67E22),
        foregroundColor: Colors.white,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        spacing: 12,
        spaceBetweenChildren: 8,
        children: [
          // BOTÓN CORTO PLAZO
          SpeedDialChild(
            child: const Icon(Icons.work_outline, color: Colors.white, size: 28),
            backgroundColor: Colors.blue,
            label: 'Registro Trabajo Corto Plazo',
            labelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            labelBackgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 6,
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const RegistroCortoPlazoModal(),
              );
            },
          ),

          // BOTÓN LARGO PLAZO
          SpeedDialChild(
            child: const Icon(Icons.work, color: Colors.white, size: 28),
            backgroundColor: Colors.green,
            label: 'Registro Trabajo Largo Plazo',
            labelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            labelBackgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 6,
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const RegistroLargoPlazoModal(),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ---------------------- MODAL REGISTRO CORTO PLAZO ----------------------
class RegistroCortoPlazoModal extends StatefulWidget {
  const RegistroCortoPlazoModal({super.key});

  @override
  State<RegistroCortoPlazoModal> createState() =>
      _RegistroCortoPlazoModalState();
}

class _RegistroCortoPlazoModalState extends State<RegistroCortoPlazoModal> {
  final _formKey = GlobalKey<FormState>();
  String? disponibilidad;
  String? especialidad;
  final ImagePicker _picker = ImagePicker();
  List<XFile> _imagenes = [];

  Future<void> _seleccionarImagenes() async {
    final List<XFile>? seleccionadas = await _picker.pickMultiImage();
    if (seleccionadas != null && seleccionadas.isNotEmpty) {
      setState(() => _imagenes = seleccionadas);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Registrar Trabajo Corto Plazo',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 25),
                _buildTextField(Icons.title, 'Título del trabajo'),
                _buildTextField(Icons.description, 'Descripción breve', maxLines: 2),
                _buildTextField(Icons.attach_money, 'Rango de precio', hint: 'Ej: 600 - 1000 MXN'),
                _buildTextField(Icons.location_on, 'Ubicación'),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: _seleccionarImagenes,
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          color: Colors.blueAccent.withOpacity(0.6), width: 1.2),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.photo_library_outlined, color: Colors.blueAccent),
                        SizedBox(width: 10),
                        Text(
                          'Seleccionar fotos del trabajo',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if (_imagenes.isNotEmpty)
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _imagenes.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(_imagenes[index].path),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 10),
                _buildDropdown(
                  label: 'Disponibilidad',
                  icon: Icons.access_time,
                  value: disponibilidad,
                  items: ['Inmediata', 'Dentro de 3 días', 'Una semana'],
                  onChanged: (v) => setState(() => disponibilidad = v),
                ),
                _buildDropdown(
                  label: 'Especialidad requerida',
                  icon: Icons.handyman,
                  value: especialidad,
                  items: ['Albañil', 'Electricista', 'Carpintero', 'Plomero', 'Pintor'],
                  onChanged: (v) => setState(() => especialidad = v),
                ),
                const SizedBox(height: 25),
                ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Trabajo registrado correctamente'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Registrar Trabajo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(IconData icon, String label, {int maxLines = 1, String? hint}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        maxLines: maxLines,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          labelText: label,
          hintText: hint,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.blueAccent, width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
          ),
        ),
        validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
      ),
    );
  }

  Widget _buildDropdown({required String label, required IconData icon, required String? value, required List<String> items, required ValueChanged<String?> onChanged}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          labelText: label,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.blueAccent),
          ),
        ),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
        validator: (value) => value == null ? 'Seleccione una opción' : null,
      ),
    );
  }
}

// ---------------------- MODAL REGISTRO LARGO PLAZO ----------------------
class RegistroLargoPlazoModal extends StatefulWidget {
  const RegistroLargoPlazoModal({super.key});

  @override
  State<RegistroLargoPlazoModal> createState() =>
      _RegistroLargoPlazoModalState();
}

class _RegistroLargoPlazoModalState extends State<RegistroLargoPlazoModal> {
  final _formKey = GlobalKey<FormState>();
  String? frecuenciaPago;
  String? tipoObra;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Registrar Trabajo Largo Plazo',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 25),
                _buildTextField(Icons.title, 'Título del trabajo'),
                _buildTextField(Icons.description, 'Descripción breve', maxLines: 2),
                _buildTextField(Icons.location_on, 'Ubicación'),
                _buildTextField(Icons.people, 'Número de vacantes', hint: 'Ej: 3'),
                _buildDropdown(
                  label: 'Frecuencia de pago',
                  icon: Icons.attach_money,
                  value: frecuenciaPago,
                  items: ['Diaria', 'Semanal', 'Quincenal', 'Mensual'],
                  onChanged: (v) => setState(() => frecuenciaPago = v),
                ),
                _buildTextField(Icons.date_range, 'Fecha inicio estimada', hint: 'DD/MM/AAAA'),
                _buildTextField(Icons.date_range, 'Fecha final estimada', hint: 'DD/MM/AAAA'),
                _buildDropdown(
                  label: 'Tipo de obra',
                  icon: Icons.construction,
                  value: tipoObra,
                  items: ['Construcción', 'Reparación', 'Mantenimiento'],
                  onChanged: (v) => setState(() => tipoObra = v),
                ),
                const SizedBox(height: 25),
                ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Trabajo registrado correctamente'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Registrar Trabajo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(IconData icon, String label, {int maxLines = 1, String? hint}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        maxLines: maxLines,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.green),
          labelText: label,
          hintText: hint,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.green, width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.green, width: 2),
          ),
        ),
        validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
      ),
    );
  }

  Widget _buildDropdown({required String label, required IconData icon, required String? value, required List<String> items, required ValueChanged<String?> onChanged}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.green),
          labelText: label,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.green),
          ),
        ),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
        validator: (value) => value == null ? 'Seleccione una opción' : null,
      ),
    );
  }
}
