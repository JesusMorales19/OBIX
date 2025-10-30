import 'package:flutter/material.dart';

class RateEmployeesModal extends StatefulWidget {
  final List<String> employees;

  const RateEmployeesModal({super.key, required this.employees});

  @override
  State<RateEmployeesModal> createState() => _RateEmployeesModalState();
}

class _RateEmployeesModalState extends State<RateEmployeesModal> {
  final Map<String, int> ratings = {};
  final Map<String, bool> showReview = {};
  final Map<String, TextEditingController> reviewControllers = {};
  final int maxChars = 100;

  @override
  void initState() {
    super.initState();
    for (var e in widget.employees) {
      ratings[e] = 3;
      showReview[e] = false;
      reviewControllers[e] = TextEditingController();
      reviewControllers[e]!.addListener(() {
        setState(() {}); // Actualiza el contador al escribir
      });
    }
  }

  Widget _buildStars(String employee) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              ratings[employee] = index + 1;
            });
          },
          child: Icon(
            index < ratings[employee]! ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 28,
          ),
        );
      }),
    );
  }

  Widget _buildEmployeeTile(String employee) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nombre y flecha desplegable
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  employee,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(
                    showReview[employee]!
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 28,
                  ),
                  onPressed: () {
                    setState(() {
                      showReview[employee] = !showReview[employee]!;
                    });
                  },
                )
              ],
            ),
            const SizedBox(height: 4),
            // Estrellas
            _buildStars(employee),
            // Campo de reseña con contador
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                      controller: reviewControllers[employee],
                      maxLength: maxChars,
                      maxLines: 2, // Más compacto
                      decoration: InputDecoration(
                        counterText:
                            '${reviewControllers[employee]!.text.length}/$maxChars',
                        labelText: 'Reseña (opcional)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                      ),
                    ),
                  ],
                ),
              ),
              crossFadeState: showReview[employee]!
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 250),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Calificar Trabajadores',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F4E79)),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 300, // Altura máxima para scroll
              child: SingleChildScrollView(
                child: Column(
                  children: widget.employees
                      .map((e) => _buildEmployeeTile(e))
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  for (var e in widget.employees) {
                    print(
                        '$e: ${ratings[e]} estrellas, reseña: ${reviewControllers[e]!.text}');
                  }
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  backgroundColor: const Color(0xFF1F4E79),
                ),
                child: const Text(
                  'Calificar',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
