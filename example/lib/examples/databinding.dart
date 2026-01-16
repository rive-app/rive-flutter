import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:rive_example/main.dart' show RiveExampleApp;

/// Example using Rive data binding at runtime.
///
/// See: https://rive.app/docs/runtimes/data-binding
/// Rive Editor file: https://rive.app/marketplace/25475-47540-data-binding-demo/
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
  late ViewModelInstanceNumber coinProperty;
  late ViewModelInstanceNumber gemProperty;
  late ViewModelInstanceNumber energyBarProperty;
  late ViewModelInstanceNumber energyBarLivesProperty;
  late ViewModelInstanceColor energyBarColorProperty;
  late ViewModelInstanceString buttonTitleProperty;
  late ViewModelInstanceTrigger buttonPressedProperty;

  double _sliderValue = 0.5;
  late Stream<double> _energyBarStream;
  Color _selectedColor = const Color(0xFF4CAF50);

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
    _setupDataBinding();
    setState(() {});
  }

  void _setupDataBinding() {
    // Bind the default view model instance of the artboard to the controller
    viewModelInstance = controller!.dataBind(DataBind.auto());

    // Set a random token to reward
    _selectRandomToken();

    // Print the view model instance properties
    debugPrint(viewModelInstance.properties.toString());

    // Get the rewards view model
    coinItemVM = viewModelInstance.viewModel('Coin')!;
    gemItemVM = viewModelInstance.viewModel('Gem')!;

    // Print the view model instance properties
    debugPrint(coinItemVM.toString());

    // Get the Item_Value number properties for the coin and gem
    coinProperty = coinItemVM.number('Item_Value')!;
    gemProperty = gemItemVM.number('Item_Value')!;

    // Listen to the changes on the Item_Value for the gen and coin
    coinProperty.addListener(_onCoinValueChange);
    gemProperty.addListener(_onGemValueChange);

    // Set the initial values for the coin and gem
    coinProperty.value = 1000;
    gemProperty.value = 4000;

    // Get the Energy_Bar/Energy_Bar number property
    energyBarProperty = viewModelInstance.number('Energy_Bar/Energy_Bar')!;
    // Create a stream for the energy bar
    _energyBarStream = energyBarProperty.valueStream;

    // Get the Energy_Bar/Energy_Bar lives number property
    energyBarLivesProperty = viewModelInstance.number('Energy_Bar/Lives')!;

    // Get the Energy_Bar/Energy_Bar color property
    energyBarColorProperty = viewModelInstance.color('Energy_Bar/Bar_Color')!;

    // Get the Button/Button_Title string property
    buttonTitleProperty = viewModelInstance.string('Button/State_1')!;

    // Get the Button/Button_Trigger trigger property
    buttonPressedProperty = viewModelInstance.trigger('Button/Pressed')!;

    // Listen to the changes on the Button/Pressed trigger
    buttonPressedProperty.addListener(_onButtonPressed);
  }

  // Randomly select to reward either coins or gems
  void _selectRandomToken() {
    final random = Random.secure().nextBool() ? 'Coin' : 'Gem';
    viewModelInstance
        .viewModel('Item_Selection')!
        .enumerator('Item_Selection')!
        .value = random;
  }

  // Listener for the changes on the Item_Value for the coin
  void _onCoinValueChange(double value) {
    debugPrint('New coin value: $value');
  }

  // Listener for the changes on the Item_Value for the gem
  void _onGemValueChange(double value) {
    debugPrint('New gem value: $value');
  }

  void _onButtonPressed(bool value) {
    debugPrint('Button pressed');
  }

  @override
  void dispose() {
    // Listeners must be removed
    coinProperty.removeListener(_onCoinValueChange);
    gemProperty.removeListener(_onGemValueChange);

    // Disposing the properties would also remove the listeners.
    // This is a best practice to immediately remove allocated native resources.
    // However, they will get garbage collected by the Dart runtime as they are
    // Finalizers, and it's not strictly necessary to dispose here.
    coinProperty.dispose();
    gemProperty.dispose();
    coinItemVM.dispose();
    gemItemVM.dispose();
    energyBarProperty.dispose();
    energyBarLivesProperty.dispose();
    energyBarColorProperty.dispose();
    buttonTitleProperty.dispose();
    buttonPressedProperty.dispose();

    controller?.dispose();
    file?.dispose();
    super.dispose();
  }

  void _showConfigSheet(BuildContext context) {
    if (controller == null) return;

    showModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Container(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Configuration',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                // This is just an example of using a value stream
                StreamBuilder<double>(
                  stream: _energyBarStream,
                  builder: (context, snapshot) => Text(
                    'Energy: ${snapshot.data?.toStringAsFixed(2) ?? '0.00'}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Slider(
                  value: _sliderValue,
                  onChanged: (value) {
                    setSheetState(() => _sliderValue = value);
                    energyBarProperty.value = value * 100;
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  'Bar Color',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    const Color(0xFF4CAF50), // Green
                    const Color(0xFF2196F3), // Blue
                    const Color(0xFFF44336), // Red
                    const Color(0xFFFF9800), // Orange
                    const Color(0xFF9C27B0), // Purple
                    const Color(0xFFFFEB3B), // Yellow
                    const Color(0xFF00BCD4), // Cyan
                    const Color(0xFFE91E63), // Pink
                  ].map((color) {
                    // ignore: deprecated_member_use
                    final isSelected = _selectedColor.value == color.value;
                    return GestureDetector(
                      onTap: () {
                        setSheetState(() => _selectedColor = color);
                        energyBarColorProperty.value = color;
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:
                                isSelected ? Colors.white : Colors.transparent,
                            width: 3,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    // ignore: deprecated_member_use
                                    color: color.withOpacity(0.6),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : null,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Text(
                  'Lives: ${energyBarLivesProperty.value}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Slider(
                  value: energyBarLivesProperty.value,
                  onChanged: (value) {
                    energyBarLivesProperty.value = value;
                    setSheetState(() {});
                  },
                  min: 0,
                  max: 10,
                  divisions: 10,
                  label: 'Lives',
                ),
                const SizedBox(height: 16),
                Text(
                  'Button Title: ${buttonTitleProperty.value}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                TextField(
                  onChanged: (value) {
                    buttonTitleProperty.value = value;
                    setSheetState(() {});
                  },
                  decoration: const InputDecoration(
                    labelText: 'Button Title',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = this.controller;
    if (controller == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Stack(
      children: [
        RiveWidget(
          controller: controller,
          fit: Fit.layout, // for responsive layouts
          layoutScaleFactor: 1 / 2.0,
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: IconButton.filled(
            icon: const Icon(Icons.tune),
            onPressed: () => _showConfigSheet(context),
            tooltip: 'Configuration',
          ),
        ),
      ],
    );
  }
}
