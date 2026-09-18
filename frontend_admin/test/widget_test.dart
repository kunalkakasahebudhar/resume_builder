import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_admin/app/app.dart';

void main() {
  testWidgets('ResumeForge Admin App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: ResumeForgeAdminApp()));
    expect(find.byType(ResumeForgeAdminApp), findsOneWidget);
  });
}
