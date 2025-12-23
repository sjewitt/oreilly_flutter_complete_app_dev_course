void main() {
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
  print(_movielist[2]);

  // a for loop!!
  for (String thing in _movielist) {
    print(thing);
  }

  // or
  for (int x = 0; x < _movielist.length; x++) {
    print(_movielist[x]);
  }
  print(0);
}
