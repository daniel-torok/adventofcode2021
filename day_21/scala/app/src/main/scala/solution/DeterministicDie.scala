package solution

object DeterministicDie {
  var value: Int = 0
  var numberOfRolls = 0

  def roll(): Int = _roll() + _roll() + _roll()

  private def _roll(): Int = {
    numberOfRolls += 1
    value += 1
    if (value > 100) {
      value = 1
    }
    value
  }
}
