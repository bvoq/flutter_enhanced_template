import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/pages/welcome_page.dart';

void main() {
  group('WelcomePage', () {
    testWidgets('renders WelcomePage', (tester) async {
      await tester.pumpWidget(const WelcomePage());
      expect(true, isTrue);
    });
  });
}
