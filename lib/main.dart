import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hoshi_launcher/widgets/main_text_entry.dart';
import 'package:hoshi_launcher/widgets/results_list.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:wayland_shell/wayland_shell.dart';

late final StreamingSharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  prefs = await StreamingSharedPreferences.instance;

  await WaylandShell.init(
    namespace: "hoshi-launcher",
    layer: WaylandShellLayer.overlay,
    anchors: [
      WaylandShellEdge.left,
    ],
    keyboardMode: WaylandShellKeyboardMode.onDemand,
  );

  await WaylandShell.setWidth(400);
  await WaylandShell.setExclusiveZone(kDebugMode ? 400 : -1);
  await WaylandShell.setAnchor(WaylandShellEdge.top, true);
  await WaylandShell.setAnchor(WaylandShellEdge.left, true);
  await WaylandShell.setAnchor(WaylandShellEdge.bottom, true);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Hoshi Launcher",
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: Colors.blue,
        ),
        scaffoldBackgroundColor: const Color.fromRGBO(0x21, 0x27, 0x33, 0.92),
        useMaterial3: true,
      ),
      home: const Main(),
    );
  }
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          border: Border(
            right: BorderSide(
              color: Color.fromRGBO(0x33, 0xdd, 0xff, 0.93),
            ),
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            MainTextEntry(),
            Expanded(child: ResultsList()),
          ],
        ),
      ),
    );
  }
}
