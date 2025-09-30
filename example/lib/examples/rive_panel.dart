import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class ExampleRivePanel extends StatelessWidget {
  const ExampleRivePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return const RivePanel(
      // child: RowExample(),
      child: ListViewExample(),
    );
  }
}

class RowExample extends StatefulWidget {
  const RowExample({super.key});

  @override
  State<RowExample> createState() => _RowExampleState();
}

class _RowExampleState extends State<RowExample> {
  // Only useful when using `Factory.rive`. `Factory.flutter` draws to a single
  // render target already.
  final factory = Factory.rive;

  late List<FileLoader> listOfFileLoaders = [
    FileLoader.fromAsset(
      'assets/rating.riv',
      riveFactory: factory,
    ),
    FileLoader.fromAsset(
      'assets/vehicles.riv',
      riveFactory: factory,
    ),
    FileLoader.fromAsset(
      'assets/perf/rivs/travel_icons.riv',
      riveFactory: factory,
    ),
    FileLoader.fromAsset(
      'assets/coyote.riv',
      riveFactory: factory,
    ),
    FileLoader.fromAsset(
      'assets/perf/rivs/Tom_Morello_2.riv',
      riveFactory: factory,
    ),
    FileLoader.fromAsset(
      'assets/perf/rivs/towersDemo.riv',
      riveFactory: factory,
    ),
    FileLoader.fromAsset(
      'assets/perf/rivs/walking.riv',
      riveFactory: factory,
    ),
    FileLoader.fromAsset(
      'assets/perf/rivs/skull_404.riv',
      riveFactory: factory,
    ),
    FileLoader.fromAsset(
      'assets/perf/rivs/adventuretime_marceline_pb.riv',
      riveFactory: factory,
    ),
    FileLoader.fromAsset(
      'assets/perf/rivs/Zombie_Character.riv',
      riveFactory: factory,
    ),
  ];

  @override
  void dispose() {
    for (var fileLoader in listOfFileLoaders) {
      fileLoader.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0),
      child: SingleChildScrollView(
        child: Wrap(
          children: [
            ...listOfFileLoaders
                .map((fileLoader) => SizedSample(fileLoader: fileLoader)),
          ],
        ),
      ),
    );
  }
}

class SizedSample extends StatelessWidget {
  const SizedSample({super.key, required this.fileLoader});

  final FileLoader fileLoader;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: MyRiveWidget(fileLoader: fileLoader),
    );
  }
}

class ListViewExample extends StatefulWidget {
  const ListViewExample({super.key});

  @override
  State<ListViewExample> createState() => _ListViewExampleState();
}

class _ListViewExampleState extends State<ListViewExample> {
  late final fileLoader = FileLoader.fromAsset(
    'assets/rating.riv',
    riveFactory: Factory.rive,
  );

  @override
  void dispose() {
    fileLoader.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return SizedBox(
          width: 500,
          height: 100,
          child: MyRiveWidget(fileLoader: fileLoader),
        );
      },
    );
  }
}

class MyRiveWidget extends StatelessWidget {
  const MyRiveWidget({super.key, required this.fileLoader});
  final FileLoader fileLoader;

  @override
  Widget build(BuildContext context) {
    return RiveWidgetBuilder(
      fileLoader: fileLoader,
      builder: (context, state) => switch (state) {
        RiveLoading() => const Center(
            child: Center(child: CircularProgressIndicator()),
          ),
        RiveFailed() => ErrorWidget.withDetails(
            message: state.error.toString(),
            error: FlutterError(state.error.toString()),
          ),
        RiveLoaded() => RiveWidget(
            controller: state.controller,
            fit: Fit.contain,

            /// Set this to true to draw to the nearest `RivePanel`
            useSharedTexture: true,
          )
      },
    );
  }
}
