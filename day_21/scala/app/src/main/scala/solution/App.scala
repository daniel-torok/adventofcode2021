package solution

object App {

  def main(args: Array[String]): Unit = {
    println(s"Part one: ${ part1(Array(6 - 1, 8 - 1), Array(0, 0)) }")
    println(s"Part two: ${ part2((6 - 1, 8 - 1), (0, 0), true).max }")
  }

  def part1(positions: Array[Int], scores: Array[Int]): Int = {
    val winThreshold = 1000
    var index = 0
    var win = false

    while (!win) {
      val dieRoll = DeterministicDie.roll() % 10
      positions(index) = (positions(index) + dieRoll) % 10
      scores(index) += positions(index) + 1

      win = scores(index) >= winThreshold
      index = (index + 1) % 2
    }
    scores(index) * DeterministicDie.numberOfRolls
  }

  val defaultElem: (Long, Long) = (0, 0)
  val memo: scala.collection.mutable.Map[((Int, Int),(Int, Int), Boolean), (Long, Long)] = scala.collection.mutable.Map()

  def part2(positions: (Int, Int), scores: (Int, Int), first: Boolean): (Long, Long) = {
    val memoized = memo.get((positions, scores, first)).orNull
    if (memoized != null) {
      return memoized
    }

    if (scores._1 >= 21) {
      return (1, 0)
    }
    if (scores._2 >= 21) {
      return (0, 1)
    }

    val results = QuantumDie.roll.map(roll => {
      val next: ((Int, Int), (Int, Int)) = if (first) {
        val nextPosition = (positions._1 + roll) % 10
        ((nextPosition, positions._2), (scores._1 + nextPosition + 1, scores._2))
      } else {
        val nextPosition = (positions._2 + roll) % 10
        ((positions._1, nextPosition), (scores._1, scores._2 + nextPosition + 1))
      }

      part2(next._1, next._2, !first)
    }).foldLeft(defaultElem)(_ + _)

    memo.addOne((positions, scores, first), results)
    results
  }

  implicit class Tuple2Max(t: (Long, Long)) {
    def max = if (t._1 > t._2) t._1 else t._2
    def +(other: (Long, Long)) = (t._1 + other._1, t._2 + other._2)
  }

}
