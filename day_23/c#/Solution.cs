using System;
using System.Collections.Generic;
using System.Linq;

namespace AoC
{
  public class Board : IComparable<Board>
  {
    public static Dictionary<char, int> COST = new Dictionary<char, int>()
    {
      { 'A', 1 },
      { 'B', 10 },
      { 'C', 100 },
      { 'D', 1000 }
    };

    public static Dictionary<char, int> ROOM_IDX = new Dictionary<char, int>()
    {
      { 'A', 2 },
      { 'B', 4 },
      { 'C', 6 },
      { 'D', 8 }
    };

    public char[] hallway = new char[11];
    public Dictionary<char, char[]> rooms;
    public int cost;
    public int error;

    public Board(char[] hallway, Dictionary<char, char[]> rooms, int cost)
    {
      hallway.CopyTo(this.hallway, 0);
      this.rooms = new Dictionary<char, char[]>();
      this.error = 0;
      foreach (var entry in rooms)
      {
        char[] copy = new char[entry.Value.Length];
        rooms[entry.Key].CopyTo(copy, 0);
        this.rooms.Add(entry.Key, copy);
      }
      this.cost = cost;
    }

    public List<Board> NextMoves()
    {
      var ret = new List<Board>();
      for (var i=0; i<hallway.Length; i++)
      {
        if (hallway[i] == '.') continue;
        if (!rooms[hallway[i]].All(item => item == '.' || item == hallway[i])) continue;
        var distanceToRoom = ROOM_IDX[hallway[i]] - i;
        if (!Enumerable.Range(Math.Min(i+1, i+distanceToRoom), Math.Abs(distanceToRoom)).All(i => hallway[i] == '.')) continue;
        var hallwayCost = Math.Abs(distanceToRoom) * COST[hallway[i]];
        var roomIndex = rooms[hallway[i]].Length - 1;
        for (;roomIndex >= 0; roomIndex--)
        {
          if (rooms[hallway[i]][roomIndex] == '.') break;
        }
        var roomCost = (roomIndex+1) * COST[hallway[i]];

        Board newBoard = new Board(hallway, rooms, cost + roomCost + hallwayCost);
        newBoard.hallway[i] = '.';
        newBoard.rooms[hallway[i]][roomIndex] = hallway[i];
        ret.Add(newBoard);
      }

      foreach (var entry in rooms)
      {
        if (entry.Value.All(item => item == '.' || item == entry.Key)) continue;
        if (hallway[ROOM_IDX[entry.Key] - 1] != '.' && hallway[ROOM_IDX[entry.Key] + 1] != '.') continue;
        var roomIndex = 0;
        for (; roomIndex < entry.Value.Length; roomIndex++)
        {
          if (entry.Value[roomIndex] != '.') break;
        }
        var roomCost = (roomIndex + 1) * COST[entry.Value[roomIndex]];

        for (var j=ROOM_IDX[entry.Key] - 1; j>=0; j--)
        {
          if (hallway[j] != '.') break;
          if (j > 0 && j < 10 && j%2==0) continue;
          var hallwayCost = (ROOM_IDX[entry.Key] - j) * COST[entry.Value[roomIndex]];
          Board newBoard = new Board(hallway, rooms, cost + hallwayCost + roomCost);
          newBoard.hallway[j] = entry.Value[roomIndex];
          newBoard.rooms[entry.Key][roomIndex] = '.';
          ret.Add(newBoard);
        }
        for (var j=ROOM_IDX[entry.Key] + 1; j<hallway.Length; j++)
        {
          if (hallway[j] != '.') break;
          if (j > 0 && j < 10 && j%2==0) continue;
          var hallwayCost = (j - ROOM_IDX[entry.Key]) * COST[entry.Value[roomIndex]];
          Board newBoard = new Board(hallway, rooms, cost + hallwayCost + roomCost);
          newBoard.hallway[j] = entry.Value[roomIndex];
          newBoard.rooms[entry.Key][roomIndex] = '.';
          ret.Add(newBoard);
        }
      }
      return ret;
    }

    public bool IsWinner()
    {
      return rooms.All(room => room.Value.All(item => item == room.Key));
    }

    public bool Equals(Board a, Board b)
    {
      return (a.cost.Equals(b.cost) && a.hallway.Equals(b.hallway) && a.rooms.Equals(b.rooms));
    }

    public int GetHashCode(Board obj)
    {
      return HashCode.Combine(hallway, rooms);
    }

    public int CompareTo(Board? obj) {
      if (obj == null) return 1;
      return this.error.CompareTo(obj.error);
    }
  }
  public class Solution
  {
    public static Board board1 = new Board(
      new char[11] { '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.' },
      new Dictionary<char, char[]>() {
        { 'A', new char[] { 'D', 'B' } },
        { 'B', new char[] { 'B', 'D' } },
        { 'C', new char[] { 'A', 'A' } },
        { 'D', new char[] { 'C', 'C' } }
      },
      0
    );

    public static Board board2 = new Board(
      new char[11] { '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.' },
      new Dictionary<char, char[]>() {
        { 'A', new char[] { 'B', 'A' } },
        { 'B', new char[] { 'C', 'D' } },
        { 'C', new char[] { 'B', 'C' } },
        { 'D', new char[] { 'D', 'A' } }
      },
      0
    );

    public static void Main(string[] args)
    {
      Board board = board2;
      var moves = new PriorityQueue<Board, int>();
      var visited = new HashSet<Board>();
      moves.Enqueue(board, 0);

      while (moves.Count > 0)
      {
        var next = moves.Dequeue();
        if (visited.Contains(next))
        {
          continue;
        }
        visited.Add(next);
        if (next.IsWinner())
        {
          Console.WriteLine("Solution: " + next.cost);
          break;
        }

        foreach (var nextMove in next.NextMoves())
        {
          if (!visited.Contains(nextMove))
          {
            moves.Enqueue(nextMove, nextMove.cost);
          }
        }
      }

    }
  }
}
