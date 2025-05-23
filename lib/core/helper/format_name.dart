String formatName(String name) {
  String result = "";
  int x = 0;
  for (int i = 0; i < name.length; i++) {
    if (name[i] == ' ') {
      x++;
      if (x == 2) {
        result = name.substring(0, i);
      }
    }
  }
  return result;
}
