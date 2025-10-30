import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:integradora/views/widgets/contratista/jobs_active/confirm_dismiss_modal.dart';

void showModalTrabajadores(BuildContext context) {
  final List<Map<String, dynamic>> trabajadores = [
    {'nombre': 'Carlos Pérez', 'oficio': 'Albañil', 'favorito': false},
    {'nombre': 'Luis García', 'oficio': 'Pintor', 'favorito': true},
    {'nombre': 'Miguel López', 'oficio': 'Carpintero', 'favorito': false},
    {'nombre': 'Ana Torres', 'oficio': 'Electricista', 'favorito': false},
    {'nombre': 'Sofía Martínez', 'oficio': 'Plomera', 'favorito': true},
    {'nombre': 'Javier Ramírez', 'oficio': 'Carpintero', 'favorito': false},
    {'nombre': 'Lucía Fernández', 'oficio': 'Albañil', 'favorito': true},
    {'nombre': 'Diego Sánchez', 'oficio': 'Pintor', 'favorito': false},
    {'nombre': 'Mariana López', 'oficio': 'Electricista', 'favorito': false},
  ];

  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: '',
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (context, anim1, anim2) {
      return Stack(
        children: [
          // Fondo borroso
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          // Modal centrado
          Center(
            child: StatefulBuilder(
              builder: (context, setState) => Dialog(
                backgroundColor: Colors.transparent,
                insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.white, width: .5),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF9800).withOpacity(0.8),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.7,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Trabajadores',
                              style: TextStyle(
                                color: Color(0xFF1F4E79),
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const Icon(
                                Icons.close,
                                color: Colors.black,
                                size: 28,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Lista de trabajadores
                        Flexible(
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: trabajadores.length,
                            physics: const BouncingScrollPhysics(),
                            separatorBuilder: (context, index) => const SizedBox(height: 15),
                            itemBuilder: (context, index) {
                              final trabajador = trabajadores[index];

                              return ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                                  child: Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 248, 247, 247),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color.fromARGB(255, 112, 112, 112).withOpacity(0.9),
                                          blurRadius: 25,
                                          spreadRadius: 4,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      children: [
                                        Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                // Avatar con resplandor
                                                Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: const Color.fromARGB(255, 255, 216, 143).withOpacity(0.9),
                                                        blurRadius: 10,
                                                        spreadRadius: 2,
                                                      ),
                                                    ],
                                                  ),
                                                  child: const CircleAvatar(
                                                    radius: 35,
                                                    backgroundImage: AssetImage('assets/images/albañil.png'),
                                                  ),
                                                ),
                                                const SizedBox(width: 15),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        trabajador['nombre'],
                                                        style: const TextStyle(
                                                          color: Color(0xFF1F4E79),
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 22,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        trabajador['oficio'],
                                                        style: TextStyle(
                                                          color: Colors.grey.shade700,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 12),
                                            // Botón Despedir
                                            GestureDetector(
                                              onTap: () {
                                                showConfirmarDespedirModal(context, trabajador['nombre']);
                                              },
                                              child: Container(
                                                width: double.infinity,
                                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(12),
                                                  gradient: const LinearGradient(
                                                    colors: [
                                                      Color(0xFFFFEB3B),
                                                      Color(0xFFFF9800),
                                                    ],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.orangeAccent.withOpacity(0.7),
                                                      blurRadius: 8,
                                                      offset: const Offset(0, 3),
                                                    ),
                                                  ],
                                                ),
                                                child: const Center(
                                                  child: Text(
                                                    "Despedir",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                                                                      ],
                                        ),
                                        // Corazón favorito
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                trabajador['favorito'] = !trabajador['favorito'];
                                              });
                                            },
                                            child: Icon(
                                              trabajador['favorito'] ? Icons.favorite : Icons.favorite_border,
                                              color: const Color.fromARGB(255, 243, 49, 35),
                                              size: 26,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}
