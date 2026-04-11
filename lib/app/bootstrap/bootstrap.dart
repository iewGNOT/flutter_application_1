import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../di/use_case_providers.dart';
import '../life_gacha_app.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();
  await container.read(appStartupProvider).initialize();

  runApp(
    UncontrolledProviderScope(container: container, child: LifeGachaApp()),
  );
}
