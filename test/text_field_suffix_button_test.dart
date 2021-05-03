import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:text_field_suffix_button/text_field_suffix_button.dart';

void main() {
  testWidgets("it only renders clear button", (WidgetTester tester) async {
    final controller = TextEditingController();

    await tester.pumpWidget(
      TextField(
        decoration: InputDecoration(
          suffixIcon: TextFieldSuffixButton(controller: controller),
        ),
        controller: controller,
      ),
    );

    expect(find.byIcon(Icons.clear), findsNothing);

    final text = "Something";
    controller.text = text;
    await tester.pump();

    expect(find.text(text), findsOneWidget);
    expect(find.byIcon(Icons.clear), findsOneWidget);

    await tester.tap(find.byIcon(Icons.clear));
    await tester.pump();

    expect(controller.text, "");
    expect(find.byIcon(Icons.clear), findsNothing);
  });
}
