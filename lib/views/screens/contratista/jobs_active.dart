import 'package:flutter/material.dart';
import '../../widgets/custom_bottom_nav.dart';
import '../../widgets/header_bar.dart';
import '../../widgets/contratista/jobs_active/job_card_widgets.dart';
import '../../widgets/contratista/jobs_active/search_and_filter_bar_jobs.dart';

class JobsActive extends StatelessWidget {
  const JobsActive({super.key});

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
            const SearchAndFilterBar(),

            const SizedBox(height: 40),

            // Lista scrollable de trabajos
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: const [
                    JobCardLargo(
                      title: 'Remodelación centro históricos de la ciudad',
                      frecuenciaPago: 'Pago semanal',
                      ubicacion: 'Durango, México',
                      trabajadoresFaltantes: '8',
                      tipoObra: 'Remodelación',
                      fechaInicio: '04/10/2025',
                      fechaFinal: '04/12/2025',
                    ),
                    JobCardCorto(
                      title: 'Detalle de yeso en techo  5x5 metros',
                      rangoPrecio: '1000 a 2000',
                      ubicacion: 'Durango, México',
                      especialidad: 'Yesero',
                      disponibilidad: 'Inmediata',
                    ),
                    JobCardCorto(
                      title: 'Barda 4x5 metros',
                      rangoPrecio: '1500 a 2500',
                      ubicacion: 'Durango, México',
                      especialidad: 'Albañilería',
                      disponibilidad: 'Inmediata',
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
