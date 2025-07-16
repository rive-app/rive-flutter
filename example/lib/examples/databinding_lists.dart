import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:rive_example/main.dart' show RiveExampleApp;

/// Example using Rive data binding lists at runtime.
///
/// See: https://rive.app/docs/runtimes/data-binding
class ExampleDataBindingLists extends StatefulWidget {
  const ExampleDataBindingLists({super.key});

  @override
  State<ExampleDataBindingLists> createState() =>
      _ExampleDataBindingListsState();
}

class _ExampleDataBindingListsState extends State<ExampleDataBindingLists> {
  late ViewModelInstance viewModelInstance;
  late ViewModelInstanceList menuList;
  late ViewModel todoItemVM;

  // Text controllers for input fields
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _num1Controller = TextEditingController();
  final TextEditingController _num2Controller = TextEditingController();
  final TextEditingController _deleteController = TextEditingController();

  FileLoader fileLoader = FileLoader.fromAsset(
    'assets/lists_demo.riv',
    riveFactory: RiveExampleApp.getCurrentFactory,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    fileLoader.dispose();
    _textController.dispose();
    _num1Controller.dispose();
    _num2Controller.dispose();
    _deleteController.dispose();
    super.dispose();
  }

  void _onLoaded(RiveLoaded state) {
    viewModelInstance = state.viewModelInstance!;

    // Get the menu list
    menuList = viewModelInstance.list('menu')!;

    // Get the TodoItem View Model
    todoItemVM = state.file.viewModelByName('listItem')!;

    debugPrint('Rive file loaded!');
    debugPrint('Menu list: $menuList');
    debugPrint('TodoItem VM: $todoItemVM');
  }

  void _onSubmit() {
    final inputText = _textController.text.trim();
    if (inputText.isEmpty) return;

    debugPrint('Submitted text: $inputText');
    var myTodo = todoItemVM.createInstance()!;
    myTodo.string('label')!.value = inputText;
    myTodo.string('fontIcon')!.value = "";
    myTodo.color('hoverColor')!.value = const Color(0xffefefef);
    menuList.add(myTodo);
    myTodo.dispose();

    // Clear the input
    _textController.clear();
  }

  void _onSwap() {
    final num1Text = _num1Controller.text.trim();
    final num2Text = _num2Controller.text.trim();

    if (num1Text.isEmpty || num2Text.isEmpty) return;

    final num1 = int.tryParse(num1Text);
    final num2 = int.tryParse(num2Text);

    if (num1 != null && num2 != null) {
      try {
        menuList.swap(num1, num2);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error swapping items: $e')),
        );
      }
    }
  }

  void _onDelete() {
    final deleteText = _deleteController.text.trim();
    if (deleteText.isEmpty) return;

    final deleteIndex = int.tryParse(deleteText);
    if (deleteIndex != null) {
      try {
        menuList.removeAt(deleteIndex);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting item: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Binding Lists'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Rive Widget
          Expanded(
            child: RiveWidgetBuilder(
              fileLoader: fileLoader,
              dataBind: DataBind.auto(),
              onLoaded: _onLoaded,
              builder: (context, state) => switch (state) {
                RiveLoading() =>
                  const Center(child: CircularProgressIndicator()),
                RiveFailed() => ErrorWidget.withDetails(
                    message: state.error.toString(),
                    error: FlutterError(state.error.toString()),
                  ),
                RiveLoaded() => RiveWidget(controller: state.controller),
              },
            ),
          ),

          // Controls Panel
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Add Item Section
                const Text(
                  'Add New Item',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        decoration: const InputDecoration(
                          hintText: 'Enter item text',
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (_) => _onSubmit(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _onSubmit,
                      child: const Text('Add'),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Swap Items Section
                const Text(
                  'Swap Items',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _num1Controller,
                        decoration: const InputDecoration(
                          hintText: 'Index 1',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _num2Controller,
                        decoration: const InputDecoration(
                          hintText: 'Index 2',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _onSwap,
                      child: const Text('Swap'),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Delete Item Section
                const Text(
                  'Delete Item',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _deleteController,
                        decoration: const InputDecoration(
                          hintText: 'Index to delete',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _onDelete,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
