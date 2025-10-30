import 'package:flutter/material.dart';
import 'modal_detail_short.dart';
import 'modal_detail_length.dart';


class WorkerCard extends StatelessWidget {
  final String title;
  final String status;
  final Color statusColor;
  final String ubication;
  final String payout;
  final bool isLongTerm;
  final int? vacancies;

  const WorkerCard({
    super.key,
    required this.title,
    required this.status,
    required this.statusColor,
    required this.ubication,
    required this.payout,
    required this.isLongTerm,
    this.vacancies,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  status,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Pago: $payout',
            style: const TextStyle(
              color: Color(0xFF1F4E79),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ubication,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              if (isLongTerm && vacancies != null)
                Text(
                  'Vacantes: $vacancies',
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            TextButton(
              onPressed: () {
                if (isLongTerm) {
                  // Mostrar modal de largo plazo
                  ModalTrabajoLargo.show(
                    context,
                    titulo: title,
                    descripcion: "Descripción del trabajo de largo plazo...",
                    ubicacion: ubication,
                    vacantes: vacancies ?? 0,
                    frecuenciaPago: "Semanal",
                    fechaInicio: "01/11/2025",
                    fechaFinal: "31/03/2026",
                    tipoObra: "Construcción de edificio",
                  );
                } else {
                  // Mostrar modal de corto plazo
                  ModalTrabajoCorto.show(
                    context,
                    titulo: title,
                    descripcion: "Trabajo corto de reparación eléctrica urgente.",
                    rangoPrecio: payout,
                    ubicacion: ubication,
                    fotos: [
                      "https://images.unsplash.com/photo-1503387762-592deb58ef4e",
                      "https://www.elesquiu.com/u/fotografias/m/2024/7/4/f1280x720-516936_648611_5050.jpg",
                      "https://nanotechnology.com.ar/assets/images/trabajos/azm7gkdbivp6vq0gognmsd9o18n1cq.jpg"
                    ],
                    disponibilidad: "Inmediata",
                    especialidad: "Electricista",
                  );
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFEAEAEA),
                minimumSize: const Size(120, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Ver detalles',
                style: TextStyle(
                  color: Color(0xFF5A5A5A),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1F4E79),
                  minimumSize: const Size(120, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Aplicar Ahora',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
