import 'dart:convert';
<<<<<<< HEAD
import 'package:shared_preferences/shared_preferences.dart';
=======
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
>>>>>>> feature/App-Terminada

class StorageService {
  static const String _tokenKey = 'jwt_token';
  static const String _userKey = 'user_data';
<<<<<<< HEAD

  // Guardar token JWT
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
=======
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  static final ValueNotifier<Map<String, dynamic>?> userNotifier =
      ValueNotifier<Map<String, dynamic>?>(null);

  // Guardar token JWT
  static Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
>>>>>>> feature/App-Terminada
  }

  // Obtener token JWT
  static Future<String?> getToken() async {
<<<<<<< HEAD
=======
    final token = await _secureStorage.read(key: _tokenKey);
    if (token != null && token.isNotEmpty) {
      return token;
    }
>>>>>>> feature/App-Terminada
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Eliminar token JWT
  static Future<void> deleteToken() async {
<<<<<<< HEAD
=======
    await _secureStorage.delete(key: _tokenKey);
>>>>>>> feature/App-Terminada
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  // Guardar datos del usuario
  static Future<void> saveUser(Map<String, dynamic> user) async {
<<<<<<< HEAD
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user));
=======
    final data = jsonEncode(user);
    await _secureStorage.write(key: _userKey, value: data);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    userNotifier.value = Map<String, dynamic>.from(user);
>>>>>>> feature/App-Terminada
  }

  // Obtener datos del usuario
  static Future<Map<String, dynamic>?> getUser() async {
<<<<<<< HEAD
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(_userKey);
    if (userString != null) {
      return jsonDecode(userString) as Map<String, dynamic>;
    }
    return null;
=======
    final stored = await _secureStorage.read(key: _userKey);
    final dataString = stored ?? await _readUserFromPrefs();
    if (dataString == null) {
      userNotifier.value = null;
      return null;
    }
    try {
      final map = jsonDecode(dataString) as Map<String, dynamic>;
      if (!mapEquals(userNotifier.value, map)) {
        userNotifier.value = Map<String, dynamic>.from(map);
      }
      return map;
    } catch (_) {
      userNotifier.value = null;
      return null;
    }
  }

  static Future<void> mergeUser(Map<String, dynamic> updates) async {
    final current = await getUser();
    if (current == null) {
      return;
    }

    final updated = Map<String, dynamic>.from(current)..addAll(updates);
    await saveUser(updated);
  }

  static Future<String?> _readUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userKey);
>>>>>>> feature/App-Terminada
  }

  // Eliminar datos del usuario
  static Future<void> deleteUser() async {
<<<<<<< HEAD
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
=======
    await _secureStorage.delete(key: _userKey);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    userNotifier.value = null;
>>>>>>> feature/App-Terminada
  }

  // Limpiar toda la sesión
  static Future<void> clearSession() async {
<<<<<<< HEAD
    await deleteToken();
    await deleteUser();
=======
    await Future.wait([deleteToken(), deleteUser()]);
    userNotifier.value = null;
>>>>>>> feature/App-Terminada
  }

  // Verificar si hay una sesión activa
  static Future<bool> hasSession() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}

