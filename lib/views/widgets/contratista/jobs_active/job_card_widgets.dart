import 'package:flutter/material.dart';
import 'package:integradora/views/widgets/contratista/jobs_active/modals_helper.dart';
import 'package:integradora/views/widgets/contratista/jobs_active/show_modal_employees.dart';
import 'package:url_launcher/url_launcher.dart';

//
// 🔹 CARD LARGO PLAZO
//
class JobCardLargo extends StatelessWidget {
  final String title;
  final String frecuenciaPago;
  final String vacantesDisponibles;
  final String tipoObra;
  final String fechaInicio;
  final String fechaFinal;
  final double? latitud;
  final double? longitud;
  final String? direccion;

  const JobCardLargo({
    super.key,
    required this.title,
    required this.frecuenciaPago,
    required this.vacantesDisponibles,
    required this.tipoObra,
    required this.fechaInicio,
    required this.fechaFinal,
    this.latitud,
    this.longitud,
    this.direccion,
  });

  Future<void> _abrirMapa(BuildContext context) async {
    if (latitud == null || longitud == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay coordenadas disponibles para este trabajo.')),
      );
      return;
    }

    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$latitud,$longitud');
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir Maps.')), 
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildBaseCard(
      context: context,
      title: title,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow('Frecuencia de pago:', frecuenciaPago, 'Vacantes disponibles:', vacantesDisponibles),
          _dividerLine(),
          _infoRow('Fecha Inicio:', fechaInicio, 'Fecha Final:', fechaFinal),
          const SizedBox(height: 10),
          TextButton.icon(
            onPressed: () => _abrirMapa(context),
            icon: const Icon(Icons.map_outlined),
            label: const Text('Ver ubicación en Maps'),
          ),
        ],
      ),
    );
  }
}

//
// 🔹 CARD CORTO PLAZO
//
class JobCardCorto extends StatelessWidget {
  final String title;
  final String rangoPrecio;
  final String especialidad;
  final String disponibilidad;
  final double? latitud;
  final double? longitud;
  final String vacantesDisponibles;
  final String? fechaCreacion;

  const JobCardCorto({
    super.key,
    required this.title,
    required this.rangoPrecio,
    required this.especialidad,
    required this.disponibilidad,
    this.latitud,
    this.longitud,
    required this.vacantesDisponibles,
    this.fechaCreacion,
  });

  Future<void> _abrirMapa(BuildContext context) async {
    if (latitud == null || longitud == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay coordenadas disponibles para este trabajo.')),
      );
      return;
    }

    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$latitud,$longitud');
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir Maps.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildBaseCard(
      context: context,
      title: title,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow('Rango de Precio:', rangoPrecio, 'Vacantes disponibles:', vacantesDisponibles),
          _dividerLine(),
          _infoRow('Especialidad Requerida:', especialidad,
              'Trabajo creado:', fechaCreacion ?? 'No especificada'),
          const SizedBox(height: 10),
          TextButton.icon(
            onPressed: () => _abrirMapa(context),
            icon: const Icon(Icons.map_outlined),
            label: const Text('Ver ubicación en Maps'),
          ),
        ],
      ),
    );
  }
}

//
// 🔹 BASE CARD COMPARTIDA
//
Widget _buildBaseCard({
  required BuildContext context,
  required String title,
  required Widget content,
}) {
 return Container(
    margin: const EdgeInsets.only(bottom: 25),
    padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: const Color(0xFFDCE6F2)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 12,
          spreadRadius: 1,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 70),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F4E79),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              content,
              const SizedBox(height: 25),

              // Botones más cortos y delgados
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 150,
                    height: 30,
                    child: ElevatedButton(
                      onPressed: () {
                        showModalTrabajadores(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00AE0C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 8),
                      ),
                      child: const Text(
                        'Ver Trabajadores',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    height: 30,
                    child: ElevatedButton(
                      onPressed: () {
                        showEndJobFlow(context, ['Carlos Pérez', 'Luis García']);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 8),
                      ),
                      child: const Text(
                        'Terminar',
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Etiqueta "Activo"
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
            decoration: BoxDecoration(
              color: const Color(0xFF00AE0C),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'Activo',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

//
// 🔹 Divider entre los campos
//
Widget _dividerLine() {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 4),
    height: 1,
    color: const Color(0xFFDCE6F2),
  );
}

//
// 🔹 Filas de información
//
Widget _infoRow(String label1, String value1, String label2, String value2) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        flex: 1,
        child: RichText(
          text: TextSpan(
            text: '$label1 ',
            style: const TextStyle(
                color: Colors.black87, fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                text: value1,
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        flex: 1,
        child: RichText(
          text: TextSpan(
            text: '$label2 ',
            style: const TextStyle(
                color: Colors.black87, fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                text: value2,
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}