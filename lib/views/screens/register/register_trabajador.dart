import 'dart:io';
import 'package:flutter/material.dart';
import '../../widgets/login_register/background_header.dart';
import '../../widgets/login_register/input_field.dart';
import '../../widgets/login_register/date_field.dart';
import '../../widgets/login_register/build_drop_down.dart';
import '../../widgets/login_register/build_next_buttom.dart';
import '../../widgets/custom_notification.dart';
import '../../widgets/image_picker_modal.dart';
import '../../../models/trabajador_model.dart';
import '../../../services/api_service.dart';
import '../../../utils/image_utils.dart';
import '../login/login_view.dart';

class RegisterTrabajador extends StatefulWidget {
  const RegisterTrabajador({super.key});

  @override
  State<RegisterTrabajador> createState() => _RegisterTrabajadorState();
}

class _RegisterTrabajadorState extends State<RegisterTrabajador> {
  int _currentStep = 0;
  final PageController _pageController = PageController();

  // Controllers de campos
  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final fechaController = TextEditingController();
  final correoController = TextEditingController();
  final telefonoController = TextEditingController();
  final experienciaController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Ocultar/mostrar contraseñas
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Ancho uniforme de campos
  static const double fieldWidth = 320;

  // Estados para errores de validación
  String? _nombreError;
  String? _apellidoError;
  String? _fechaError;
  String? _correoError;
  String? _telefonoError;
  String? _experienciaError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _generoSeleccionado;
  String? _categoriaSeleccionada;
  
  // Lista de categorías desde la base de datos
  List<String> _categorias = [];
  bool _cargandoCategorias = true;
  
  // Imagen de perfil
  File? _imagenSeleccionada;
  String? _fotoBase64;

