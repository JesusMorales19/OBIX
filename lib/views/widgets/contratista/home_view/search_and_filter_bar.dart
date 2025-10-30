import 'package:flutter/material.dart';

class SearchAndFilterBar extends StatefulWidget {
  const SearchAndFilterBar({super.key});

  @override
  State<SearchAndFilterBar> createState() => _SearchAndFilterBarState();
}

class _SearchAndFilterBarState extends State<SearchAndFilterBar> {
  String selectedOption = 'Todas'; // Valor por defecto

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          // ---------- BUSCADOR ----------
          Expanded(
            flex: 2,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar......',
                hintStyle: const TextStyle(
                  color: Color(0xFF1F4E79),
                  fontWeight: FontWeight.bold,
                ),
                prefixIcon:
                    const Icon(Icons.search, color: Color(0xFF1F4E79), size: 40),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide:
                      const BorderSide(color: Color(0xFF1F4E79), width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide:
                      const BorderSide(color: Color(0xFF1F4E79), width: 1),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // ---------- BOTÓN DESPLEGABLE ----------
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFF1F4E79), width: 1),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedOption,
                  icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF1F4E79)),
                  items: <String>['Todas', 'Favoritos'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(
                          color: Color(0xFF1F4E79),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedOption = newValue!;
                    });

                    // Si selecciona Favoritos, navegar a la pantalla correspondiente
                    if (selectedOption == 'Favoritos') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FavoritosScreen()),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------ PANTALLA FAVORITOS ------------------
class FavoritosScreen extends StatelessWidget {
  const FavoritosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
        backgroundColor: const Color(0xFF1F4E79),
      ),
      body: const Center(
        child: Text(
          'Aquí van tus trabajadores favoritos',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
