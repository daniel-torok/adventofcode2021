package solution;

import lombok.Data;

import java.util.List;
import java.util.function.Function;

@Data
public class Point {
    private final int x;
    private final int y;
    private final int z;

    public Point mul(Point other) {
        return new Point(x * other.x, y * other.y, z * other.z);
    }

    public Point diff(Point other) {
        return new Point(x - other.x, y - other.y, z - other.z);
    }

    public Point add(Point other) {
        return new Point(x + other.x, y + other.y, z + other.z);
    }

    public int distance(Point other) {
        Point diff = this.diff(other);
        return Math.abs(diff.x) + Math.abs(diff.y) + Math.abs(diff.z);
    }

    public static final List<Function<Point, Point>> rotations = List.of(
            p -> p,
            p -> new Point(-p.y, p.x, p.z),
            p -> new Point(-p.x, -p.y, p.z),
            p -> new Point(p.y, -p.x, p.z),
            p -> new Point(p.x, p.z, -p.y),
            p -> new Point(-p.z, p.x, -p.y),
            p -> new Point(-p.x, -p.z, -p.y),
            p -> new Point(p.z, -p.x, -p.y),
            p -> new Point(p.y, p.x, -p.z),
            p -> new Point(-p.x, p.y, -p.z),
            p -> new Point(-p.y, -p.x, -p.z),
            p -> new Point(p.x, -p.y, -p.z),
            p -> new Point(p.z, p.x, p.y),
            p -> new Point(-p.x, p.z, p.y),
            p -> new Point(-p.z, -p.x, p.y),
            p -> new Point(p.x, -p.z, p.y),
            p -> new Point(p.z, p.y, -p.x),
            p -> new Point(-p.y, p.z, -p.x),
            p -> new Point(-p.z, -p.y, -p.x),
            p -> new Point(p.y, -p.z, -p.x),
            p -> new Point(p.y, p.z, p.x),
            p -> new Point(-p.z, p.y, p.x),
            p -> new Point(-p.y, -p.z, p.x),
            p -> new Point(p.z, -p.y, p.x)
    );
}