  // ---------- VALIDACIONES ----------
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool _isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^[0-9]{10}$');
    return phoneRegex.hasMatch(phone.replaceAll(RegExp(r'[\s-]'), ''));
  }

  bool _isValidDate(String date) {
    // Formato esperado: DD/MM/YYYY o YYYY-MM-DD
    final dateRegex = RegExp(r'^\d{2}/\d{2}/\d{4}$|^\d{4}-\d{2}-\d{2}$');
    return dateRegex.hasMatch(date);
  }

  bool _isValidExperience(String experience) {
    final exp = int.tryParse(experience);
    return exp != null && exp >= 0 && exp <= 100;
  }

  bool _isValidPassword(String password) {
    // Debe tener más de 8 caracteres, al menos una mayúscula, una minúscula y un número
    if (password.length < 8) return false;
    if (!password.contains(RegExp(r'[A-Z]'))) return false; // Al menos una mayúscula
    if (!password.contains(RegExp(r'[a-z]'))) return false; // Al menos una minúscula
    if (!password.contains(RegExp(r'[0-9]'))) return false; // Al menos un número
    return true;
  }

  bool get _isStep1Valid {
    return nombreController.text.trim().isNotEmpty &&
        nombreController.text.trim().length >= 2 &&
        apellidoController.text.trim().isNotEmpty &&
        apellidoController.text.trim().length >= 2;
  }

  bool get _isStep2Valid {
    return fechaController.text.trim().isNotEmpty &&
        _isValidDate(fechaController.text.trim()) &&
        correoController.text.trim().isNotEmpty &&
        _isValidEmail(correoController.text.trim()) &&
        _generoSeleccionado != null &&
        _generoSeleccionado!.isNotEmpty &&
        telefonoController.text.trim().isNotEmpty &&
        _isValidPhone(telefonoController.text.trim());
  }

  bool get _isStep3Valid {
    return experienciaController.text.trim().isNotEmpty &&
        _isValidExperience(experienciaController.text.trim()) &&
        _categoriaSeleccionada != null &&
        _categoriaSeleccionada!.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        _isValidPassword(passwordController.text) &&
        confirmPasswordController.text.isNotEmpty &&
        passwordController.text == confirmPasswordController.text;
  }

  void _validateStep1() {
    bool isValid = true;

    // Validar nombre
    if (nombreController.text.trim().isEmpty) {
      setState(() => _nombreError = 'El nombre es requerido');
      isValid = false;
    } else if (nombreController.text.trim().length < 2) {
      setState(() => _nombreError = 'El nombre debe tener al menos 2 caracteres');
      isValid = false;
    } else {
      setState(() => _nombreError = null);
    }

    // Validar apellido
    if (apellidoController.text.trim().isEmpty) {
      setState(() => _apellidoError = 'El apellido es requerido');
      isValid = false;
    } else if (apellidoController.text.trim().length < 2) {
      setState(() => _apellidoError = 'El apellido debe tener al menos 2 caracteres');
      isValid = false;
    } else {
      setState(() => _apellidoError = null);
    }

    if (isValid && _currentStep < 2) {
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _validateStep2() {
    bool isValid = true;

    // Validar fecha
    if (fechaController.text.trim().isEmpty) {
      setState(() => _fechaError = 'La fecha de nacimiento es requerida');
      isValid = false;
    } else if (!_isValidDate(fechaController.text.trim())) {
      setState(() => _fechaError = 'Formato de fecha inválido (DD/MM/YYYY)');
      isValid = false;
    } else {
      setState(() => _fechaError = null);
    }

    // Validar correo
    if (correoController.text.trim().isEmpty) {
      setState(() => _correoError = 'El correo es requerido');
      isValid = false;
    } else if (!_isValidEmail(correoController.text.trim())) {
      setState(() => _correoError = 'Ingresa un correo electrónico válido');
      isValid = false;
    } else {
      setState(() => _correoError = null);
    }

    // Validar género
    if (_generoSeleccionado == null || _generoSeleccionado!.isEmpty) {
      CustomNotification.showError(context, 'Por favor selecciona un género');
      isValid = false;
    }

    // Validar teléfono
    if (telefonoController.text.trim().isEmpty) {
      setState(() => _telefonoError = 'El teléfono es requerido');
      isValid = false;
    } else if (!_isValidPhone(telefonoController.text.trim())) {
      setState(() => _telefonoError = 'Ingresa un teléfono válido (10 dígitos)');
      isValid = false;
    } else {
      setState(() => _telefonoError = null);
    }

    if (isValid && _currentStep < 2) {
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _validateStep3() {
    bool isValid = true;

    // Validar experiencia
    if (experienciaController.text.trim().isEmpty) {
      setState(() => _experienciaError = 'La experiencia es requerida');
      isValid = false;
    } else if (!_isValidExperience(experienciaController.text.trim())) {
      setState(() => _experienciaError = 'Ingresa un número válido (0-100 años)');
      isValid = false;
    } else {
      setState(() => _experienciaError = null);
    }

    // Validar categoría
    if (_categoriaSeleccionada == null || _categoriaSeleccionada!.isEmpty) {
      CustomNotification.showError(context, 'Por favor selecciona una categoría');
      isValid = false;
    }

    // Validar contraseña
    if (passwordController.text.isEmpty) {
      setState(() => _passwordError = 'La contraseña es requerida');
      isValid = false;
    } else if (passwordController.text.length < 8) {
      setState(() => _passwordError = 'La contraseña debe tener más de 8 caracteres');
      isValid = false;
    } else if (!passwordController.text.contains(RegExp(r'[A-Z]'))) {
      setState(() => _passwordError = 'La contraseña debe contener al menos una mayúscula');
      isValid = false;
    } else if (!passwordController.text.contains(RegExp(r'[a-z]'))) {
      setState(() => _passwordError = 'La contraseña debe contener al menos una minúscula');
      isValid = false;
    } else if (!passwordController.text.contains(RegExp(r'[0-9]'))) {
      setState(() => _passwordError = 'La contraseña debe contener al menos un número');
      isValid = false;
    } else {
      setState(() => _passwordError = null);
    }

    // Validar confirmación de contraseña
    if (confirmPasswordController.text.isEmpty) {
      setState(() => _confirmPasswordError = 'Confirma tu contraseña');
      isValid = false;
    } else if (passwordController.text != confirmPasswordController.text) {
      setState(() => _confirmPasswordError = 'Las contraseñas no coinciden');
      isValid = false;
    } else {
      setState(() => _confirmPasswordError = null);
    }

    if (isValid) {
      _registrarTrabajador();
    }
  }

  Future<void> _registrarTrabajador() async {
    // Mostrar indicador de carga
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Crear el modelo de trabajador
      final trabajador = TrabajadorModel(
        nombre: nombreController.text.trim(),
        apellido: apellidoController.text.trim(),
        fechaNacimiento: fechaController.text.trim(),
        email: correoController.text.trim(),
        genero: _generoSeleccionado ?? '',
        telefono: telefonoController.text.trim(),
        experiencia: int.parse(experienciaController.text.trim()),
        categoria: _categoriaSeleccionada ?? '',
        password: passwordController.text,
        fotoBase64: _fotoBase64,
      );

      // Llamar al servicio de API
      final resultado = await ApiService.registrarTrabajador(trabajador);

      // Cerrar el indicador de carga
      if (context.mounted) {
        Navigator.pop(context);
      }

      if (resultado['success'] == true) {
        if (context.mounted) {
          CustomNotification.showSuccess(context, 'Registro exitoso');
          // Esperar un momento y luego redirigir al login
          Future.delayed(const Duration(seconds: 1), () {
            if (context.mounted) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginView()),
                (route) => false,
              );
            }
          });
        }
      } else {
        if (context.mounted) {
          CustomNotification.showError(
            context,
            resultado['error'] ?? 'Error al registrar',
          );
        }
      }
    } catch (e) {
      // Cerrar el indicador de carga
      if (context.mounted) {
        Navigator.pop(context);
        CustomNotification.showError(
          context,
          'Error de conexión. Verifica que el servidor esté corriendo.',
        );
      }
    }
  }

  void _validatePassword(String password) {
    if (password.isEmpty) {
      setState(() => _passwordError = 'La contraseña es requerida');
    } else if (password.length < 8) {
      setState(() => _passwordError = 'La contraseña debe tener más de 8 caracteres');
    } else if (!password.contains(RegExp(r'[A-Z]'))) {
      setState(() => _passwordError = 'La contraseña debe contener al menos una mayúscula');
    } else if (!password.contains(RegExp(r'[a-z]'))) {
      setState(() => _passwordError = 'La contraseña debe contener al menos una minúscula');
    } else if (!password.contains(RegExp(r'[0-9]'))) {
      setState(() => _passwordError = 'La contraseña debe contener al menos un número');
    } else {
      setState(() => _passwordError = null);
    }
  }

  void _nextStep() {
    if (_currentStep == 0) {
      _validateStep1();
    } else if (_currentStep == 1) {
      _validateStep2();
    }
  }

  // Función para mostrar el modal de selección de imagen
  Future<void> _mostrarModalSeleccionImagen() async {
    // Primero verificar y solicitar permisos
    final tienePermisos = await ImageUtils.verificarPermisos();
    
    if (!tienePermisos) {
      final permisosConcedidos = await ImageUtils.solicitarPermisos();
      
      if (!permisosConcedidos) {
        if (context.mounted) {
          CustomNotification.showError(
            context,
            'Se necesitan permisos de cámara y galería para seleccionar una imagen',
          );
          
          // Preguntar si quiere abrir configuración
          final abrirConfig = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Permisos requeridos'),
              content: const Text(
                'Para seleccionar una imagen necesitas permitir el acceso a la cámara y galería. ¿Deseas abrir la configuración?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Abrir configuración'),
                ),
              ],
            ),
          );
          
          if (abrirConfig == true) {
            await ImageUtils.abrirConfiguracion();
          }
        }
        return;
      }
    }

    // Mostrar modal de selección
    if (context.mounted) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => ImagePickerModal(
          onCameraTap: _tomarFoto,
          onGalleryTap: _seleccionarDeGaleria,
        ),
      );
    }
  }

  // Función para tomar foto con la cámara
  Future<void> _tomarFoto() async {
    try {
      final imagen = await ImageUtils.tomarFoto();
      if (imagen != null) {
        final base64 = await ImageUtils.imagenABase64(imagen);
        if (base64 != null && context.mounted) {
          setState(() {
            _imagenSeleccionada = File(imagen.path);
            _fotoBase64 = base64;
          });
        } else {
          if (context.mounted) {
            CustomNotification.showError(context, 'Error al procesar la imagen');
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        CustomNotification.showError(context, 'Error al tomar la foto: $e');
      }
    }
  }

  // Función para seleccionar de la galería
  Future<void> _seleccionarDeGaleria() async {
    try {
      final imagen = await ImageUtils.seleccionarDeGaleria();
      if (imagen != null) {
        final base64 = await ImageUtils.imagenABase64(imagen);
        if (base64 != null && context.mounted) {
          setState(() {
            _imagenSeleccionada = File(imagen.path);
            _fotoBase64 = base64;
          });
        } else {
          if (context.mounted) {
            CustomNotification.showError(context, 'Error al procesar la imagen');
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        CustomNotification.showError(context, 'Error al seleccionar la imagen: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _cargarCategorias();
  }

  Future<void> _cargarCategorias() async {
    setState(() {
      _cargandoCategorias = true;
    });

    try {
      final resultado = await ApiService.getCategorias();
      
      if (resultado['success'] == true && resultado['data'] != null) {
        final categoriasData = resultado['data'] as List;
        final categoriasNombres = categoriasData
            .map((cat) => cat['nombre'] as String)
            .toList();
        
        setState(() {
          _categorias = categoriasNombres;
          _cargandoCategorias = false;
        });
      } else {
        // Si falla, usar categorías por defecto
        setState(() {
          _categorias = ["Electricista", "Albañil", "Plomero"];
          _cargandoCategorias = false;
        });
        if (mounted) {
          CustomNotification.showError(
            context,
            'No se pudieron cargar las categorías. Usando categorías por defecto.',
          );
        }
      }
    } catch (e) {
      // Si hay error, usar categorías por defecto
      setState(() {
        _categorias = ["Electricista", "Albañil", "Plomero"];
        _cargandoCategorias = false;
      });
      if (mounted) {
        CustomNotification.showError(
          context,
          'Error al cargar categorías. Usando categorías por defecto.',
        );
      }
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
                children: [
                  const SizedBox(height: 30),
                  Image.asset('assets/images/logo_obix.png', height: 280),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Card(
                      elevation: 10,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
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
                              _buildStep3(),
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
          "Registro de Trabajador",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFFE67E22),
            fontSize: 34,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Container(width: 600, height: 2, color: Colors.grey[300]),
        const SizedBox(height: 30),
        GestureDetector(
          onTap: _mostrarModalSeleccionImagen,
          child: Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                backgroundImage: _imagenSeleccionada != null
                    ? FileImage(_imagenSeleccionada!)
                    : null,
                child: _imagenSeleccionada == null
                    ? const Icon(Icons.camera_alt, color: Colors.white, size: 55)
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE67E22),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        InputField(
          controller: nombreController,
          hintText: "Nombre",
          icon: Icons.person,
          width: fieldWidth,
          errorText: _nombreError,
          onChanged: (value) {
            if (value.trim().isNotEmpty && value.trim().length >= 2) {
              setState(() => _nombreError = null);
            }
          },
        ),
        const SizedBox(height: 40),
        InputField(
          controller: apellidoController,
          hintText: "Apellido",
          icon: Icons.person_outline,
          width: fieldWidth,
          errorText: _apellidoError,
          onChanged: (value) {
            if (value.trim().isNotEmpty && value.trim().length >= 2) {
              setState(() => _apellidoError = null);
            }
          },
        ),
        const SizedBox(height: 70),
        NextButton(
          text: "Siguiente",
          onPressed: _nextStep,
          enabled: _isStep1Valid,
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      children: [
        const SizedBox(height: 40),
        DateField(
          controller: fechaController,
          hintText: "Fecha de nacimiento (DD/MM/AAAA)",
          icon: Icons.calendar_today,
          width: fieldWidth,
          errorText: _fechaError,
          initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          onChanged: () {
            if (fechaController.text.trim().isNotEmpty) {
              setState(() => _fechaError = null);
            }
          },
        ),
        const SizedBox(height: 40),
        InputField(
          controller: correoController,
          hintText: "Correo",
          icon: Icons.email,
          width: fieldWidth,
          keyboardType: TextInputType.emailAddress,
          errorText: _correoError,
          onChanged: (value) {
            if (value.trim().isNotEmpty && _isValidEmail(value.trim())) {
              setState(() => _correoError = null);
            }
          },
        ),
        const SizedBox(height: 40),
        CustomDropdown(
          label: "Género",
          items: ["Masculino", "Femenino"],
          width: fieldWidth,
          onChanged: (value) {
            setState(() => _generoSeleccionado = value);
          },
        ),
        const SizedBox(height: 40),
        InputField(
          controller: telefonoController,
          hintText: "Teléfono (10 dígitos)",
          icon: Icons.phone,
          width: fieldWidth,
          keyboardType: TextInputType.phone,
          errorText: _telefonoError,
          onChanged: (value) {
            if (value.trim().isNotEmpty && _isValidPhone(value.trim())) {
              setState(() => _telefonoError = null);
            }
          },
        ),
        const SizedBox(height: 70),
        NextButton(
          text: "Siguiente",
          onPressed: _nextStep,
          enabled: _isStep2Valid,
        ),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      children: [
        const SizedBox(height: 40),
        InputField(
          controller: experienciaController,
          hintText: "Experiencia (años)",
          icon: Icons.work,
          width: fieldWidth,
          keyboardType: TextInputType.number,
          errorText: _experienciaError,
          onChanged: (value) {
            if (value.trim().isNotEmpty && _isValidExperience(value.trim())) {
              setState(() => _experienciaError = null);
            }
          },
        ),
        const SizedBox(height: 40),
        _cargandoCategorias
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(),
                ),
              )
            : CustomDropdown(
                label: "Categoría",
                items: _categorias.isEmpty 
                    ? ["Electricista", "Albañil", "Plomero"] 
                    : _categorias,
                width: fieldWidth,
                onChanged: (value) {
                  setState(() => _categoriaSeleccionada = value);
                },
              ),
        const SizedBox(height: 40),
        InputField(
          controller: passwordController,
          hintText: "Contraseña",
          icon: Icons.lock,
          isPassword: true,
          obscureText: _obscurePassword,
          errorText: _passwordError,
          toggleVisibility: () => setState(() => _obscurePassword = !_obscurePassword),
          width: fieldWidth,
          onChanged: (value) {
            _validatePassword(value);
            if (confirmPasswordController.text.isNotEmpty) {
              if (value == confirmPasswordController.text) {
                setState(() => _confirmPasswordError = null);
              } else {
                setState(() => _confirmPasswordError = 'Las contraseñas no coinciden');
              }
            }
          },
        ),
        const SizedBox(height: 40),
        InputField(
          controller: confirmPasswordController,
          hintText: "Confirmar contraseña",
          icon: Icons.lock_outline,
          isPassword: true,
          obscureText: _obscureConfirmPassword,
          errorText: _confirmPasswordError,
          toggleVisibility: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
          width: fieldWidth,
          onChanged: (value) {
            if (value == passwordController.text) {
              setState(() => _confirmPasswordError = null);
            } else {
              setState(() => _confirmPasswordError = 'Las contraseñas no coinciden');
            }
          },
        ),
        const SizedBox(height: 70),
        NextButton(
          text: "Registrar",
          onPressed: _validateStep3,
          enabled: _isStep3Valid,
        ),
      ],
    );
  }
}
