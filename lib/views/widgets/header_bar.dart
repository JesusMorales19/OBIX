import 'dart:ui';
import 'package:flutter/material.dart';
import '../widgets/notification_card.dart';
import '../widgets/notification_card_with_rating.dart';
import '../widgets/notification_button.dart';

class HeaderBar extends StatelessWidget {
  final String tipoUsuario;

  const HeaderBar({super.key, required this.tipoUsuario});

  void _showFullScreenNotifications(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withOpacity(0.2),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        final notificaciones = tipoUsuario == 'contratista'
            ? _notificacionesContratista()
            : _notificacionesTrabajador();

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                child: Container(color: Colors.black.withOpacity(0.55)),
              ),
              SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset('assets/images/Casa.png', height: 50),
                          Image.asset('assets/images/obix.png', height: 50),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Image.asset(
                              'assets/images/notificacion.png',
                              height: 40,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      Expanded(
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: notificaciones.length,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: notificaciones[index],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static List<Widget> _notificacionesContratista() => [
        NotificationCard(
          nombre: 'Contratista: JESUS MORALES',
          descripcion:
              'Se interesó en el proyecto “Remodelación Centro Histórico”.',
          botones: [
            NotificationButton(text: 'Aceptar'),
            NotificationButton(text: 'Ver Perfil'),
          ],
        ),
        const NotificationCardWithRating(
          nombre: 'Contratista: JESUS MORALES',
          descripcion:
              'El trabajador canceló su instancia del proyecto “Remodelación Centro Histórico”.',
        ),
      ];

  static List<Widget> _notificacionesTrabajador() => [
        NotificationCard(
          nombre: 'Trabajador: JESUS MORALES',
          descripcion:
              'Aceptó tu solicitud para el proyecto “Remodelación Centro Histórico”.',
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 15, top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset('assets/images/Casa.png', height: 50),
          Image.asset('assets/images/obix.png', height: 50),
          GestureDetector(
            onTap: () => _showFullScreenNotifications(context),
            child: Image.asset('assets/images/notificacion.png', height: 40),
          ),
        ],
      ),
    );
  }
}
