package solution;

import java.util.HashSet;
import java.util.Set;
import java.util.function.Function;
import java.util.stream.Collectors;

public class Scanner {

    private final Set<Point> beacons;

    public Scanner() {
        this(new HashSet<>());
    }

    public Scanner(Set<Point> beacons) {
        this.beacons = beacons;
    }

    public void addRawPoint(final String line) {
        String[] split = line.split(",");
        beacons.add(new Point(Integer.parseInt(split[0]), Integer.parseInt(split[1]), Integer.parseInt(split[2])));
    }

    public Scanner applyRotation(Function<Point, Point> rotation) {
        Set<Point> rotated = beacons.stream().map(rotation).collect(Collectors.toSet());
        return new Scanner(rotated);
    }

    public Scanner byAdding(Point other) {
        Set<Point> next = beacons.stream().map(point -> point.add(other)).collect(Collectors.toSet());
        return new Scanner(next);
    }

    public Set<Point> getBeacons() {
        return beacons;
    }
}