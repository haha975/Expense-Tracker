import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/app/app.dart';
import 'package:mobile/app/di/injection.dart';
import 'package:mobile/core/constants/app_constants.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await configureDependencies(reset: true);
  });

  testWidgets('renders splash branding', (tester) async {
    await tester.pumpWidget(const ExpenseApp());
    await tester.pump();

    expect(find.text(AppConstants.appName), findsOneWidget);
    expect(find.text(AppConstants.appTagline), findsOneWidget);
    expect(find.text(AppConstants.splashFooter), findsOneWidget);
  });
}
