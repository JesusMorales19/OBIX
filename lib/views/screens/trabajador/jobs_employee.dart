import 'package:flutter/material.dart';
import '../../widgets/custom_bottom_nav.dart';
import '../../widgets/header_bar.dart';
import '../../widgets/main_banner.dart';
import '../../widgets/trabajador/worker_card_jobs.dart';

class JobsViewEmployee extends StatelessWidget {
  const JobsViewEmployee({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const CustomBottomNav(
        role: 'trabajador',
        currentIndex: 1,
        ),
      body: SafeArea(
        child: Column(
          children: [
            const HeaderBar(),
            const SizedBox(height: 15),
            const MainBanner(),
            const SizedBox(height: 25),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 0, bottom: 20),
                      child: Text(
                        'Trabajo Activo',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    WorkerCardJobs(
                      titulo: 'Construcción de vivienda unifamiliar',
                      pagoSemanal: '\$800',
                      frecuenciaPago: 'Semanal',
                      contratista: 'Constructora ABC',
                      ubicacion: 'Ciudad de México',
                      tipoObra: 'Residencial',
                      ultimoPago: '2024-06-15',
                      nombreTrabajador: 'Juan Pérez',
                      fechaFinal: '2024-12-31',
                      imagenUrl: 'assets/images/albañil.png',
                      activo: true,
                    ),
                  ],
                )
              ))
          ],
        ),
      ),
    );
  }
}