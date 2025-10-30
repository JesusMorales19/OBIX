import 'package:flutter/material.dart';
import 'package:integradora/views/widgets/contratista/jobs_active/modals_helper.dart';
import 'package:integradora/views/widgets/contratista/jobs_active/show_modal_employees.dart';

//
// 🔹 CARD LARGO PLAZO
//
class JobCardLargo extends StatelessWidget {
  final String title;
  final String frecuenciaPago;
  final String ubicacion;
  final String trabajadoresFaltantes;
  final String tipoObra;
  final String fechaInicio;
  final String fechaFinal;

  const JobCardLargo({
    super.key,
    required this.title,
    required this.frecuenciaPago,
    required this.ubicacion,
    required this.trabajadoresFaltantes,
    required this.tipoObra,
    required this.fechaInicio,
    required this.fechaFinal,
  });

  @override
  Widget build(BuildContext context) {
    return _buildBaseCard(
      context: context,
      title: title,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow(
              'Frecuencia de pago:', frecuenciaPago, 'Ubicación:', ubicacion),
          _dividerLine(),
          _infoRow('Trabajadores Faltantes:', trabajadoresFaltantes,
              'Tipo de Obra:', tipoObra),
          _dividerLine(),
          _infoRow('Fecha Inicio:', fechaInicio, 'Fecha Final:', fechaFinal),
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
  final String ubicacion;
  final String especialidad;
  final String disponibilidad;

  const JobCardCorto({
    super.key,
    required this.title,
    required this.rangoPrecio,
    required this.ubicacion,
    required this.especialidad,
    required this.disponibilidad,
  });

  @override
  Widget build(BuildContext context) {
    return _buildBaseCard(
      context: context,
      title: title,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow('Rango de Precio:', rangoPrecio, 'Ubicación:', ubicacion),
          _dividerLine(),
          _infoRow('Especialidad Requerida:', especialidad,
              'Disponibilidad:', disponibilidad),
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