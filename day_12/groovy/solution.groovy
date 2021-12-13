import groovy.transform.Field

@Field
def graph = new File("input.data").inject([:]) { acc, line ->
  def (left, right) = line.split("-")
  acc.putIfAbsent(left, [].toSet())
  acc.putIfAbsent(right, [].toSet())
  if (left != "end" && right != "start") {
    acc[left].add(right)
  }
  if (left != "start" && right != "end") {
    acc[right].add(left)
  }
  return acc
}

def countPaths(current, visited, smallTwice) {
  if (current == "end") {
    return 1
  }

  smallTwice = smallTwice || visited.contains(current)
  def nexts = graph[current].minus(smallTwice ? visited : [])
  if (nexts.isEmpty()) {
    return 0
  }

  if (current.toLowerCase() == current) {
    visited.add(current)
  }

  return nexts.collect { this.countPaths(it, visited.clone(), smallTwice) }.sum()
}

println "First: " + countPaths("start", [].toSet(), true)
println "Second: " + countPaths("start", [].toSet(), false)
