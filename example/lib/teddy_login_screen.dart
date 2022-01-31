import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:rive/rive.dart';

class TeddyLoginScreen extends StatefulWidget {
  const TeddyLoginScreen({Key? key}) : super(key: key);

  @override
  _TeddyLoginScreenState createState() => _TeddyLoginScreenState();
}

class _TeddyLoginScreenState extends State<TeddyLoginScreen> {
  late ControlTeddy _controlTeddy;

  @override
  void initState() {
    _controlTeddy = ControlTeddy();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets devicePadding = MediaQuery.of(context).padding;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(93, 142, 155, 1.0),
        body: Container(
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xffd6e2ea),
                  ),
                ),
              ),
              Positioned.fill(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                      left: 20.0, right: 20.0, top: devicePadding.top + 50.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 200,
                        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                        child: RiveAnimation.asset(
                          "assets/teddy.riv",
                          animations: const ['idle', 'curves'],
                          alignment: Alignment.bottomCenter,
                          fit: BoxFit.contain,
                          onInit: _controlTeddy._onRiveInit,
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(25.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Form(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                TrackingTextInput(
                                  label: "Email",
                                  hint: "What's your email address?",
                                  onCaretMoved: (
                                      {Offset? globalCaretPosition,
                                      Size? textFieldSize}) {
                                    _controlTeddy.lookAt(
                                        textFieldSize: textFieldSize,
                                        caret: globalCaretPosition);
                                  },
                                ),
                                TrackingTextInput(
                                  label: "Password",
                                  hint: "Try 'bears'...",
                                  isObscured: true,
                                  onCaretMoved: (
                                      {Offset? globalCaretPosition,
                                      Size? textFieldSize}) {
                                    _controlTeddy.coverEyes(
                                        cover: globalCaretPosition != null);
                                    _controlTeddy.lookAt(
                                        textFieldSize: textFieldSize,
                                        caret: null);
                                  },
                                  onTextChanged: (String value) {
                                    _controlTeddy._password = value;
                                  },
                                ),
                                SignInButton(
                                  child: const Text(
                                    "Sign In",
                                    style: TextStyle(
                                        fontFamily: "RobotoMedium",
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                  onPressed: () {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    _controlTeddy.submitPassword();
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

typedef void CaretMoved({Offset? globalCaretPosition, Size? textFieldSize});
typedef void TextChanged(String text);

// Helper widget to track caret position.
class TrackingTextInput extends StatefulWidget {
  const TrackingTextInput(
      {this.onCaretMoved,
      this.onTextChanged,
      this.hint,
      this.label,
      Key? key,
      this.isObscured = false})
      : super(key: key);
  final CaretMoved? onCaretMoved;
  final TextChanged? onTextChanged;
  final String? hint;
  final String? label;
  final bool isObscured;
  @override
  _TrackingTextInputState createState() => _TrackingTextInputState();
}

// Adapted these helpful functions from:
// https://github.com/flutter/flutter/blob/master/packages/flutter/test/material/text_field_test.dart

// Returns first render editable
RenderEditable? findRenderEditable(RenderObject root) {
  RenderEditable? renderEditable;
  void recursiveFinder(RenderObject child) {
    if (child is RenderEditable) {
      renderEditable = child;
      return;
    }
    child.visitChildren(recursiveFinder);
  }

  root.visitChildren(recursiveFinder);
  return renderEditable;
}

List<TextSelectionPoint> globalize(
    Iterable<TextSelectionPoint> points, RenderBox box) {
  return points.map<TextSelectionPoint>((TextSelectionPoint point) {
    return TextSelectionPoint(
      box.localToGlobal(point.point),
      point.direction,
    );
  }).toList();
}

Offset? getCaretPosition(RenderBox box) {
  final RenderEditable? renderEditable = findRenderEditable(box);
  if (renderEditable == null ||
      !renderEditable.hasFocus ||
      renderEditable.selection == null) {
    return null;
  }
  final List<TextSelectionPoint> endpoints = globalize(
    renderEditable.getEndpointsForSelection(renderEditable.selection!),
    renderEditable,
  );
  return endpoints[0].point + const Offset(0.0, -2.0);
}

class _TrackingTextInputState extends State<TrackingTextInput> {
  final GlobalKey _fieldKey = GlobalKey();
  final TextEditingController _textController = TextEditingController();
  final _focusNode = FocusNode();
  Timer? _debounceTimer;

  void debounceListener() {
    // debugPrint("${widget.label} has focus: ${_focusNode.hasFocus}");
    // We debounce the listener as sometimes the caret position is updated
    // after the listener this assures us we get an accurate caret position.
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 100), () {
      if (_fieldKey.currentContext != null) {
        // Find the render editable in the field.
        final RenderObject? fieldBox =
            _fieldKey.currentContext?.findRenderObject();
        var caretPosition =
            fieldBox is RenderBox ? getCaretPosition(fieldBox) : null;

        var textFieldSize = fieldBox is RenderBox ? fieldBox.size : null;

        widget.onCaretMoved?.call(
            globalCaretPosition: caretPosition, textFieldSize: textFieldSize);
      }
    });
    widget.onTextChanged?.call(_textController.text);
  }

  late bool isObscured;

  @override
  void initState() {
    // Listening text field focus node to change animation depending on field.
    _focusNode.addListener(debounceListener);

    // Listening changes in text field controller to get updated cursor offset.
    _textController.addListener(debounceListener);

    // Used to decide and change password visibility in text field.
    isObscured = widget.isObscured;
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        key: _fieldKey,
        controller: _textController,
        decoration: InputDecoration(
          filled: true,
          labelText: widget.label,
          helperText: '',
          hintText: widget.hint,
          enabledBorder: const UnderlineInputBorder(),
          suffixIcon: widget.isObscured
              ? IconButton(
                  icon: Icon(
                    isObscured ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      isObscured = !isObscured;
                    });
                  },
                )
              : null,
        ),
        enableSuggestions: !widget.isObscured,
        autocorrect: !widget.isObscured,
        focusNode: _focusNode,
        obscureText: isObscured,
        // validator: (value) {},
      ),
    );
  }
}

class SignInButton extends StatelessWidget {
  final Widget child;
  final void Function() onPressed;

  const SignInButton({
    required this.child,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(const Color(0xffb04863)),
        padding: MaterialStateProperty.all(
            const EdgeInsets.only(top: 17, bottom: 17, left: 30, right: 30)),
        textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 20)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}

class ControlTeddy {
  // Trigger for password fail.
  SMITrigger? _fail;

  // Trigger for password success.
  SMITrigger? _success;

  // Boolean input for covering eyes.
  SMIBool? _handsUp;

  // Boolean input for enabling text field following eyes.
  SMIBool? _check;

  // Input for changing eyes position on x axis.
  SMIInput<double>? _look;

  // Function fired when Riveanimation has initialized.
  void _onRiveInit(Artboard artboard) {
    final StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 1');
    artboard.addController(controller!);
    _fail = controller.findInput<bool>('fail') as SMITrigger?;
    _success = controller.findInput<bool>('success') as SMITrigger?;
    _handsUp = controller.findInput<bool>('hands_up') as SMIBool?;
    _look = controller.findInput<double>('Look');
    _check = controller.findInput<bool>('Check') as SMIBool?;
  }

  String _password = '';

  // Boolean status of eyes covering.
  bool _isCoveringEyes = false;

  // Controls Teddy eyes using offset of text field cursor and text field size.
  void lookAt({required Offset? caret, required Size? textFieldSize}) {
    if (caret != null && textFieldSize != null) {
      _check?.value = true;
      _look?.value = caret.dx - textFieldSize.width / 2;
    } else {
      _check?.value = false;
    }
  }

  // Used to cover Teddy eyes when entering password.
  void coverEyes({required bool cover}) {
    if (_isCoveringEyes == cover) {
      return;
    }
    _isCoveringEyes = cover;
    if (cover) {
      _handsUp?.value = true;
    } else {
      _handsUp?.value = false;
      _isCoveringEyes = false;
    }
  }

  // Function fired when clicking Sign In button.
  void submitPassword() {
    if (_password == "bears") {
      _success?.fire();
    } else {
      _fail?.fire();
    }
  }
}
