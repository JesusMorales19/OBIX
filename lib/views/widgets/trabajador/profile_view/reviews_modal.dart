import 'package:flutter/material.dart';

class ReviewsModal {
  // Paleta del usuario
  static const Color primaryYellow = Color(0xFFF5B400); // F5B400
  static const Color secondaryOrange = Color(0xFFE67E22); // E67E22
  static const Color whiteColor = Color(0xFFFFFFFF); // FFFFFF
  static const Color lightGray = Color(0xFFEAEAEA); // EAEAEA (usé EAEAEA como gris claro)

  static void show(BuildContext context) {
    final List<Map<String, dynamic>> reviews = [
      {
        'contratista': 'Juan Pérez',
        'resena': 'Excelente trabajo, muy puntual y profesional.',
        'calificacion': 5.0
      },
      {
        'contratista': 'María Gómez',
        'resena': 'Buen trabajo, aunque tardó un poco más de lo esperado.',
        'calificacion': 4.0
      },
      {
        'contratista': 'Carlos López',
        'resena': 'Trabajo aceptable, pero podría mejorar la limpieza del área.',
        'calificacion': 3.5
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.62,
          minChildSize: 0.4,
          maxChildSize: 0.92,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 15,
                    offset: const Offset(0, -5),
                  )
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: Column(
                children: [
                  // Handle
                  Container(
                    width: 42,
                    height: 6,
                    decoration: BoxDecoration(
                      color: lightGray,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Título y promedio (ejemplo)
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Reseñas del trabajador',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                _buildStars(4.2, size: 16), // ejemplo promedio
                                const SizedBox(width: 8),
                                Text(
                                  '4.2',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '(3 reseñas)',
                                  style: TextStyle(color: Colors.grey[500], fontSize: 13),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Botón cerrar rápido
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: lightGray,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.close, size: 18, color: Colors.grey[700]),
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Lista de reseñas
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: reviews.length,
                      padding: const EdgeInsets.only(bottom: 20, top: 6),
                      itemBuilder: (context, index) {
                        final r = reviews[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: lightGray.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Avatar con iniciales
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: primaryYellow,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.06),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    )
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    _initials(r['contratista']),
                                    style: const TextStyle(
                                      color: whiteColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 12),

                              // Contenido
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Nombre y calificación
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            r['contratista'],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        _buildStars(r['calificacion'], size: 16),
                                      ],
                                    ),

                                    const SizedBox(height: 6),

                                    // Texto de la reseña
                                    Text(
                                      r['resena'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[800],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Helpers

  static String _initials(String name) {
    final parts = name.split(' ');
    if (parts.length == 1) {
      return parts[0].substring(0, 1).toUpperCase();
    } else {
      return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
    }
  }

  // Construye estrellas (rellenas según el valor)
  static Widget _buildStars(double rating, {double size = 18}) {
    final fullStars = rating.floor();
    final hasHalf = (rating - fullStars) >= 0.5;
    final List<Widget> stars = [];

    for (var i = 0; i < 5; i++) {
      if (i < fullStars) {
        stars.add(Icon(Icons.star, size: size, color: primaryYellow));
      } else if (i == fullStars && hasHalf) {
        stars.add(Icon(Icons.star_half, size: size, color: primaryYellow));
      } else {
        stars.add(Icon(Icons.star_border, size: size, color: primaryYellow.withOpacity(0.7)));
      }
    }

    return Row(mainAxisSize: MainAxisSize.min, children: stars);
  }
}
