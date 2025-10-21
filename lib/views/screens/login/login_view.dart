import 'package:flutter/material.dart';
import '../register/roles_view.dart';
import '../contratista/home_view.dart';
import '../trabajador/home_view.dart';

// ---------- IMPORTACIÓN DE COMPONENTES ----------
import '../../widgets/login_register/background_header.dart';
import '../../widgets/login_register/input_field.dart';
import '../../widgets/login_register/gradient_buttom.dart';
import '../../widgets/login_register/register_redirect_text.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // 🔹 Usuarios de prueba
  final Map<String, Map<String, String>> usuariosPrueba = {
    "contratista": {
      "email": "contratista@obix.com",
      "password": "12345",
    },
    "trabajador": {
      "email": "trabajador@obix.com",
      "password": "12345",
    },
  };

  // 🔹 Controladores
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // 🔹 Estado para mostrar/ocultar contraseña
  bool _obscureText = true;

  // ---------- FUNCIÓN LOGIN ----------
  void _handleLogin() {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingresa tus datos.')),
      );
      return;
    }

    if (email == usuariosPrueba["contratista"]!["email"] &&
        password == usuariosPrueba["contratista"]!["password"]) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeViewContractor()),
      );
    } else if (email == usuariosPrueba["trabajador"]!["email"] &&
        password == usuariosPrueba["trabajador"]!["password"]) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeViewEmployee()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Credenciales inválidas.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ---------- FONDO PRINCIPAL ----------
          Container(color: const Color(0xFFF9FAFB)),

          // ---------- FONDO AZUL SUPERIOR ----------
          const BackgroundHeader(),

          // ---------- CONTENIDO ----------
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/logo_obix.png',
                    height: 280,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 400,
                    child: Card(
                      elevation: 8,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(25),
                        child: Column(
                          children: [
                            const Text(
                              "Welcome!!",
                              style: TextStyle(
                                color: Color(0xFFE67E22),
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 60),

                            // ---------- INPUT EMAIL ----------
                            InputField(
                              controller: _emailController,
                              hintText: 'User/email',
                              icon: Icons.person_outline,
                            ),
                            const SizedBox(height: 60),

                            // ---------- INPUT PASSWORD ----------
                            InputField(
                              controller: _passwordController,
                              hintText: 'Password',
                              icon: Icons.lock_outline,
                              isPassword: true,
                              obscureText: _obscureText,
                              toggleVisibility: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                            const SizedBox(height: 60),

                            // ---------- BOTÓN LOGIN ----------
                            GradientButton(
                              text: "LOGIN",
                              onPressed: _handleLogin,
                            ),
                            const SizedBox(height: 60),

                            // ---------- TEXTO REGISTRO ----------
                            RegisterRedirectText(
                              text: "Don’t have account? ",
                              actionText: "Register",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const RolesView(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
