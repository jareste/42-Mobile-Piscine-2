import 'package:flutter/material.dart';
import 'apiCalls.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _index = 0;
  final _pageController = PageController();
  String _midText = '';
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter a location...'
                ),
                onChanged: (value) {
                  _midText = value;
                  setState(() {});
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.location_on),
              onPressed: () async {
                _midText = 'Geolocating...';
                _controller.clear();
                try {
                  Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                  String location = await apiCalls.fetchLocation(position.latitude, position.longitude);
                  _midText = 'Current location: $location';
                } catch (e) {
                  _midText = 'Failed to get current location: $e';
                }
                setState(() {});
              },
            ),
            /*IconButton(
              icon: Icon(Icons.location_on),
              onPressed: () async {
                _midText = 'Geolocated';
                _controller.clear();
                try {
                  Map<String, dynamic> weatherData = await apiCalls.fetchWeather('Barcelona');
                  // Do something with weatherData, for example:
                  _midText = 'Temperature in Barcelona: ${weatherData['temp_c']}°C';
                } catch (e) {
                  _midText = 'Failed to load weather data: $e';
                }
                setState(() {});
              },
            ),*/
          ],
        ),
      ),
            body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _index = index;
          });
        },
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Currently', style: TextStyle(fontSize: 56, color: Colors.lightBlueAccent),),
                Text(_midText, style: TextStyle(fontSize: 10, color: Colors.redAccent),),
              ],
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Today', style: TextStyle(fontSize: 24, color: Colors.purple),),
                Text(_midText, style: TextStyle(fontSize: 24, color: Colors.purple),),
              ],
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Weekly', style: TextStyle(fontSize: 10, color: Colors.red),),
                Text(_midText, style: TextStyle(fontSize: 56, color: Colors.lightBlueAccent)),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (index) {
          _pageController.animateToPage(index, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.sunny), label: 'Currently'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Today'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Weekly'),
        ],
      ),
    );
  }
}