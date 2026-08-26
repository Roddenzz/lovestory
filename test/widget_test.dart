import 'package:flutter_test/flutter_test.dart';
import 'package:lovestory/main.dart';

void main() {
  testWidgets('love story app opens with pixel intro', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('НАША ИСТОРИЯ'), findsOneWidget);
    expect(find.text('—  120 BPM  —'), findsOneWidget);
    await tester.tap(find.text('НАЖМИ, ЧТОБЫ ОТКРЫТЬ'));
    await tester.pumpAndSettle(const Duration(seconds: 1));
  });
}
