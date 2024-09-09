//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <wayland_shell/wayland_shell_plugin.h>
#include <xdg_icons/xdg_icons_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) wayland_shell_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "WaylandShellPlugin");
  wayland_shell_plugin_register_with_registrar(wayland_shell_registrar);
  g_autoptr(FlPluginRegistrar) xdg_icons_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "XdgIconsPlugin");
  xdg_icons_plugin_register_with_registrar(xdg_icons_registrar);
}
