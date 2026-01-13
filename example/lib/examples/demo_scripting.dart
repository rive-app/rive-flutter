import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:rive_example/main.dart' show RiveExampleApp;

class DemoScripting extends StatefulWidget {
  const DemoScripting({super.key});

  @override
  State<DemoScripting> createState() => _DemoScriptingState();
}

class _DemoScriptingState extends State<DemoScripting>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final List<String> _tabTitles = [
    'Blinko',
    'Centaur Game',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabTitles.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TabBar(
            controller: _tabController,
            tabs: _tabTitles.map((title) => Tab(text: title)).toList(),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              _BlinkoExample(),
              _CentaurGame(),
            ],
          ),
        ),
      ],
    );
  }
}

class _BlinkoExample extends StatefulWidget {
  const _BlinkoExample();

  @override
  State<_BlinkoExample> createState() => __BlinkoExampleState();
}

class __BlinkoExampleState extends State<_BlinkoExample> {
  late final fileLoader = FileLoader.fromAsset(
    'assets/blinko.riv',
    riveFactory: RiveExampleApp.getCurrentFactory,
  );

  @override
  void dispose() {
    // This widget state owns the file loader, dispose it.
    fileLoader.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RiveWidgetBuilder(
      fileLoader: fileLoader,
      dataBind: DataBind.auto(),
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
          )
      },
    );
  }
}

class _CentaurGame extends StatefulWidget {
  const _CentaurGame();

  @override
  State<_CentaurGame> createState() => __CentaurGameState();
}

class __CentaurGameState extends State<_CentaurGame> {
  late final fileLoader = FileLoader.fromAsset(
    'assets/centaur_game.riv',
    riveFactory: RiveExampleApp.getCurrentFactory,
  );
  @override
  void dispose() {
    // This widget state owns the file loader, dispose it.
    fileLoader.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check if running on mobile
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            'This demo only has controls for desktop.',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return RiveWidgetBuilder(
      fileLoader: fileLoader,
      dataBind: DataBind.auto(),
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
          )
      },
    );
  }
}
