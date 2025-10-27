import 'package:flutter/material.dart';

class SearchAndFilterBar extends StatelessWidget {
  const SearchAndFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar...',
                hintStyle: const TextStyle(color: Color(0xFF1F4E79), fontWeight: FontWeight.bold),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF1F4E79)),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: Color(0xFF1F4E79), width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: Color(0xFF1F4E79), width: 2),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 1,
            child: DropdownButtonFormField<String>(
              dropdownColor: Colors.white,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: Color(0xFF1F4E79), width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: Color(0xFF1F4E79), width: 2),
                ),
              ),
              hint: const Text(
                'Selecciona',
                style: TextStyle(color: Color(0xFF1F4E79), fontWeight: FontWeight.bold),
              ),
              items: const [
                DropdownMenuItem(
                    value: 'op1',
                    child: Text('Opción 1',
                        style: TextStyle(color: Color(0xFF1F4E79)))),
                DropdownMenuItem(
                    value: 'op2',
                    child: Text('Opción 2',
                        style: TextStyle(color: Color(0xFF1F4E79)))),
              ],
              onChanged: (value) {},
            ),
          ),
        ],
      ),
    );
  }
}
