package solution;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.*;
import java.util.function.Function;

public class App {

    private void doMain() throws Exception {
        List<Scanner> scanners = readData("input.data");
        List<Point> positions = new ArrayList<>(List.of(new Point(0, 0, 0)));

        Scanner mainScanner = scanners.remove(0);
        while (!scanners.isEmpty()) {
            Scanner next = scanners.remove(0);
            boolean found = false;

            search_intersection:
            for (Function<Point, Point> rotation : Point.rotations) {
                Scanner rotated = next.applyRotation(rotation);

                for (Point mainPoint : mainScanner.getBeacons()) {
                    for (Point nextPoint : rotated.getBeacons()) {

                        Point diff = mainPoint.diff(nextPoint);
                        Scanner shifted = rotated.byAdding(diff);

                        HashSet<Point> intersection = new HashSet<>(shifted.getBeacons());
                        intersection.retainAll(mainScanner.getBeacons());
                        if (intersection.size() >= 12) {
                            found = true;

                            mainScanner.getBeacons().addAll(shifted.getBeacons());
                            positions.add(diff);

                            break search_intersection;
                        }
                    }
                }
            }

            if (!found) {
                scanners.add(next);
            }
        }

        System.out.printf("Part one: %d%n", mainScanner.getBeacons().size());
        System.out.printf("Part two: %d%n", getMaxDistance(positions));
    }

    private int getMaxDistance(List<Point> positions) {
        int max = Integer.MIN_VALUE;
        for (Point posA : positions) {
            for (Point posB : positions) {
                max = Math.max(max, posA.distance(posB));
            }
        }
        return max;
    }

    private List<Scanner> readData(String fileName) throws Exception {
        InputStream is = Thread.currentThread().getContextClassLoader().getResourceAsStream(fileName);
        BufferedReader reader = new BufferedReader(new InputStreamReader(Objects.requireNonNull(is)));

        Scanner scanner = null;
        List<Scanner> scanners = new ArrayList<>();

        String line;
        while ((line = reader.readLine()) != null) {
            if (line.isBlank()) {
                continue;
            }
            if (line.startsWith("---")) {
                scanner = new Scanner();
                scanners.add(scanner);
                continue;
            }
            scanner.addRawPoint(line);
        }

        return scanners;
    }

    public static void main(String[] args) throws Exception {
        new App().doMain();
    }

}
