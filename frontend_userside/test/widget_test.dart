import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_userside/app/app.dart';

void main() {
  testWidgets('ResumeForge User App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: ResumeForgeApp()));
    await tester.pumpAndSettle();

    // Verify that the app mounts properly
    expect(find.byType(ResumeForgeApp), findsOneWidget);
  });
}
