import 'package:flutter/material.dart';
import '../../widgets/trabajador/home_view/worker_card.dart';
import '../../widgets/header_bar.dart';
import '../../widgets/main_banner.dart';
import '../../widgets/trabajador/home_view/search_bar.dart';

class VerMasScreen extends StatelessWidget {
  final String tipoUsuario; // 'trabajador' o 'contratista'
  final String categoria; // "Trabajos de corto plazo" o "Trabajos de largo plazo"

  const VerMasScreen({
    super.key,
    required this.tipoUsuario,
    required this.categoria,
  });

  List<Widget> _getTrabajos() {
    if (categoria == "Trabajos Rápidos") {
      // 🔹 Lista para trabajos de corto plazo
      return [
        WorkerCard(
          title: 'Remodelación de baño',
          status: 'Activo',
          statusColor: Colors.green,
          ubication: 'Monterrey, NL',
          payout: '\$3,000 - \$4,500',
          isLongTerm: false,
        ),
        WorkerCard(
          title: 'Pintura interior',
          status: 'Activo',
          statusColor: Colors.green,
          ubication: 'Guadalajara, JAL',
          payout: '\$2,000',
          isLongTerm: false,
        ),
        WorkerCard(
          title: 'Instalación eléctrica básica',
          status: 'Activo',
          statusColor: Colors.green,
          ubication: 'CDMX',
          payout: '\$3,500 - \$5,000',
          isLongTerm: false,
        ),
      ];
    } else if (categoria == "Trabajos Largo Plazo") {
      // 🔸 Lista para trabajos de largo plazo
      return [
        WorkerCard(
          title: 'Construcción de casa completa',
          status: 'Activo',
          statusColor: Colors.green,
          ubication: 'Puebla, PUE',
          payout: '\$50,000 - \$70,000',
          isLongTerm: true,
          vacancies: 5,
        ),
        WorkerCard(
          title: 'Proyecto de pavimentación',
          status: 'Activo',
          statusColor: Colors.green,
          ubication: 'CDMX',
          payout: '\$100,000',
          isLongTerm: true,
          vacancies: 8,
        ),
        WorkerCard(
          title: 'Supervisión de obra industrial',
          status: 'Activo',
          statusColor: Colors.green,
          ubication: 'Querétaro, QRO',
          payout: '\$90,000',
          isLongTerm: true,
          vacancies: 2,
        ),
      ];
    } else {
      // Si no coincide con ninguna categoría
      return [
        const Center(
          child: Text(
            'No hay trabajos disponibles en esta categoría.',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Column(
          children: [
            HeaderBar(tipoUsuario: tipoUsuario),
            const SizedBox(height: 10),
            const MainBanner(),
            const SizedBox(height: 15),
            const CustomSearchBar(),
            const SizedBox(height: 30),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        categoria,
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
