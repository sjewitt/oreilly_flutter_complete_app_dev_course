import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Home(),  // null
    );
  }
}

// to replace the Placeholder, we create a Widget that is the entrypoint for the app:
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  // we also need actual (dummy for now) data to pass into the ListView.builder:
  final _movielist = <String>[
    "The Shawshank Redemption",
    "The Godfather",
    "The Dark Knight",
    "The Godfather: Pt 2",
    "The Lord of the Rings: Return of the King",
    "Pulp Fiction",
    "Schindler's List",
    "The Terminator",
  ];

  @override
  Widget build(BuildContext context) {
    // we return a Scaffold here as the framework of the app route/page (URI)
    return Scaffold(
      appBar: AppBar(
        title: Text("Movies",),
      ),
      body: Center(child:ListView.builder(
        // as per the nomad thing!! OK...
        // `context` is here - i.e. the context includes the list?
        // index is the list item (visible?) index
        itemBuilder: (context, index){
          // this function will/should go into a provider...
          // It returns whatever will be put into each ListView entry:
          // Note also that `index` is implied
          // return Text("Item $index");
          // THIS is key!! The `context` includes this variable!
          return Text(_movielist[index]);
        },
        // and THIS property is a hint to how many should be displayed 
        // by default (it is NOT the max length of the list!)
        // itemCount: 20,
        // He does this:
        itemCount: _movielist.length,
        // but this assumes a FIXED LIST, and one that is not massively long...
      ),),
    );
  }
}
