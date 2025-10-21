import 'package:flutter/material.dart';
import 'review_card.dart';

void showProfileModal(
  BuildContext context,
  String name,
  int edad,
  String categoria,
  String descripcion,
  String image,
  double rating,
  int experiencia,
  String status,
  Color statusColor,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    ),
    builder: (context) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        builder: (_, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              CircleAvatar(radius: 80, backgroundImage: AssetImage(image)),
              const SizedBox(height: 10),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F4E79),
                ),
              ),
              Text(
                '$categoria  •  $edad años',
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  Text(
                    ' ${rating.toStringAsFixed(1)}  |  $experiencia años exp.',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                descripcion,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 25),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Reviews',
                  style: TextStyle(
                    color: Color(0xFFE67E22),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const ReviewCard(
                nombre: 'Ana López',
                comentario: 'Excelente trabajo y muy profesional.',
                rating: 5,
              ),
              const ReviewCard(
                nombre: 'Carlos Ruiz',
                comentario: 'Muy cumplido y atento, recomendado.',
                rating: 4.5,
              ),
              const ReviewCard(
                nombre: 'María Pérez',
                comentario: 'Buen trabajo pero tardó un poco.',
                rating: 4,
              ),
            ],
          ),
        ),
      );
    },
  );
}
