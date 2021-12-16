with Ada.Containers.Indefinite_Hashed_Maps;
with Ada.Containers.Vectors;
with Ada.Strings.Hash;
with Ada.Strings; use Ada.Strings;
with Ada.Text_IO; use Ada.Text_IO;

procedure Solution is

  package Integer_Hashed_Maps is new Ada.Containers.Indefinite_Hashed_Maps
    (Key_Type       => String,
    Element_Type    => Long_Integer,
    Hash            => Ada.Strings.Hash,
    Equivalent_Keys => "=");
  use Integer_Hashed_Maps;
  
  Iteration         : constant Integer := 40;
  File_Name         : constant String := "input.data";
  F                 : File_Type;
  Character_Counter : Map;
  Segment_Counter   : Map;
  Segment_Mapping   : Map;
begin

  Open (F, In_File, File_Name);

  declare
    Initial_Template : String := Get_Line (F);
    Line             : String (1 .. 7);
    C                : Cursor;
  begin
    for C in Character range 'A' .. 'Z' loop
      Character_Counter.Include ("" & C, 0);
    end loop;

    for I in 1 .. Initial_Template'Length loop
      C := Find (Character_Counter, "" & Initial_Template (I));
      Character_Counter.Replace_Element (C, Character_Counter (C) + 1);
    end loop;

    for I in 1 .. Initial_Template'Length - 1 loop
      C := Segment_Counter.Find (Initial_Template(I .. I+1));
      if C = No_Element then
        Segment_Counter.Insert (Initial_Template(I .. I+1), 1);
      else
        Segment_Counter.Replace_Element (C, Segment_Counter (C) + 1);
      end if;
    end loop;

    Skip_Line (F);

    while not End_Of_File (F) loop
      Line := Get_Line (F);
      Segment_Mapping.Insert(Line(1 .. 2), Character'Pos (Line(7)));
    end loop;
  end;

  Close (F);

  declare
    Segment              : String (1 .. 2);
    New_Segment          : String (1 .. 1);
    Left_Segment         : String (1 .. 2);
    Right_Segment        : String (1 .. 2);
    C                    : Cursor;
  begin
    for I in 1 .. Iteration loop
      for IC in Segment_Counter.Copy (0).Iterate loop
        Segment := Key (IC); 
        New_Segment := "" & Character'Val (Segment_Mapping (Segment));
        Left_Segment := Segment(1) & New_Segment;
        Right_Segment := New_Segment & Segment(2);

        Character_Counter.Replace(New_Segment, Character_Counter (New_Segment) + Element (IC));
        Segment_Counter.Replace (Segment, Segment_Counter (Segment) - Element (IC));

        C := Segment_Counter.Find (Left_Segment);
        if C = No_Element then
          Segment_Counter.Insert (Left_Segment, Element (IC));
        else
          Segment_Counter.Replace (Left_Segment, Segment_Counter (Left_Segment) + Element (IC));
        end if;

        C := Segment_Counter.Find (Right_Segment);
        if C = No_Element then
          Segment_Counter.Insert (Right_Segment, Element (IC));
        else
          Segment_Counter.Replace (Right_Segment, Segment_Counter (Right_Segment) + Element (IC));
        end if;
      end loop;
    end loop;
  end;

  declare
    package Integer_Vectors is new Ada.Containers.Vectors
      (Index_Type   => Natural,
      Element_Type => Long_Integer);
    package Integer_Vectors_Sorting is new Integer_Vectors.Generic_Sorting;
    use Integer_Vectors;
    use Integer_Vectors_Sorting;
    Counter          : Vector;
  begin
    for C in Character_Counter.Iterate loop
      if Character_Counter (C) > 0 then
        Counter.Append (Character_Counter (C));
      end if;
    end loop;

    Sort (Counter);
    Put_Line ("Solution: " & Long_Integer'Image (Counter.Last_Element - Counter.First_Element));
  end;

end Solution;
