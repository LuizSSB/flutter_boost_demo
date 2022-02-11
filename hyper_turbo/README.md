# Preparing a Flutter module to be integrated in an existing app

Flutte's CLI tool let you create a project explicitly meant to be integrated into an existing app:

	$ flutter create -t module --org <org.identifier> <project_name>

It is advised to create the Flutter module outside of the directory of either platform and have a repository only for it: as the intention is to share this module with both the iOS and Android codebases, it does not *belong* to either one, so it does not make sense to add it to the version control of either one.

Next, add the following dependency to the module (in the `pubspec.yaml`) and run `$ flutter pub get`:

    dependencies:
      # ...
      flutter_boost:
        git:
          url: 'https://github.com/luizssb/flutter_boost.git'
          ref: 'fix/general'

FlutterBoost's [original repository](https://github.com/alibaba/flutter_boost) is a bit of a mess and its master branch, as of this writing, was not up-to-date with latest version of the SDKs of both Flutter and Android - so it would cause some compilation errors. For this example, I am using a fork of the repository which fixes these errors and includes null-safety for the Dart code.

Now it is necessary to configure and initialize FlutterBoost in the Flutter module, so it can be called from the native side.

The first step is to create a subclass of  `WidgetsFlutterBinding`  that includes the `BoostFlutterBinding` mixin. This mixin is used and required internally by FlutterBoost .

	class CustomFlutterBinding extends WidgetsFlutterBinding
	    with BoostFlutterBinding {}

After that, just create an instance of this class in the `main()` function. The superclasses of `WidgetsFlutterBinding` call some instance methods that call up the behavior mixed in from `BoostFlutterBinding` and allows it to do whatever it is that FlutterBoost requires.

At the top of the widget hierarchy, there must be an instance of `FlutterBoostApp`. It can be instantiated like this:

    FlutterBoostApp(
    
	  // handles navigation requests from within the module, or from the native code
      (RouteSettings? settings, String? uniqueId) {
      
        // `RouteSettings.name` specifies which page was requested
        switch(settings?.name) {
        
	      // `MaterialPageRoute` includes animations, should the page be requested from within the module
          case 'flutterPage': return MaterialPageRoute<dynamic>(
              settings: settings,
              builder: (_) => // Widget...
          );

		  // returning null indicates that whatever page was requested is a native one
          case null: return null;
        }
        
        return null;
      }
    );

For navigating from within the Flutter module to another page on it, or to a native one, you can simply:
  
	  const pageName = 'page';  
	  const arguments = { 'foo': 'bar' };  
	  BoostNavigator.instance.push(pageName, arguments: arguments);

As for the pages themselves, they can be normal widgets as usual - no special requirement.
