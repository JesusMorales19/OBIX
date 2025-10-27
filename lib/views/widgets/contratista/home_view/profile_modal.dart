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
          child: _ProfileContent(
            name: name,
            edad: edad,
            categoria: categoria,
            descripcion: descripcion,
            image: image,
            rating: rating,
            experiencia: experiencia,
          ),
        ),
      );
    },
  );
}

class _ProfileContent extends StatefulWidget {
  final String name;
  final int edad;
  final String categoria;
  final String descripcion;
  final String image;
  final double rating;
  final int experiencia;

  const _ProfileContent({
    super.key,
    required this.name,
    required this.edad,
    required this.categoria,
    required this.descripcion,
    required this.image,
    required this.rating,
    required this.experiencia,
  });

  @override
  State<_ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<_ProfileContent> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Column(
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
        Stack(
          clipBehavior: Clip.none, // permite que el corazón sobresalga
          children: [
            CircleAvatar(radius: 80, backgroundImage: AssetImage(widget.image)),
            Positioned(
              bottom: -10, // más abajo
              right: -10,  // más a la derecha
              child: IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.grey,
                  size: 50, // tamaño grande
                ),
                onPressed: () {
                  setState(() {
                    isFavorite = !isFavorite;
                    // Aquí después puedes llamar a tu backend para guardar el favorito
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          widget.name,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F4E79),
          ),
        ),
        Text(
          '${widget.categoria}  •  ${widget.edad} años',
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 20),
            Text(
              ' ${widget.rating.toStringAsFixed(1)}  |  ${widget.experiencia} años exp.',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Text(
          widget.descripcion,
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
    );
  }
}
