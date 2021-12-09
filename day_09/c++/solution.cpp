#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <numeric>

using namespace std;

struct Point {
  int row;
  int col;
  int value;
};

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

vector<Point> collect_mins(vector< vector<int> >& data, int row_count, int col_count)
{
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

int get_basin_size(const vector< vector<int> > data, Point point) {
  return 0;
}

int main()
{
  auto data = read("input.data");
  auto row_count = data.size();
  auto col_count = data[0].size();

  auto mins = collect_mins(data, row_count, col_count);

  auto risk_factor = reduce(
    mins.begin(), mins.end(), 0,
    [](int& acc, Point& point) -> int { return acc + point.value; }
  ) + mins.size();
  cout << "First: " << risk_factor << endl;
  
  vector<int> basins;
  transform(mins.begin(), mins.end(), back_inserter(basins),
    [&data](Point& point) -> int { return get_basin_size(data, point);  }
  );
  sort(basins.begin(), basins.end());

  return 0;
}
