import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:rive_example/main.dart' show RiveExampleApp;

/// Example using Rive data binding artboards at runtime.
///
/// See: https://rive.app/docs/runtimes/data-binding
class ExampleDataBindingArtboards extends StatefulWidget {
  const ExampleDataBindingArtboards({super.key});

  @override
  State<ExampleDataBindingArtboards> createState() =>
      _ExampleDataBindingArtboardsState();
}

class _ExampleDataBindingArtboardsState
    extends State<ExampleDataBindingArtboards> {
  late final File travelPackFile;
  late final File webPackFile;
  late final RiveWidgetController controller;
  late final ViewModelInstance viewModelInstance;
  late ViewModelInstanceArtboard iconProperty;
  late BindableArtboard bindableArtboard;
  bool isInitialized = false;

  // Available artboard options
  final List<String> travelPackOptions = [
    'map',
    'car',
    'gas',
    'compass',
    'walk',
    'food',
    'GPS',
    'coffee'
  ];
  final List<String> webPackOptions = [
    'download',
    'refresh',
    'lock',
    'wifi',
    'email',
    'www'
  ];
  String selectedTravelPackArtboard = 'map';
  String selectedWebPackArtboard = 'download';

  @override
  void initState() {
    super.initState();
    initRive();
  }

  void initRive() async {
    travelPackFile = (await File.asset(
      'assets/travel_icons_pack.riv',
      riveFactory: RiveExampleApp.getCurrentFactory,
    ))!;
    webPackFile = (await File.asset(
      'assets/web_icons_pack.riv',
      riveFactory: RiveExampleApp.getCurrentFactory,
    ))!;
    controller =
        RiveWidgetController(travelPackFile); // uses default artboard: "Demo"
    viewModelInstance = controller.dataBind(DataBind.auto());
    iconProperty = viewModelInstance.artboard('icon')!;
    bindableArtboard =
        travelPackFile.artboardToBind(selectedTravelPackArtboard)!;
    iconProperty.value = bindableArtboard;
    setState(() => isInitialized = true);
  }

  void _onTravelIconSelected(String? newValue) {
    if (newValue != null && newValue != selectedTravelPackArtboard) {
      setState(() {
        selectedTravelPackArtboard = newValue;
        bindableArtboard = travelPackFile.artboardToBind(newValue)!;
        iconProperty.value = bindableArtboard;
      });
    }
  }

  void _onWebPackIconSelected(String? newValue) {
    if (newValue != null && newValue != selectedWebPackArtboard) {
      setState(() {
        selectedWebPackArtboard = newValue;
        bindableArtboard = webPackFile.artboardToBind(newValue)!;
        iconProperty.value = bindableArtboard;
      });
    }
  }

  @override
  void dispose() {
    travelPackFile.dispose();
    webPackFile.dispose();
    bindableArtboard.dispose();
    controller.dispose();
    viewModelInstance.dispose();
    iconProperty.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Wrap(
          children: [
            _buildDropdown(
              'Travel Pack',
              travelPackOptions,
              selectedTravelPackArtboard,
              _onTravelIconSelected,
            ),
            _buildDropdown(
              'Web Pack',
              webPackOptions,
              selectedWebPackArtboard,
              _onWebPackIconSelected,
            ),
          ],
        ),
        Expanded(
          child: RiveWidget(controller: controller),
        ),
      ],
    );
  }

  Widget _buildDropdown(String title, List<String> options, String selected,
      Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: DropdownButton<String>(
                value: selected,
                items: options.map((String artboard) {
                  return DropdownMenuItem<String>(
                    value: artboard,
                    child: Text(artboard),
                  );
                }).toList(),
                onChanged: (newValue) => onChanged(newValue),
                underline: Container(),
                hint: const Text('Select Artboard'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
