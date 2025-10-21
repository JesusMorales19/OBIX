import 'package:flutter/material.dart';
import '../../widgets/login_register/background_header.dart';
import '../../widgets/login_register/input_field.dart';
import '../../widgets/login_register/build_drop_down.dart';
import '../../widgets/login_register/build_next_buttom.dart';

class RegisterContratista extends StatefulWidget {
  const RegisterContratista({super.key});

  @override
  State<RegisterContratista> createState() => _RegisterContratistaState();
}

class _RegisterContratistaState extends State<RegisterContratista> {
  int _currentStep = 0;
  final PageController _pageController = PageController();

  // Controllers de los campos
  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final fechaController = TextEditingController();
  final correoController = TextEditingController();
  final telefonoController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Ocultar/mostrar contraseñas
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Ancho uniforme para todos los campos
  static const double fieldWidth = 320;

  void _nextStep() {
    if (_currentStep < 1) {
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(color: const Color(0xFFF9FAFB)),
          const BackgroundHeader(),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  Image.asset('assets/images/logo_obix.png', height: 280),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Card(
                      elevation: 10,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(25),
                        child: SizedBox(
                          height: 600,
                          child: PageView(
                            controller: _pageController,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              _buildStep1(),
                              _buildStep2(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep1() {
    return Column(
      children: [
        const Text(
          "Registro de Contratista",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFFE67E22),
            fontSize: 34,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Container(width: 600, height: 2, color: Colors.grey[300]),
        const SizedBox(height: 20),
        const CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey,
          child: Icon(Icons.camera_alt, color: Colors.white, size: 55),
        ),
        const SizedBox(height: 20),
        InputField(
          controller: nombreController,
          hintText: "Nombre",
          icon: Icons.person,
          width: fieldWidth,
        ),
        const SizedBox(height: 20),
        InputField(
          controller: apellidoController,
          hintText: "Apellido",
          icon: Icons.person_outline,
          width: fieldWidth,
        ),
        const SizedBox(height: 20),
        InputField(
          controller: fechaController,
          hintText: "Fecha de Nacimiento",
          icon: Icons.calendar_today,
          width: fieldWidth,
        ),
        const SizedBox(height: 40),
        NextButton(
          text: "Siguiente",
          onPressed: _nextStep,
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      children: [
        InputField(
          controller: correoController,
          hintText: "Correo",
          icon: Icons.email,
          width: fieldWidth,
        ),
        const SizedBox(height: 30),
        CustomDropdown(
          label: "Género",
          items: ["Masculino", "Femenino"],
          width: fieldWidth,
        ),
        const SizedBox(height: 30),
        InputField(
          controller: telefonoController,
          hintText: "Teléfono",
          icon: Icons.phone,
          width: fieldWidth,
        ),
        const SizedBox(height: 30),
        InputField(
          controller: passwordController,
          hintText: "Contraseña",
          icon: Icons.lock,
          isPassword: true,
          obscureText: _obscurePassword,
          toggleVisibility: () => setState(() => _obscurePassword = !_obscurePassword),
          width: fieldWidth,
        ),
        const SizedBox(height: 30),
        InputField(
          controller: confirmPasswordController,
          hintText: "Confirmar contraseña",
          icon: Icons.lock_outline,
          isPassword: true,
          obscureText: _obscureConfirmPassword,
          toggleVisibility: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
          width: fieldWidth,
        ),
        const SizedBox(height: 60),
        NextButton(
          text: "Registrar",
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Registro completado ✅')),
            );
          },
        ),
      ],
    );
  }
}
