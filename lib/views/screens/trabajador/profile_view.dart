import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:integradora/views/widgets/ChangePasswordDialog.dart';
import 'package:integradora/views/widgets/trabajador/profile_view/reviews_modal.dart';
import 'package:integradora/views/widgets/edit_dialog.dart';
import '../login/login_view.dart'; // Asegúrate que la ruta sea correcta
import '../../widgets/custom_bottom_nav.dart';
import '../../widgets/header_bar.dart';
import '../../widgets/logout_dialog.dart'; // Tu modal de confirmación de logout

class ProfileViewEmployees extends StatefulWidget {
  const ProfileViewEmployees({Key? key}) : super(key: key);

  @override
  State<ProfileViewEmployees> createState() => _ProfileViewEmployeesState();
}

class _ProfileViewEmployeesState extends State<ProfileViewEmployees> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  // Datos del perfil
  String email = 'jesuhernan232@gmail.com';
  String telefono = '6182988791';
  String descripcion =
      'Soy maestro albañil y sé hacer de todo, tengo 10 años de experiencia';
  int edad = 38;
  DateTime fechaNacimiento = DateTime(1985, 6, 28);
  double calificacion = 4.0;


  // 🔹 Función para seleccionar imagen de perfil
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // 🔹 Función para mostrar estrellas de calificación
  Widget _buildStars() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < calificacion ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 18,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    String fechaStr =
        '${fechaNacimiento.day.toString().padLeft(2, '0')}/${fechaNacimiento.month.toString().padLeft(2, '0')}/${fechaNacimiento.year}';

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const CustomBottomNav(role: 'trabajador', currentIndex: 2),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const HeaderBar(tipoUsuario: 'trabajador'),
              const SizedBox(height: 15),
              const Divider(
                  color: Colors.black26, thickness: 1, indent: 20, endIndent: 20),
              const SizedBox(height: 20),
              const Text('Mi Perfil',
                  style: TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black)),
              const SizedBox(height: 25),

              // 🔹 Card principal (perfil)
              Container(
                width: MediaQuery.of(context).size.width * 0.90,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 3))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Stack(
                              children: [
                                GestureDetector(
                                  onTap: _pickImage,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: const Color(0xFF1F4E79), width: 5),
                                    ),
                                    child: CircleAvatar(
                                      radius: 60,
                                      backgroundImage: _image != null
                                          ? FileImage(_image!)
                                          : const AssetImage(
                                                  'assets/images/albañil.png')
                                              as ImageProvider,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.orange, shape: BoxShape.circle),
                                    padding: const EdgeInsets.all(5),
                                    child:
                                        const Icon(Icons.edit, color: Colors.white, size: 18),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            const Text('Electricista',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                          ],
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Center(
                                child: Text('danielestrada123',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1F4E79))),
                              ),
                              const SizedBox(height: 6),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    const TextSpan(text: 'Nombre: '),
                                    const TextSpan(
                                        text: 'Daniel Estrada',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text('Fecha de nacimiento: $fechaStr',
                                  style: const TextStyle(fontSize: 14, color: Colors.black)),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Edad: $edad años',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Colors.black)),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      _buildStars(),
                                      TextButton(
                                        onPressed: () {
                                          ReviewsModal.show(context);
                                        },
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          minimumSize: const Size(50, 20),
                                        ),
                                        child: const Text(
                                          'ver reseñas',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text('Miembro desde 2024',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 🔹 Datos de contacto
              Container(
                width: MediaQuery.of(context).size.width * 0.90,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 3))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.message_outlined, color: Colors.blue),
                        SizedBox(width: 8),
                        Text('Datos de Contacto',
                            style:
                                TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text('Email: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Expanded(
                            child: Text(email, style: const TextStyle(color: Colors.grey))),
                        IconButton(
                          icon: const Icon(Icons.edit, size: 18),
                          onPressed: () {
                            EditDialog.show(context, 'Email', email, (value) {
                              setState(() {
                                email = value;
                              });
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text('Teléfono: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Expanded(
                            child: Text(telefono, style: const TextStyle(color: Colors.grey))),
                        IconButton(
                          icon: const Icon(Icons.edit, size: 18),
                          onPressed: () {
                            EditDialog.show(context, 'Teléfono', telefono, (value) {
                              setState(() {
                                telefono = value;
                              });
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 🔹 Descripción
              Container(
                width: MediaQuery.of(context).size.width * 0.90,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 3))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.description, color: Colors.blue),
                        SizedBox(width: 8),
                        Text('Descripción',
                            style:
                                TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                            child:
                                Text(descripcion, style: const TextStyle(color: Colors.grey))),
                        IconButton(
                          icon: const Icon(Icons.edit, size: 18),
                          onPressed: () {
                            EditDialog.show(context, 'Descripción', descripcion, (value) {
                              setState(() {
                                descripcion = value;
                              });
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 🔹 Configuración de cuenta / Logout
              Container(
                width: MediaQuery.of(context).size.width * 0.90,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 3))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Configuración de Cuenta',
                        style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.settings, color: Colors.grey),
                      title: const Text('Cambiar contraseña'),
                      onTap: () {
                        ChangePasswordDialogModern.show(context, (newPassword){
                          print('Nueva contraseña: $newPassword');
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          LogoutDialog.show(context, () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginView()),
                              (route) => false,
                            );
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 12),
                        ),
                        child: const Text('Cerrar sesión',
                            style: TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
