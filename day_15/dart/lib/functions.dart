import 'package:dart/types.dart' as t;

const int intMax = 1<<63 - 1;
const deltas = [t.Coord(-1, 0), t.Coord(0, -1), t.Coord(1, 0), t.Coord(0, 1)];
List<t.Waypoint> parseWaypoint(String line) => line.split('').map((e) => t.Waypoint(int.parse(e), intMax)).toList(); 

extension Range on num {
  bool isBetween(num from, num to) {
    return from < this && this < to;
  }
}

extension Pop<T> on Set<T> {
  T pop() {
    var value = first;
    remove(first);
    return value;
  }
}

checkBounds(t.Matrix matrix) => (t.Coord coord) {
  var rows = matrix.length;
  var cols = matrix.first.length;
  return coord.x.isBetween(-1, rows) && coord.y.isBetween(-1, cols);
};

Iterable<t.Coord> getAdjacent(t.Matrix matrix, t.Coord base) {
  return deltas.map((e) => e + base).where(checkBounds(matrix));
}
