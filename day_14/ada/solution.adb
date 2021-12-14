with Ada.Containers.Indefinite_Hashed_Maps;
with Ada.Containers.Vectors;
with Ada.Strings.Hash;
with Ada.Strings; use Ada.Strings;
with Ada.Text_IO; use Ada.Text_IO;

procedure solution is

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
      C := Character_Counter.Find ("" & Initial_Template(I));
      if C = No_Element then
        Character_Counter.Insert ("" & Initial_Template(I), 1);
      else
        Character_Counter.Replace_Element (C, Character_Counter (C) + 1);
      end if;
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
    Copy_Segment_Counter : Map;
    C                    : Cursor;
  begin
    for I in 1 .. Iteration loop
      Copy_Segment_Counter := Segment_Counter.Copy (0);
      for IC in Copy_Segment_Counter.Iterate loop
        Segment := Key (IC); 
        New_Segment := "" & Character'Val (Segment_Mapping (Segment));
        Character_Counter.Replace(New_Segment, Character_Counter (New_Segment) + Copy_Segment_Counter (Segment));
        Segment_Counter.Replace (Segment, Segment_Counter (Segment) - Copy_Segment_Counter (Segment));

        C := Segment_Counter.Find (Segment(1) & New_Segment);
        if C = No_Element then
          Segment_Counter.Insert (Segment(1) & New_Segment, Copy_Segment_Counter (Segment));
        else
          Segment_Counter.Replace (Segment(1) & New_Segment, Segment_Counter (Segment(1) & New_Segment) + Copy_Segment_Counter (Segment));
        end if;

        C := Segment_Counter.Find (New_Segment & Segment(2));
        if C = No_Element then
          Segment_Counter.Insert (New_Segment & Segment(2), Copy_Segment_Counter (Segment));
        else
          Segment_Counter.Replace (New_Segment & Segment(2), Segment_Counter (New_Segment & Segment(2)) + Copy_Segment_Counter (Segment));
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

end solution;
