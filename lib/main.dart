import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FadingTextAnimation(changeTheme: changeTheme),
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeMode,
      debugShowCheckedModeBanner: false,
    );
  }
}

class FadingTextAnimation extends StatefulWidget {
  final Function(ThemeMode) changeTheme;
  
  const FadingTextAnimation({super.key, required this.changeTheme});

  @override
  _FadingTextAnimationState createState() => _FadingTextAnimationState();
}

class _FadingTextAnimationState extends State<FadingTextAnimation> {
  bool _isVisible = true;
  Color _textColor = Colors.black;
  final PageController _pageController = PageController();

  void toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  void changeTextColor(Color color) {
    setState(() {
      _textColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fading Text Animation'),
        actions: [
          IconButton(
            icon: Theme.of(context).brightness == Brightness.dark ? Icon(Icons.sunny) : Icon(Icons.nights_stay),
            onPressed: () => widget.changeTheme(Theme.of(context).brightness == Brightness.dark ? ThemeMode.light : ThemeMode.dark),
          ),
          IconButton(
            icon: const Icon(Icons.color_lens),
            onPressed: () async {
              Color? pickedColor = await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Pick a color'),
                content: SingleChildScrollView(
                child: BlockPicker(
                  pickerColor: Colors.black,
                  onColorChanged: (color) {
                  Navigator.of(context).pop(color);
                  },
                ),
                ),
              ),
              );
              if (pickedColor != null) {
                changeTextColor(pickedColor);
              }
            },
          )
        ],
      ),
      body: PageView(
        controller: _pageController,
        children: [
          Center(
            child: AnimatedOpacity(
              opacity: _isVisible ? 1.0 : 0.0,
              duration: Duration(seconds: 1),
              child: Text(
                'Hello, Flutter!',
                style: TextStyle(fontSize: 24, color: _textColor),
              ),
            ),
          ),
          Center(
            child: AnimatedOpacity(
              opacity: _isVisible ? 1.0 : 0.0,
              duration: Duration(seconds: 3),
              child: Text(
                'Hello, World!',
                style: TextStyle(fontSize: 24, color: _textColor),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleVisibility,
        child: Icon(Icons.play_arrow),
      ),
    );
  }
}

final ThemeData lightTheme = ThemeData(
  textTheme: TextTheme(
    bodyMedium: TextStyle(fontSize: 18, color: Colors.black),
  ),
);

final ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.dark(
    primary: Colors.blue,
  ),
  scaffoldBackgroundColor: const Color.fromARGB(255, 38, 38, 38),
  textTheme: TextTheme(
    bodyMedium: TextStyle(fontSize: 18, color: Colors.white),
  ),
);