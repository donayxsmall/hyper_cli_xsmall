import 'dart:io';

import 'package:hyper_cli/hyper_cli.dart' as hyper_cli;

void main(List<String> arguments) {
  print('Hello world: ${hyper_cli.calculate()}!');
  print("arguments : $arguments");

  if (arguments[0] == "create") {
    String moduleName = arguments[1];

    print("Kamu sedang mencoba membuat module $moduleName");

    var viewDir = Directory("./lib/module/$moduleName/view/");
    viewDir.createSync(recursive: true);

    var controllerDir = Directory('./lib/module/$moduleName/controller/');
    controllerDir.createSync(recursive: true);

    createController(moduleName, controllerDir);
    createView(moduleName, viewDir);

    // String lowerCaseWithUnderscore = moduleName.toLowercaseUnderscore();

    // print(lowerCaseWithUnderscore);
  }
}

createController(String moduleName, Directory controllerDir) {
  String controllerTemplate = """
      import 'package:flutter/material.dart';
      import '../view/import_name_view.dart';

      class LoginController extends State<LoginView> {
        @override
        void initState() {
          super.initState();
        }

        @override
        void dispose() {
          super.dispose();
        }

        @override
        Widget build(BuildContext context) => widget.build(context, this);
      }

      """;

  String className = moduleName.toPascalCase();
  String variableName = moduleName.toCamelCase();
  String lowerCaseWithUnderscore = moduleName.toLowercaseUnderscore();
  controllerTemplate = controllerTemplate.replaceAll("Login", className);
  controllerTemplate = controllerTemplate.replaceAll("login", variableName);
  controllerTemplate =
      controllerTemplate.replaceAll("import_name", lowerCaseWithUnderscore);

  var viewController =
      File("${controllerDir.path}/${moduleName}_controller.dart");
  File(viewController.path).createSync();
  viewController.writeAsString(controllerTemplate);
}

createView(String moduleName, Directory viewDir) {
  String viewTemplate = """
import 'package:flutter/material.dart';
import '../controller/import_name_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => LoginController();

  build(BuildContext context, LoginController controller) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(children: const [
        // content
      ]),
    );
  }
}
""";

  String className = moduleName.toPascalCase();
  String variableName = moduleName.toCamelCase();
  String lowerCaseWithUnderscore = moduleName.toLowercaseUnderscore();
  viewTemplate = viewTemplate.replaceAll("Login", className);
  viewTemplate = viewTemplate.replaceAll("login", variableName);
  viewTemplate =
      viewTemplate.replaceAll("import_name", lowerCaseWithUnderscore);

  var viewFile = File("${viewDir.path}/${moduleName}_view.dart");
  File(viewFile.path).createSync();
  viewFile.writeAsString(viewTemplate);
}

extension StringExtension on String {
  String toPascalCase() {
    final words = split(' ');
    final pascalWords =
        words.map((word) => word[0].toUpperCase() + word.substring(1));
    return pascalWords.join();
  }

  String toCamelCase() {
    var result = "";
    var words = split(" ");
    for (var i = 0; i < words.length; i++) {
      var word = words[i];
      if (i == 0) {
        result += word.toLowerCase();
        continue;
      }
      result += word[0].toUpperCase() + word.substring(1).toLowerCase();
    }
    return result;
  }

  String toLowercaseUnderscore() {
    return toLowerCase().replaceAll(" ", "_");
  }
}
