import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_demo_app/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(seenOnboarding: false),
      ),
    );

    // Verify that onboarding is shown when seenOnboarding is false.
    expect(find.text('Get Started'), findsOneWidget);
  });
}
