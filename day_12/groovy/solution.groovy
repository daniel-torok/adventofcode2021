import groovy.transform.Field

def putIfAbsent(coll, key, val) {
  if (!coll.containsKey(key)) {
    coll.put(key, val)
  }
}

def isAllLowerCase(str) {
  return str.toCharArray().every(Character::isLowerCase)
}

@Field
def graph = new File("input.data").inject([:]) { acc, line ->
  def (left, right) = line.split("-")
  putIfAbsent(acc, left, [].toSet())
  putIfAbsent(acc, right, [].toSet())
  acc[left].add(right)
  acc[right].add(left)
  return acc
}

def countPaths(current, visited) {
  if (current == "end") {
    return 1
  }

  def nexts = graph[current].minus(visited)
  if (nexts.isEmpty()) {
    return 0
  }

  visited = visited.collect().toSet()
  if (this.isAllLowerCase(current)) {
    visited.add(current)
  }

  return nexts.collect { this.countPaths(it, visited.collect().toSet()) }.sum()
}

println "First: " + countPaths("start", [].toSet())
