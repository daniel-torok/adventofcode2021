import 'package:dart/functions.dart' as f;
import 'package:dart/types.dart' as t;
import 'dart:io';

t.Waypoint increaseRisk(t.Waypoint waypoint) {
  var value = waypoint.risk + 1;
  return waypoint.withRisk((value > 9) ? value - 9 : value);
}

t.Matrix parseMatrix(int iteration) {
  var current = File('data/input.data').readAsStringSync().split('\n').map(f.parseWaypoint).toList();
  t.Matrix matrix = [];
  for (var i = 0; i < iteration; i++) {
    matrix.addAll([...current]);
    current = current.map((e) => e.map(increaseRisk).toList()).toList();
  }

  matrix = matrix.map((e) {
    var current = [...e];
    List<t.Waypoint> altered = [];
    for (var i = 0; i < iteration; i++) {
      altered.addAll([...current]);
      current = current.map(increaseRisk).toList();
    }
    return altered;
  }).toList();

  matrix[0][0] = matrix[0][0].withSum(0);
  return matrix;
}

int totalRisk(t.Matrix matrix) {
  var visit = <t.Coord>{ t.Coord(0, 0) };

  while (visit.isNotEmpty) {
    var coord = visit.pop();
    var sum = matrix.get(coord).sum;

    for (var neighbour in f.getAdjacent(matrix, coord)) {
      var waypoint = matrix.get(neighbour);
      var cost = sum + waypoint.risk;

      if (cost < waypoint.sum) {
        matrix.set(neighbour, waypoint.withSum(cost));
        visit.add(neighbour);
      }
    }
  }

  return matrix.last.last.sum;
}

void main(List<String> arguments) {
  print('Part one: ' +  totalRisk(parseMatrix(1)).toString());
  print('Part two: ' +  totalRisk(parseMatrix(5)).toString());
}
