library text_field_suffix_button;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Am `IconButton` designed to be place into `InputDecoration.suffixIcon`.
/// By default it renders a button that allow user to clear the text in the `TextField`.
///
/// If [enablePaste] is set to `true`, it renders a button if text is empty, rather than render nothing
/// If [focusNode] is given, then it only renders button when text field is focuse
class TextFieldSuffixButton extends StatefulWidget {
  final TextEditingController controller;
  final bool enablePaste;
  final FocusNode? focusNode;

  /// Create a `TextFieldSuffixButton` instance
  ///
  /// * [controller] is required, and it should be the same instance set to the field. Button use this controller to update the field text
  /// * [enablePaste] controls whether paste function is enabled, default to `false`.
  /// * [focusNode] is optional, if given it should be the same instance given to the text field. After set the `focusNode`, the button only show when the text field is focused.
  TextFieldSuffixButton({
    Key? key,
    required this.controller,
    this.enablePaste: false,
    this.focusNode,
  }) : super(key: key);

  @override
  _TextFieldSuffixButtonState createState() => _TextFieldSuffixButtonState();
}

class _TextFieldSuffixButtonState extends State<TextFieldSuffixButton> {
  late TextEditingController _controller;
  FocusNode? _focusNode;

  _SuffixButtonMode _suffixButtonMode = _SuffixButtonMode.paste;

  @override
  void initState() {
    super.initState();
    _initController(widget.controller);
    _initFocusNode(widget.focusNode);
  }

  @override
  void didUpdateWidget(covariant TextFieldSuffixButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_controller != widget.controller) {
      _controller.removeListener(_updateState);
      _initController(widget.controller);
    }

    if (_focusNode != widget.focusNode) {
      _focusNode?.removeListener(_updateState);
      _initFocusNode(widget.focusNode);
    }
  }

  void _initController(TextEditingController controller) {
    _controller = controller;
    _controller.addListener(_updateState);
    _updateState();
  }

  void _initFocusNode(FocusNode? focusNode) {
    _focusNode = focusNode;
    _focusNode?.addListener(_updateState);
    _updateState();
  }

  @override
  Widget build(BuildContext context) =>
      _suffixButtonMode.build(_onSuffixIconTapped);
  void _onSuffixIconTapped() async {
    _controller.text = await _suffixButtonMode.updateText(_controller);
    _updateState();
  }

  void _updateState() {
    final newMode = _SuffixButtonMode.evaluate(
      _controller.text,
      enablePaste: widget.enablePaste,
      hasFocus: _focusNode?.hasFocus,
    );

    if (newMode == _suffixButtonMode) return;

    setState(() {
      _suffixButtonMode = newMode;
    });
  }
}

abstract class _SuffixButtonMode {
  static _SuffixButtonMode get clear => const _ClearMode();
  static _SuffixButtonMode get paste => const _PasteMode();
  static _SuffixButtonMode get nop => const _NopMode();
  factory _SuffixButtonMode.evaluate(String text,
          {bool enablePaste: false, bool? hasFocus}) =>
      hasFocus != false
          ? enablePaste
              ? _SuffixButtonMode.clearOrPaste(text)
              : _SuffixButtonMode.clearOrNop(text)
          : nop;

  factory _SuffixButtonMode.clearOrPaste(String text) =>
      text.isEmpty ? paste : clear;
  factory _SuffixButtonMode.clearOrNop(String text) =>
      text.isEmpty ? nop : clear;
  Future<String> updateText(TextEditingController controller);
  Widget build(void Function() onSuffixIconTapped);
}

class _ClearMode implements _SuffixButtonMode {
  const _ClearMode();
  @override
  Future<String> updateText(TextEditingController controller) {
    controller.clear();
    return SynchronousFuture("");
  }

  @override
  Widget build(void Function() onSuffixIconTapped) => InkWell(
        child: const Icon(Icons.clear),
        customBorder: const CircleBorder(),
        onTap: onSuffixIconTapped,
      );
}

class _PasteMode implements _SuffixButtonMode {
  const _PasteMode();
  @override
  Future<String> updateText(TextEditingController controller) async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    controller.text = data?.text ?? "";
    return controller.text;
  }

  @override
  Widget build(void Function() onSuffixIconTapped) => InkWell(
        child: const Icon(Icons.paste),
        customBorder: const CircleBorder(),
        onTap: onSuffixIconTapped,
      );
}

class _NopMode implements _SuffixButtonMode {
  const _NopMode();
  @override
  Future<String> updateText(TextEditingController controller) =>
      SynchronousFuture(controller.text);
  @override
  Widget build(void Function() onSuffixIconTapped) =>
      Container(width: 0, height: 0);
}
