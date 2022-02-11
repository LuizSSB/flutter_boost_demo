import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';

// luizssb: Flutter boost requires an implementation of `WidgetsFlutterBinding`
// that behaves as specified in mixin `BoostFlutterBinding`, so we just create
// this class with a trait
class CustomFlutterBinding extends WidgetsFlutterBinding
    with BoostFlutterBinding {}

void main() {
  // luizssb: merely instantiating the class is enough to register the required
  // behaviour, as one of the super constructors calls an instance method
  // implemented by the mixin
  CustomFlutterBinding();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // luizssb: definition of the routes/pages that will be loaded from the native
  // side into the Flutter. Make sure to build `MaterialPageRoute`s for the app's
  // pages, as they include transition animations which are used in case one of
  // the Flutter pages navigate to another one.
  // In this example, the root route is not used anywhere, I do not think it is
  // necessary.
  static Map<String, FlutterBoostRouteFactory> routerMap = {
    '/': (settings, uniqueId) {
      return PageRouteBuilder<dynamic>(
          settings: settings,
          pageBuilder: (_, __, ___) => Container()
      );
    },

    // luizssb: to keep things simple, in this demonstration we use the same
    // component for all routes, and just change its title (shown in the
    // NavigationBar)
    'flutterPage': (settings, uniqueId) {
      return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (_) => const MyHomePage(title: "Página Un")
      );
    },
    'flutterPage2': (settings, uniqueId) {
      return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (_) => const MyHomePage(title: "Página Deux"),
      );
    },
    'flutterPage3': (settings, uniqueId) {
      return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (_) => const MyHomePage(title: "Página Trois")
      );
    }
  };

  // luizssb: function to be called whenever the Flutter side of FlutterBoost
  // receives a navigation request to some particular page. As this navigation
  // request can be for either the Flutter or native sides of the app, we must
  // check if the route is present in our `routerMap` - if it is not, we return
  // null to indicate that it is a request to navigate to some ViewController/Activity.
  Route<dynamic>? routeFactory(RouteSettings? settings, String? uniqueId) {
    var func = routerMap[settings!.name!];
    return func == null
      ? null
      : func(settings, uniqueId);
  }

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    FlutterBoostApp(
      (RouteSettings? settings, String? uniqueId) {
        switch(settings?.name) {
          case 'flutterPage': return MaterialPageRoute<dynamic>(
              settings: settings,
              builder: (_) => const MyHomePage(title: "Página Trois")
          );
          case null: return null;
        }
        return null;
      }
    );
    // luizssb: instantiates a FlutterBoost-managed app component with a route
    // factory. See below how navigation is handled; in short FlutterBoost
    // receives a navigation request to some specific route and send it to this
    // factory argument; if it returns null (as we do, above, when the specified
    // route is not present in our `routeMap`), it means that the route refers to
    // a native page, so it sends the request to the native code. Otherwise, it
    // presents the resultant component.
    return FlutterBoostApp(routeFactory);
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  // luizssb: the two methods below perform navigation.
  // The first one navigates to a native page (ViewController/Activity).
  // The second one navigates to a Flutter page.
  // Notice that we use the same method for both cases.
  // constructor; if it returns a null component for the route (as we do

  void _navigateNative() {
    BoostNavigator.instance.push("main");
  }

  void _navigateFlutter() {
    const pageName = 'page';
    const arguments = {
      "foo": "bar"
    };
    BoostNavigator.instance.push(pageName, arguments: arguments);
  }

  // luizssb: this method sends an instruction to the native part of the app,
  // for it to handle backing off from the current page. It is only necessary
  // on iOS, as Android has the system-default back button.
  void _back() {
    BoostNavigator.instance.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox.fromSize(
              size: const Size(1, 2),
            ),
            MaterialButton(
              child: const Text("Ir para tela nativa"),
              color: Colors.red,
              onPressed: _navigateNative,
            ),
            MaterialButton(
              child: const Text("Ir para tela flutter"),
              color: Colors.red,
              onPressed: _navigateFlutter,
            ),
            MaterialButton(
              child: const Text("Voltar para trás"),
              color: Colors.red,
              onPressed: _back,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
