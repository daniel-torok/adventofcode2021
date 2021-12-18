class 
  SOLUTION

create
  make

feature

  x1 : INTEGER_64 = 185
  x2 : INTEGER_64 = 221
  y1 : INTEGER_64 = -74
  y2 : INTEGER_64 = -122
  --x1 : INTEGER_64 = 20
  --x2 : INTEGER_64 = 30
  --y1 : INTEGER_64 = -5
  --y2 : INTEGER_64 = -10

  sum_of_integers (a : INTEGER_64; l : INTEGER_64): INTEGER_64
    -- S = n(a + l)/2
    -- where,
    -- S = sum of the consecutive integers
    -- n = number of integers
    -- a = first term
    -- l = last term
    local
      n : INTEGER_64
    do
      n := (l - a) + 1
      Result := n * (a + l) // 2
    end

  make
    local
      highest_y          : INTEGER_64
      sum_of_vectors     : INTEGER_64
      sum_of_x, sum_of_y : INTEGER_64
      x, y, n            : INTEGER_64
      current_x, current_y             : INTEGER_64
    do
      -- PART ONE
      -- n * (n+1) / 2
      highest_y := sum_of_integers(1, y2.abs - 1)
      io.put_string ("Part one: " + highest_y.out)
      io.put_new_line
      -- END OF PART ONE

      -- PART TWO
      sum_of_vectors := (x2 - x1 + 1) * ((y2 - y1).abs + 1)
      from
        x := 1
      until
        x > 120--x2
      loop
        from
          y := 200
        until
          y < y2
        loop
          current_x := x
          current_y := y
          from
            n := 1
          until
            n > 280
          loop
            if x - n >= 0 then
              current_x := current_x + (x - n)
            end
            current_y := current_y + (y - n)
            if current_x >= x1 and current_x <= x2 and current_y <= y1 and current_y >= y2 then
              sum_of_vectors := sum_of_vectors + 1
              io.put_string(x.out + "," + y.out)
              io.put_new_line
              n := 280
            end
            n := n + 1
          end
          
          y := y - 1
        end
        x := x + 1
      end

      io.put_string ("Part two: " + sum_of_vectors.out)
      io.put_new_line
      -- END OF PART TWO

    end

end
