import 'package:flutter/material.dart';
import 'package:integradora/services/api_service.dart';
import 'package:integradora/services/storage_service.dart';
import 'package:integradora/views/widgets/custom_notification.dart';
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
  String emailTrabajador,
  String telefono,
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
            emailTrabajador: emailTrabajador,
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
  final String emailTrabajador;

  const _ProfileContent({
    super.key,
    required this.name,
    required this.edad,
    required this.categoria,
    required this.descripcion,
    required this.image,
    required this.rating,
    required this.experiencia,
    required this.emailTrabajador,
  });

  @override
  State<_ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<_ProfileContent> {
  bool isFavorite = false;
  bool isLoadingFavorite = true;
  String? emailContratista;

  @override
  void initState() {
    super.initState();
    _cargarEstadoFavorito();
  }

  Future<void> _cargarEstadoFavorito() async {
    try {
      final user = await StorageService.getUser();
      if (user != null) {
        emailContratista = user['email'];
        
        // Verificar si ya está en favoritos
        final resultado = await ApiService.verificarFavorito(
          emailContratista!,
          widget.emailTrabajador,
        );
        
        if (resultado['success'] == true) {
          setState(() {
            isFavorite = resultado['esFavorito'] ?? false;
            isLoadingFavorite = false;
          });
        } else {
          setState(() => isLoadingFavorite = false);
        }
      }
    } catch (e) {
      print('Error al verificar favorito: $e');
      setState(() => isLoadingFavorite = false);
    }
  }

  Future<void> _toggleFavorito() async {
    if (emailContratista == null) {
      if (mounted) {
        CustomNotification.showError(
          context,
          'No se pudo obtener el usuario',
        );
      }
      return;
    }

    setState(() => isLoadingFavorite = true);

    try {
      Map<String, dynamic> resultado;
      
      if (isFavorite) {
        // Quitar de favoritos
        resultado = await ApiService.quitarFavorito(
          emailContratista!,
          widget.emailTrabajador,
        );
        
        if (resultado['success'] == true) {
          setState(() {
            isFavorite = false;
            isLoadingFavorite = false;
          });
          
          if (mounted) {
            CustomNotification.showInfo(
              context,
              'Quitado de favoritos',
            );
          }
        }
      } else {
        // Agregar a favoritos
        resultado = await ApiService.agregarFavorito(
          emailContratista!,
          widget.emailTrabajador,
        );
        
        if (resultado['success'] == true) {
          setState(() {
            isFavorite = true;
            isLoadingFavorite = false;
          });
          
          if (mounted) {
            CustomNotification.showSuccess(
              context,
              'Agregado a favoritos',
            );
          }
        }
      }
      
      // Manejar errores
      if (resultado['success'] != true) {
        setState(() => isLoadingFavorite = false);
        if (mounted) {
          CustomNotification.showError(
            context,
            resultado['error'] ?? "Error desconocido",
          );
        }
      }
    } catch (e) {
      setState(() => isLoadingFavorite = false);
      if (mounted) {
        CustomNotification.showError(
          context,
          'Error de red: $e',
        );
      }
    }
  }

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
              bottom: -10,
              right: -10,
              child: isLoadingFavorite
                ? Container(
                    padding: const EdgeInsets.all(12),
                    child: const CircularProgressIndicator(strokeWidth: 3),
                  )
                : IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey.shade400,
                      size: 50,
                    ),
                    onPressed: _toggleFavorito,
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
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.email, color: Colors.grey, size: 16),
            const SizedBox(width: 4),
            Text(
              widget.emailTrabajador,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
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
