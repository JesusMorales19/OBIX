import 'package:flutter/material.dart';

// ---------- IMPORTACIÓN DE TUS COMPONENTES ----------
import '../../widgets/custom_bottom_nav.dart';
import '../../widgets/header_bar.dart';
import '../../widgets/main_banner.dart';
import '../../widgets/contratista/search_and_filter_bar.dart';
import '../../widgets/contratista/service_category.dart';
import '../../widgets/contratista/worker_card.dart';

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
            // ---------- ENCABEZADO ----------
            const HeaderBar(),
            const SizedBox(height: 15),

            // ---------- IMAGEN PRINCIPAL ----------
            const MainBanner(),
            const SizedBox(height: 25),

            // ---------- BUSCADOR ----------
            const SearchAndFilterBar(),
            const SizedBox(height: 20),

            // ---------- LISTA DE SERVICIOS ----------
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

                    // ---------- ALBAÑIL ----------
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

                    // ---------- ELECTRICISTA ----------
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

                    // ---------- CARPINTERA ----------
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFE67E22),
        onPressed: () {},
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
