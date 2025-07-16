import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:rive_example/main.dart' show RiveExampleApp;

/// Example using Rive data binding at runtime.
///
/// See: https://rive.app/docs/runtimes/data-binding
class ExampleDataBinding extends StatefulWidget {
  const ExampleDataBinding({super.key});

  @override
  State<ExampleDataBinding> createState() => _ExampleDataBindingState();
}

class _ExampleDataBindingState extends State<ExampleDataBinding> {
  File? file;
  RiveWidgetController? controller;

  late ViewModelInstance viewModelInstance;
  late ViewModelInstance coinItemVM;
  late ViewModelInstance gemItemVM;
  late ViewModelInstanceNumber coinValue;
  late ViewModelInstanceNumber gemValue;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    file = await File.asset(
      'assets/rewards.riv',
      riveFactory: RiveExampleApp.getCurrentFactory,
    );
    controller = RiveWidgetController(file!);
    _initViewModel();
    setState(() {});
  }

  void _initViewModel() {
    viewModelInstance = controller!.dataBind(DataBind.auto());
    _selectRandomToken();
    // Print the view model instance properties
    debugPrint(viewModelInstance.properties.toString());
    // Get the rewards view model
    coinItemVM = viewModelInstance.viewModel('Coin')!;
    gemItemVM = viewModelInstance.viewModel('Gem')!;
    debugPrint(
        coinItemVM.toString()); // Print the view model instance properties

    coinValue = coinItemVM.number('Item_Value')!;
    gemValue = gemItemVM.number('Item_Value')!;
    // Listen to the changes on the Item_Value input
    coinValue.addListener(_onCoinValueChange);
    coinValue.value = 1000; // set the initial coin value to 1000

    gemValue.addListener(_onGemValueChange);
    gemValue.value = 4000; // set the initial gem value to 4000
  }

  void _selectRandomToken() {
    final random = Random.secure().nextBool() ? 'Coin' : 'Gem';
    // We randomly select to reward either coins or gems
    viewModelInstance
        .viewModel('Item_Selection')!
        .enumerator('Item_Selection')!
        .value = random;
  }

  void _onCoinValueChange(double value) {
    debugPrint('New coin value: $value');
  }

  void _onGemValueChange(double value) {
    debugPrint('New gem value: $value');
  }

  @override
  void dispose() {
    coinValue.removeListener(_onCoinValueChange);
    gemValue.removeListener(_onGemValueChange);
    coinValue.dispose();
    gemValue.dispose();
    coinItemVM.dispose();
    gemItemVM.dispose();
    controller?.dispose();
    file?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = this.controller;
    if (controller == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return RiveWidget(
      controller: controller,
      fit: Fit.layout, // for responsive layouts
      layoutScaleFactor: 1 / 2.0,
    );
  }
}
