import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/contratista_model.dart';
import '../models/trabajador_model.dart';
import '../models/trabajo_largo_model.dart';
import '../models/trabajo_corto_model.dart'; // Added import for TrabajoCortoModel
import 'config_service.dart';

class ApiService {
  // La URL base se obtiene de ConfigService
  static Future<String> get baseUrl async => await ConfigService.getBaseUrl();

  // Función auxiliar para normalizar la URL base
  static String _normalizeBaseUrl(String urlBase) {
    // Asegurar que la URL base termine en /api
    if (!urlBase.endsWith('/api')) {
      if (urlBase.endsWith('/')) {
        urlBase = '${urlBase}api';
      } else {
        urlBase = '$urlBase/api';
      }
    }
    return urlBase;
  }

  // Función auxiliar para hacer peticiones GET
  static Future<Map<String, dynamic>> _getRequest(
    String endpoint,
    Map<String, String> params,
  ) async {
    try {
      var urlBase = await baseUrl;
      urlBase = _normalizeBaseUrl(urlBase);
      
      // Asegurar que el endpoint comience con /
      final normalizedEndpoint = endpoint.startsWith('/') ? endpoint : '/$endpoint';
      
      // Construir URL con parámetros query
      final uri = Uri.parse('$urlBase$normalizedEndpoint').replace(queryParameters: params);
      
      print('🌐 GET URL Completa: $uri');
      print('📦 Parámetros: $params');
      
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Tiempo de espera agotado');
        },
      );

