import 'package:flutter/material.dart';
import '../screens/contratista/home_view.dart';
import '../screens/trabajador/home_view.dart';
import '../screens/trabajador/jobs_employee.dart';


class CustomBottomNav extends StatefulWidget {
  final String role; // "trabajador" o "contratista"
  final int currentIndex;

  const CustomBottomNav({
    super.key,
    required this.role,
    this.currentIndex = 0,
  });

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  void _onItemTapped(int index) {
    Widget nextPage = const SizedBox.shrink();

    // Cambia la pantalla según el rol y el ítem tocado
    if (widget.role == "trabajador") {
      switch (index) {
        case 0:
          nextPage = const HomeViewEmployee();
          break;
        case 1:
          nextPage = const JobsViewEmployee();
          break;
        // case 2:
        //   nextPage = const PerfilTrabajador();
        //   break;
        // default:
        //   nextPage = const HomeViewTrabajador();
      }
    } else {
      // Rol: contratista
      switch (index) {
        case 0:
          nextPage = const HomeViewContractor();
          break;
      //   case 1:
      //     nextPage = const TrabajosContratista();
      //     break;
      //   case 2:
      //     nextPage = const PerfilContratista();
      //     break;
      //   default:
      //     nextPage = const HomeViewContratista();
      }
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => nextPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: BottomNavigationBar(
        currentIndex: widget.currentIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFFE67E22),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            label: 'Trabajos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
