# text_field_suffix_button
[![Star this Repo](https://img.shields.io/github/stars/timnew/text_field_suffix_button.svg?style=flat-square)](https://github.com/timnew/text_field_suffix_button)
[![Pub Package](https://img.shields.io/pub/v/text_field_suffix_button.svg?style=flat-square)](https://pub.dev/packages/text_field_suffix_button)
[![Build Status](https://img.shields.io/github/workflow/status/timnew/text_field_suffix_button/Run-Test)](https://github.com/timnew/text_field_suffix_button/actions?query=workflow%3ARun-Test)

A simple widget that renders the a button as text input's suffix icon, which have a few behaviours:

## Clear Button

```dart
Widget build(BuildContext context) {
  final controller = TextEditingController();

  return TextField(
    decoration: InputDecoration(
      suffixIcon: TextFieldSuffixButton(controller: controller),
    ),
    controller: controller,
  );
}
```

A `TextEditingController` that shared with the field is required to make the button function properly.
When `controller.text` isn't empty, a button with `x` icon is show. When user clicked, it clear the text of the field.

## Paste or Clear

```dart
Widget build(BuildContext context) {
  final controller = TextEditingController();
  final focusNode = FocusNode();

  return TextField(
    decoration: InputDecoration(
      suffixIcon: TextFieldSuffixButton(
        controller: controller,
        enablePaste: true,
        focusNode: focusNode,
      ),
    ),
    controller: controller,
    focusNode: focusNode,
  );
}
```

An optional `FocusNode` that shared with the text field can be given. Then the `focusNode` is given, the button hides itself by default, and only shows when the field is focused. It works with both clear button and paste button.