      print('📥 GET Respuesta - Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'success': false,
          'error': 'Error del servidor: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('❌ Error en _getRequest: $e');
      return {
        'success': false,
        'error': 'Error de red: ${e.toString()}',
      };
    }
  }

  // Función auxiliar para hacer peticiones POST/PUT
  static Future<Map<String, dynamic>> _postRequest(
    String endpoint,
    Map<String, dynamic> body, {
    bool isPut = false,
  }) async {
    try {
      var urlBase = await baseUrl;
      urlBase = _normalizeBaseUrl(urlBase);
      
      // Asegurar que el endpoint comience con /
      final normalizedEndpoint = endpoint.startsWith('/') ? endpoint : '/$endpoint';
      final url = Uri.parse('$urlBase$normalizedEndpoint');
      
      print('🌐 URL Base: $urlBase');
      print('🌐 Endpoint: $normalizedEndpoint');
      print('🌐 URL Completa: $url');
      print('📦 Datos enviados: ${jsonEncode(body)}');
      
      final response = isPut 
        ? await http.put(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(body),
          ).timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Tiempo de espera agotado. Verifica que el servidor esté corriendo.');
            },
          )
        : await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Tiempo de espera agotado. Verifica que el servidor esté corriendo.');
        },
      );

      print('📥 Respuesta recibida - Status: ${response.statusCode}');
      print('📄 Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
        final responseData = jsonDecode(response.body);
        return {
            'success': responseData['success'] ?? true,
          'data': responseData,
            'error': responseData['error'],
          };
        } catch (e) {
          // Si la respuesta no es JSON válido
          return {
            'success': false,
            'error': 'El servidor respondió con un formato inesperado. Verifica que el servidor backend esté corriendo correctamente.',
        };
        }
      } else {
        // Intentar parsear como JSON, pero si falla, mostrar el error HTTP
        try {
        final responseData = jsonDecode(response.body);
        return {
          'success': false,
          'error': responseData['error'] ?? responseData['message'] ?? 'Error desconocido',
        };
        } catch (e) {
          // Si la respuesta es HTML (como un 404 de Flask/Express)
          if (response.body.contains('<!doctype html>') || response.body.contains('<html')) {
            return {
              'success': false,
              'error': 'Error ${response.statusCode}: La ruta no fue encontrada en el servidor.\n\n'
                  'Verifica que:\n'
                  '1. El servidor backend esté corriendo (cd backend && npm start)\n'
                  '2. La URL sea correcta: $url\n'
                  '3. La ruta /api/register/contratista exista en el servidor',
            };
          }
          return {
            'success': false,
            'error': 'Error ${response.statusCode}: ${response.body}',
          };
        }
      }
    } catch (e) {
      print('❌ Error de conexión: $e');
      String errorMessage = 'Error de conexión';
      
      if (e.toString().contains('Failed host lookup') || 
          e.toString().contains('Failed to fetch') ||
          e.toString().contains('SocketException')) {
        errorMessage = 'No se pudo conectar al servidor.\n\n'
            'Verifica que:\n'
            '1. El servidor backend esté corriendo (cd backend && npm start)\n'
            '2. La URL sea correcta para tu plataforma\n'
            '3. No haya problemas de red o firewall';
      } else if (e.toString().contains('Timeout')) {
        errorMessage = 'Tiempo de espera agotado.\n\n'
            'El servidor no respondió a tiempo.\n'
            'Verifica que el servidor esté corriendo.';
      } else {
        errorMessage = 'Error: ${e.toString()}\n\n'
            'Verifica que el servidor backend esté corriendo en el puerto 3000.';
      }
      
      return {
        'success': false,
        'error': errorMessage,
      };
    }
  }

  // Registrar contratista
  static Future<Map<String, dynamic>> registrarContratista(
    ContratistaModel contratista,
  ) async {
    return await _postRequest('/register/contratista', contratista.toJson());
  }

  // Registrar trabajador
  static Future<Map<String, dynamic>> registrarTrabajador(
    TrabajadorModel trabajador,
  ) async {
    return await _postRequest('/register/trabajador', trabajador.toJson());
  }

  // Login - permite usar email o username
  // El backend detecta automáticamente el tipo de usuario
  static Future<Map<String, dynamic>> login(
    String emailOrUsername,
    String password,
  ) async {
    return await _postRequest('/auth/login', {
      'emailOrUsername': emailOrUsername,
      'password': password,
    });
  }

  // Verificar token JWT
  static Future<Map<String, dynamic>> verifyToken(String token) async {
    try {
      var urlBase = await baseUrl;
      urlBase = _normalizeBaseUrl(urlBase);
      final url = Uri.parse('$urlBase/auth/verify');
      
      print('🌐 URL Base: $urlBase');
      print('🌐 Verificando token: $url');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Tiempo de espera agotado');
        },
      );

      print('📥 Respuesta verificación - Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {
          'success': true,
          'data': responseData,
        };
      } else {
        final responseData = jsonDecode(response.body);
        return {
          'success': false,
          'error': responseData['error'] ?? 'Error al verificar token',
        };
      }
    } catch (e) {
      print('❌ Error al verificar token: $e');
      return {
        'success': false,
        'error': 'Error de conexión: ${e.toString()}',
      };
    }
  }

  // Obtener categorías
  static Future<Map<String, dynamic>> getCategorias() async {
    try {
      var urlBase = await baseUrl;
      urlBase = _normalizeBaseUrl(urlBase);
      final url = Uri.parse('$urlBase/categorias');
      
      print('🌐 URL Base: $urlBase');
      print('🌐 Obteniendo categorías desde: $url');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Tiempo de espera agotado');
        },
      );

      print('📥 Respuesta categorías - Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {
          'success': true,
          'data': responseData['data'] ?? [],
        };
      } else {
        final responseData = jsonDecode(response.body);
        return {
          'success': false,
          'error': responseData['error'] ?? 'Error al obtener categorías',
        };
      }
    } catch (e) {
      print('❌ Error al obtener categorías: $e');
      return {
        'success': false,
        'error': 'Error de conexión: ${e.toString()}',
        'data': [],
      };
    }
  }

  // ========== FAVORITOS ==========

  /// Agregar trabajador a favoritos
  static Future<Map<String, dynamic>> agregarFavorito(
    String emailContratista,
    String emailTrabajador,
  ) async {
    return await _postRequest('/favoritos/agregar', {
      'emailContratista': emailContratista,
      'emailTrabajador': emailTrabajador,
    });
  }

  /// Quitar trabajador de favoritos
  static Future<Map<String, dynamic>> quitarFavorito(
    String emailContratista,
    String emailTrabajador,
  ) async {
    try {
      var urlBase = await baseUrl;
      urlBase = _normalizeBaseUrl(urlBase);

      final response = await http.delete(
        Uri.parse('$urlBase/favoritos/quitar'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'emailContratista': emailContratista,
          'emailTrabajador': emailTrabajador,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'success': false,
          'error': 'Error al quitar favorito: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Error de red: $e',
      };
    }
  }

  /// Verificar si un trabajador está en favoritos
  static Future<Map<String, dynamic>> verificarFavorito(
    String emailContratista,
    String emailTrabajador,
  ) async {
    return await _getRequest('/favoritos/verificar', {
      'emailContratista': emailContratista,
      'emailTrabajador': emailTrabajador,
    });
  }

  /// Listar todos los favoritos de un contratista
  static Future<Map<String, dynamic>> listarFavoritos(
    String emailContratista,
  ) async {
    return await _getRequest('/favoritos/listar', {
      'emailContratista': emailContratista,
    });
  }

  // ========== TRABAJOS DE LARGO PLAZO ==========

  /// Registrar un nuevo trabajo de largo plazo
  static Future<Map<String, dynamic>> registrarTrabajoLargoPlazo(
    TrabajoLargoModel trabajo,
  ) async {
    return await _postRequest(
      '/trabajos-largo-plazo/registrar',
      trabajo.toJsonForCreate(),
    );
  }

  /// Obtener trabajos de largo plazo de un contratista
  static Future<Map<String, dynamic>> obtenerTrabajosContratista(
    String emailContratista,
  ) async {
    return await _getRequest('/trabajos-largo-plazo/contratista', {
      'emailContratista': emailContratista,
    });
  }

  /// Buscar trabajos cercanos (para trabajadores)
  static Future<Map<String, dynamic>> buscarTrabajosCercanos(
    String emailTrabajador, {
    int radio = 500,
  }) async {
    return await _getRequest('/trabajos-largo-plazo/cercanos', {
      'emailTrabajador': emailTrabajador,
      'radio': radio.toString(),
    });
  }

  // ========== TRABAJOS DE CORTO PLAZO ==========

  /// Registrar trabajo corto plazo con imágenes en Base64
  static Future<Map<String, dynamic>> registrarTrabajoCortoPlazo(
    TrabajoCortoModel trabajo,
  ) async {
    return await _postRequest(
      '/trabajos-corto-plazo/registrar',
      trabajo.toJsonForCreate(),
    );
  }

  /// Trabajos corto plazo del contratista
  static Future<Map<String, dynamic>> obtenerTrabajosCortoContratista(
    String emailContratista,
  ) async {
    return await _getRequest('/trabajos-corto-plazo/contratista', {
      'emailContratista': emailContratista,
    });
  }

  /// Trabajos corto plazo cercanos al trabajador
  static Future<Map<String, dynamic>> buscarTrabajosCortoCercanos(
    String emailTrabajador, {
    int radio = 500,
  }) async {
    return await _getRequest('/trabajos-corto-plazo/cercanos', {
      'emailTrabajador': emailTrabajador,
      'radio': radio.toString(),
    });
  }

  // ========== UBICACIÓN Y GEOLOCALIZACIÓN ==========
  
  /// Actualiza la ubicación de un contratista
  static Future<Map<String, dynamic>> actualizarUbicacionContratista(
    String email,
    double latitud,
    double longitud,
  ) async {
    return await _postRequest('/ubicacion/contratista', {
      'email': email,
      'latitud': latitud,
      'longitud': longitud,
    }, isPut: true);
  }

  /// Actualiza la ubicación de un trabajador
  static Future<Map<String, dynamic>> actualizarUbicacionTrabajador(
    String email,
    double latitud,
    double longitud,
  ) async {
    return await _postRequest('/ubicacion/trabajador', {
      'email': email,
      'latitud': latitud,
      'longitud': longitud,
    }, isPut: true);
  }

  /// Busca trabajadores cercanos para un contratista (radio en km)
  /// Devuelve solo 1 trabajador por categoría (el más cercano)
  static Future<Map<String, dynamic>> buscarTrabajadoresCercanos(
    String email, {
    int radio = 500,
  }) async {
    try {
      var urlBase = await baseUrl;
      urlBase = _normalizeBaseUrl(urlBase);
      final url = Uri.parse('$urlBase/ubicacion/trabajadores-cercanos?email=$email&radio=$radio');
      
      print('🌐 Buscando trabajadores cercanos: $url');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Timeout'),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {
          'success': true,
          'data': responseData,
        };
      } else {
        final responseData = jsonDecode(response.body);
        return {
          'success': false,
          'error': responseData['error'] ?? 'Error al buscar trabajadores',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Error: ${e.toString()}',
      };
    }
  }

  /// Busca contratistas/trabajos cercanos para un trabajador (radio en km)
  static Future<Map<String, dynamic>> buscarContratistasCercanos(
    String email, {
    int radio = 500,
  }) async {
    try {
      var urlBase = await baseUrl;
      urlBase = _normalizeBaseUrl(urlBase);
      final url = Uri.parse('$urlBase/ubicacion/contratistas-cercanos?email=$email&radio=$radio');
      
      print('🌐 Buscando contratistas cercanos: $url');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Timeout'),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {
          'success': true,
          'data': responseData,
        };
      } else {
        final responseData = jsonDecode(response.body);
        return {
          'success': false,
          'error': responseData['error'] ?? 'Error al buscar contratistas',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Error: ${e.toString()}',
      };
    }
  }

  /// Busca TODOS los trabajadores de una categoría específica cercanos al contratista
  /// Para la vista de "Ver más"
  static Future<Map<String, dynamic>> buscarTrabajadoresPorCategoria(
    String email,
    String categoria, {
    int radio = 500,
  }) async {
    try {
      var urlBase = await baseUrl;
      urlBase = _normalizeBaseUrl(urlBase);
      final url = Uri.parse('$urlBase/ubicacion/trabajadores-por-categoria?email=$email&categoria=$categoria&radio=$radio');
      
      print('🌐 Buscando trabajadores de categoría $categoria: $url');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Timeout'),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {
          'success': true,
          'data': responseData,
        };
      } else {
        final responseData = jsonDecode(response.body);
        return {
          'success': false,
          'error': responseData['error'] ?? 'Error al buscar trabajadores',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Error: ${e.toString()}',
      };
    }
  }

  // Función auxiliar para hacer peticiones PUT
  static Future<Map<String, dynamic>> _putRequest(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    return await _postRequest(endpoint, body, isPut: true);
  }
}

