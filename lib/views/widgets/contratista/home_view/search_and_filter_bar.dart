import 'package:flutter/material.dart';

class SearchAndFilterBar extends StatelessWidget {
  const SearchAndFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          // ---------- BUSCADOR ----------
          Expanded(
            flex: 3,
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
          // ---------- FILTRO ----------
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFF1F4E79), width: 1),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Todas',
                    style: TextStyle(
                      color: Color(0xFF1F4E79),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.arrow_drop_down, color: Color(0xFF1F4E79)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
