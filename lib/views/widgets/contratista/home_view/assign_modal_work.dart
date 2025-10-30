import 'package:flutter/material.dart';

class AsignarTrabajoModal extends StatefulWidget {
  final String trabajadorNombre;

  const AsignarTrabajoModal({super.key, required this.trabajadorNombre});

  @override
  State<AsignarTrabajoModal> createState() => _AsignarTrabajoModalState();
}

class _AsignarTrabajoModalState extends State<AsignarTrabajoModal> {
  String selectedCategory = 'Corto plazo';

  final Map<String, List<Map<String, dynamic>>> trabajos = {
    'Corto plazo': [
      {'title': 'Remodelación de baño', 'ubicacion': 'Monterrey', 'pago': '\$3,000'},
      {'title': 'Pintura interior', 'ubicacion': 'Guadalajara', 'pago': '\$2,000'},
      {'title': 'Proyecto de pavimentación', 'ubicacion': 'CDMX', 'pago': '\$100,000'},
      {'title': 'Proyecto de pavimentación', 'ubicacion': 'CDMX', 'pago': '\$100,000'},
      {'title': 'Remodelación de baño', 'ubicacion': 'Monterrey', 'pago': '\$3,000'},
      {'title': 'Pintura interior', 'ubicacion': 'Guadalajara', 'pago': '\$2,000'},
      {'title': 'Proyecto de pavimentación', 'ubicacion': 'CDMX', 'pago': '\$100,000'},
      {'title': 'Proyecto de pavimentación', 'ubicacion': 'CDMX', 'pago': '\$100,000'},
    ],
    'Largo plazo': [
      {'title': 'Construcción de casa completa', 'ubicacion': 'Puebla', 'pago': '\$50,000'},
      {'title': 'Proyecto de pavimentación', 'ubicacion': 'CDMX', 'pago': '\$100,000'},
      {'title': 'Proyecto de pavimentación', 'ubicacion': 'CDMX', 'pago': '\$100,000'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white, // fondo blanco
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Asignar a ${widget.trabajadorNombre}',
              style: const TextStyle(
                color: Color(0xFF1F4E79),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // Filtro de categoría
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: ['Corto plazo', 'Largo plazo'].map((cat) {
                final bool isSelected = cat == selectedCategory;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    backgroundColor: Colors.grey.shade200,
                    selectedColor: const Color(0xFFE67E22).withOpacity(0.2),
                    labelStyle: TextStyle(
                        color: isSelected ? const Color(0xFFE67E22) : Colors.black87,
                        fontWeight: FontWeight.bold),
                    onSelected: (selected) {
                      setState(() {
                        selectedCategory = cat;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            // Lista de trabajos filtrados
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: trabajos[selectedCategory]?.length ?? 0,
                itemBuilder: (context, index) {
                  final trabajo = trabajos[selectedCategory]![index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 3,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      title: Text(trabajo['title']!,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Color(0xFF1F4E79))),
                      subtitle: Text('${trabajo['ubicacion']} - ${trabajo['pago']}'),
                      trailing: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                'Has asignado a ${widget.trabajadorNombre} a ${trabajo['title']}'),
                            backgroundColor: const Color(0xFFE67E22),
                          ));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF5B400),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Asignar',
                          style: TextStyle(color: Colors.white),
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
    );
  }
}

// Función para llamar el modal desde cualquier widget
void showAsignarTrabajoModal(BuildContext context, String nombreTrabajador) {
  showDialog(
    context: context,
    builder: (context) => AsignarTrabajoModal(trabajadorNombre: nombreTrabajador),
  );
}
