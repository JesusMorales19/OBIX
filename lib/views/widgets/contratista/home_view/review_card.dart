import 'package:flutter/material.dart';

class ReviewCard extends StatelessWidget {
  final String nombre;
  final String comentario;
  final double rating;

  const ReviewCard({
    super.key,
    required this.nombre,
    required this.comentario,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.account_circle, size: 35, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nombre,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: List.generate(
                    rating.floor(),
                    (index) => const Icon(Icons.star,
                        color: Colors.amber, size: 14),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  comentario,
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
