//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <file_selector_windows/file_selector_windows.h>
#include <firebase_core/firebase_core_plugin_c_api.h>
<<<<<<< HEAD
#include <geolocator_windows/geolocator_windows.h>
#include <permission_handler_windows/permission_handler_windows_plugin.h>
=======
#include <flutter_secure_storage_windows/flutter_secure_storage_windows_plugin.h>
#include <geolocator_windows/geolocator_windows.h>
#include <permission_handler_windows/permission_handler_windows_plugin.h>
#include <share_plus/share_plus_windows_plugin_c_api.h>
>>>>>>> feature/App-Terminada
#include <url_launcher_windows/url_launcher_windows.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  FileSelectorWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FileSelectorWindows"));
  FirebaseCorePluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FirebaseCorePluginCApi"));
<<<<<<< HEAD
=======
  FlutterSecureStorageWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterSecureStorageWindowsPlugin"));
>>>>>>> feature/App-Terminada
  GeolocatorWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("GeolocatorWindows"));
  PermissionHandlerWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("PermissionHandlerWindowsPlugin"));
<<<<<<< HEAD
=======
  SharePlusWindowsPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("SharePlusWindowsPluginCApi"));
>>>>>>> feature/App-Terminada
  UrlLauncherWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("UrlLauncherWindows"));
}
