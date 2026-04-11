import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:life_gacha/app/life_gacha_app.dart';

void main() {
  testWidgets('LifeGacha app shell renders dashboard', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: LifeGachaApp()));

    expect(find.text('LifeGacha'), findsOneWidget);
    expect(find.byType(LifeGachaApp), findsOneWidget);
  });
}
