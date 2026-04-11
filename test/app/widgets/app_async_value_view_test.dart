import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_gacha/app/widgets/app_async_value_view.dart';
import 'package:life_gacha/app/widgets/app_empty_state.dart';
import 'package:life_gacha/core/error/app_failure.dart';

void main() {
  testWidgets('app async value view renders a loading state', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: AppAsyncValueView<int>(
              value: AsyncLoading<int>(),
              fallbackErrorMessage: 'Fallback error.',
              builder: _buildValue,
            ),
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('app async value view maps failures and retries', (tester) async {
    var retryCount = 0;

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: AppAsyncValueView<int>(
              value: const AsyncError<int>(
                PersistenceFailure(),
                StackTrace.empty,
              ),
              fallbackErrorMessage: 'Fallback error.',
              onRetry: () {
                retryCount += 1;
              },
              builder: _buildValue,
            ),
          ),
        ),
      ),
    );

    expect(
      find.text('That change could not be saved locally.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Try again'));
    expect(retryCount, 1);
  });

  testWidgets('app async value view renders data builder content', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: AppAsyncValueView<int>(
              value: AsyncData<int>(42),
              fallbackErrorMessage: 'Fallback error.',
              builder: _buildValue,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Value: 42'), findsOneWidget);
  });

  testWidgets('app empty state renders title and message', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppEmptyState(
            title: 'Nothing here yet.',
            message: 'Add something to continue.',
          ),
        ),
      ),
    );

    expect(find.text('Nothing here yet.'), findsOneWidget);
    expect(find.text('Add something to continue.'), findsOneWidget);
  });
}

Widget _buildValue(BuildContext context, int value) {
  return Center(child: Text('Value: $value'));
}
