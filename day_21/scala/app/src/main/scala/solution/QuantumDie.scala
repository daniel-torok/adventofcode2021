package solution

object QuantumDie {

  def roll: Seq[Int] = for (i <- Range(1, 4); j <- Range(1, 4); k <- Range(1, 4)) yield i + j + k

}
