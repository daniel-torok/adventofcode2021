import 'package:quiver/core.dart';

typedef Matrix = List<List<Waypoint>>;

extension CoordIndex on Matrix {
  Waypoint get(Coord coord) {
    return this[coord.y][coord.x];
  }
  void set(Coord coord, Waypoint waypoint) {
    this[coord.y][coord.x] = waypoint;
  }
}

class Coord {
  final int x;
  final int y;

  const Coord(this.x, this.y);

  @override
  String toString() => '($x, $y)';

  @override
  bool operator ==(Object other) =>
    other is Coord && other.x == x && other.y == y;

  @override
  int get hashCode => hash2(x.hashCode, y.hashCode);

  Coord operator+(Coord other) => Coord(x + other.x, y + other.y);
}

class Waypoint {
  final int risk;
  final int sum;

  const Waypoint(this.risk, this.sum);

  @override
  String toString() => '($risk, $sum)';

  @override
  bool operator ==(Object other) =>
    other is Waypoint && other.risk == risk && other.sum == sum;

  @override
  int get hashCode => hash2(risk.hashCode, sum.hashCode);

  Waypoint withSum(int val) => Waypoint(risk, val);
  Waypoint withRisk(int val) => Waypoint(val, sum);
}
