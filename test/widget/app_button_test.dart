import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_white_list/widgets/buttons/app_button.dart';

Widget _wrap(Widget child) => ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (_, _) => MaterialApp(home: Scaffold(body: child)),
    );

void main() {
  testWidgets('AppButton renders label and fires onPressed', (tester) async {
    var tapped = 0;
    await tester.pumpWidget(
      _wrap(
        AppButton.primary(
          label: 'Continue',
          onPressed: () => tapped++,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Continue'), findsOneWidget);

    await tester.tap(find.byType(AppButton));
    await tester.pumpAndSettle();
    expect(tapped, 1);
  });

  testWidgets('AppButton in loading state hides label and disables taps',
      (tester) async {
    var tapped = 0;
    await tester.pumpWidget(
      _wrap(
        AppButton.primary(
          label: 'Continue',
          isLoading: true,
          onPressed: () => tapped++,
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Continue'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.tap(find.byType(AppButton));
    await tester.pump();
    expect(tapped, 0);
  });
}
