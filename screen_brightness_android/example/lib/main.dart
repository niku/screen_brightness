import 'package:flutter/material.dart';
import 'package:screen_brightness_platform_interface/screen_brightness_platform_interface.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static final RouteObserver<Route> routeObserver = RouteObserver<Route>();

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
      onGenerateRoute: (settings) {
        late final Widget page;
        switch (settings.name) {
          case HomePage.routeName:
            page = const HomePage();
            break;

          case ControllerPage.routeName:
            page = const ControllerPage();
            break;

          case RouteAwarePage.routeName:
            page = const RouteAwarePage();
            break;

          case BlankPage.routeName:
            page = const BlankPage();
            break;

          default:
            throw UnimplementedError('page name not found');
        }

        return MaterialPageRoute(
          builder: (context) => page,
          settings: settings,
        );
      },
      navigatorObservers: [
        routeObserver,
      ],
    );
  }
}

class HomePage extends StatelessWidget {
  static const routeName = '/home';

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen brightness example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FutureBuilder<double>(
              future: ScreenBrightnessPlatform.instance.current,
              builder: (context, snapshot) {
                double currentBrightness = 0;
                if (snapshot.hasData) {
                  currentBrightness = snapshot.data!;
                }

                return StreamBuilder<double>(
                  stream: ScreenBrightnessPlatform
                      .instance.onCurrentBrightnessChanged,
                  builder: (context, snapshot) {
                    double changedBrightness = currentBrightness;
                    if (snapshot.hasData) {
                      changedBrightness = snapshot.data!;
                    }

                    return Text('current brightness $changedBrightness');
                  },
                );
              },
            ),
            ElevatedButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(ControllerPage.routeName),
              child: const Text('Controller example page'),
            ),
            ElevatedButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(RouteAwarePage.routeName),
              child: const Text('Route aware example page'),
            )
          ],
        ),
      ),
    );
  }
}

class ControllerPage extends StatefulWidget {
  static const routeName = '/controller';

  const ControllerPage({Key? key}) : super(key: key);

  @override
  State<ControllerPage> createState() => _ControllerPageState();
}

class _ControllerPageState extends State<ControllerPage> {
  Future<void> setBrightness(double brightness) async {
    try {
      await ScreenBrightnessPlatform.instance.setScreenBrightness(brightness);
    } catch (e) {
      debugPrint(e.toString());
      throw 'Failed to set brightness';
    }
  }

  Future<void> resetBrightness() async {
    try {
      await ScreenBrightnessPlatform.instance.resetScreenBrightness();
    } catch (e) {
      debugPrint(e.toString());
      throw 'Failed to reset brightness';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Controller'),
      ),
      body: Center(
        child: FutureBuilder<double>(
          future: ScreenBrightnessPlatform.instance.current,
          builder: (context, snapshot) {
            double currentBrightness = 0;
            if (snapshot.hasData) {
              currentBrightness = snapshot.data!;
            }

            return StreamBuilder<double>(
              stream:
                  ScreenBrightnessPlatform.instance.onCurrentBrightnessChanged,
              builder: (context, snapshot) {
                double changedBrightness = currentBrightness;
                if (snapshot.hasData) {
                  changedBrightness = snapshot.data!;
                }

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Current brightness: $changedBrightness'),
                    Slider.adaptive(
                      value: changedBrightness,
                      onChanged: (value) {
                        setBrightness(value);
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        resetBrightness();
                      },
                      child: const Text('reset brightness'),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class RouteAwarePage extends StatefulWidget {
  static const routeName = '/routeAware';

  const RouteAwarePage({Key? key}) : super(key: key);

  @override
  _RouteAwarePageState createState() => _RouteAwarePageState();
}

class _RouteAwarePageState extends State<RouteAwarePage> with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    MyApp.routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    MyApp.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    super.didPush();
    ScreenBrightnessPlatform.instance.setScreenBrightness(0.7);
  }

  @override
  void didPushNext() {
    super.didPushNext();
    ScreenBrightnessPlatform.instance.resetScreenBrightness();
  }

  @override
  void didPop() {
    super.didPop();
    ScreenBrightnessPlatform.instance.resetScreenBrightness();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    ScreenBrightnessPlatform.instance.setScreenBrightness(0.7);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Route aware'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).pushNamed(BlankPage.routeName),
          child: const Text('Next page'),
        ),
      ),
    );
  }
}

class BlankPage extends StatelessWidget {
  static const routeName = '/blankPage';

  const BlankPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blank'),
      ),
    );
  }
}
