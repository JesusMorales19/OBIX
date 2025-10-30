import 'package:flutter/material.dart';
import '../../widgets/custom_bottom_nav.dart';
import '../../widgets/header_bar.dart';
import '../../widgets/main_banner.dart';
import '../../widgets/trabajador/home_view/search_bar.dart';
import '../../widgets/trabajador/jobs_employee/job_category.dart';
import '../../widgets/trabajador/home_view/worker_card.dart';

class HomeViewEmployee extends StatelessWidget {
  const HomeViewEmployee({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const CustomBottomNav(
        role: 'trabajador',
        currentIndex: 0,
        ),
      body: SafeArea(
        child: Column(
          children: [
            const HeaderBar(tipoUsuario: 'trabajador'),
            const SizedBox(height: 15),
            const MainBanner(),
            const SizedBox(height: 25),
            const CustomSearchBar(),
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
                        'Trabajos disponibles',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    JobCategory(
                      title: 'Trabajos Rápidos',
                      tipoUsuario: 'trabajador',
                      jobs: [
                        WorkerCard(
                          title: 'Se busca yesero para detalle de casa',
                          status: 'Disponible',
                          statusColor: Colors.green,
                          ubication: 'Ubicación: UTD',
                          payout: '\$500 a \$1000',
                          isLongTerm: false,
                        ),
                        // WorkerCard(
                        //   title: 'Se necesita plomero para reparación urgente',
                        //   status: 'Disponible',
                        //   statusColor: Colors.green,
                        //   ubication: 'Ubicación: UTD',
                        //   payout: '\$300 a \$800',
                        //   isLongTerm: false,
                        // ),
                      ],
                    ),
                    SizedBox(height: 25),
                    JobCategory(
                      title: 'Trabajos Largo Plazo',
                      tipoUsuario: 'trabajador',
                      jobs: [
                        WorkerCard(
                          title: 'Construcción de una casa',
                          status: 'Disponible',
                          statusColor: Colors.green,
                          ubication: 'Ubicación: UTD',
                          payout: 'Según la categoría',
                          isLongTerm: true,
                          vacancies: 5,
                        ),
                      ],
                    ),
                    //     WorkerCard(
                    //       title: 'Construcción de una casa',
                    //       status: 'Disponible',
                    //       statusColor: Colors.green,
                    //       ubication: 'Ubicación: UTD',
                    //       payout: 'Según la categoría',
                    //       isLongTerm: true,
                    //       vacancies: 5,
                    // ),
                    SizedBox(height: 80),
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
