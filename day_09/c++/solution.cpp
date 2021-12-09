#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <set>
#include <numeric>

using namespace std;

struct Point
{
  int row;
  int col;
  int value;
};

inline bool operator<(const Point& lhs, const Point& rhs)
{
  return (lhs.row < rhs.row) || ((lhs.row == rhs.row) && (lhs.col < rhs.col));
}

Point DELTAS[] = { { -1, 0 }, { 0, 1 },  { 1, 0 }, { 0, -1 } };

vector< vector<int> > read(string path)
{
  vector< vector<int> > data;

  ifstream file(path);
  string line;
  while (getline (file, line)) {
    vector<int> line_data;
    stringstream s(line);
    char digit;
    while (s.get(digit)) {
      line_data.push_back(digit - '0');
    }
    data.push_back(line_data);
  }
  file.close();

  return data;
}

bool is_min_in_area(vector< vector<int> > data, int row_count, int col_count, int row_idx, int col_idx, int value)
{
  if (row_idx > 0 && data[row_idx - 1][col_idx] <= value) {
    return false;
  }
  if (row_idx < row_count - 1 && data[row_idx + 1][col_idx] <= value) {
    return false;
  }
  if (col_idx > 0 && data[row_idx][col_idx - 1] <= value) {
    return false;
  }
  if (col_idx < col_count - 1 && data[row_idx][col_idx + 1] <= value) {
    return false;
  }
  return true;
}

vector<Point> collect_mins(vector< vector<int> >& data)
{
  auto row_count = data.size();
  auto col_count = data[0].size();

  vector<Point> mins;
  for (int row_idx = 0; row_idx < row_count; row_idx++) {
    for (int col_idx = 0; col_idx < col_count; col_idx++) {
      auto value = data[row_idx][col_idx];
      if (is_min_in_area(data, row_count, col_count, row_idx, col_idx, value)) {
        Point point = { row_idx, col_idx, value };
        mins.push_back(point);
      }
    }
  }
  return mins;
}

int get_basin_size(const vector< vector<int> > data, Point point)
{
  auto row_count = data.size();
  auto col_count = data[0].size();
  
  set<Point> visited;
  set<Point> unvisited = { point };

  while (!unvisited.empty())
  {
    auto next = *unvisited.begin();
    unvisited.erase(unvisited.begin());
    visited.insert(next);
  
    auto row_idx = next.row;
    auto col_idx = next.col;

    for (auto delta : DELTAS)
    {
      auto next_row_idx = row_idx + delta.row;
      auto next_col_idx = col_idx + delta.col;
      if (0 > next_row_idx || 0 > next_col_idx || row_count - 1 < next_row_idx || col_count - 1 < next_col_idx)
      {
        continue;
      }
      if (data[next_row_idx][next_col_idx] == 9)
      {
        continue;
      }
      Point point = { next_row_idx, next_col_idx, 0 };
      if (!visited.contains(point))
      {
        unvisited.insert(point);
      }
    }
  }
  return visited.size();
}

int main()
{
  auto data = read("input.data");
  auto mins = collect_mins(data);

  auto risk_factor = reduce(
    mins.begin(), mins.end(), 0,
    [](int& acc, Point& point) -> int { return acc + point.value; }
  ) + mins.size();
  cout << "First: " << risk_factor << endl;
  
  vector<int> basins;
  transform(mins.begin(), mins.end(), back_inserter(basins),
    [&data](Point& point) -> int { return get_basin_size(data, point);  }
  );
  sort(basins.begin(), basins.end(), greater());
  cout << "Second: " << basins[0] * basins[1] * basins[2] << endl;

  return 0;
}
