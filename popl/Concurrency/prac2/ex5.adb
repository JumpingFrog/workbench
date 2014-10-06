with Text_IO; use Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Calendar; use Ada.Calendar;
with Ada.Numerics.Discrete_Random;
procedure Ex5 is
   type Rand_Range is range 0..9;
   package Rand_Int is new Ada.Numerics.Discrete_Random(Rand_Range);

  Table_Size : constant := 5;
  type index is mod Table_size;

  task type Philosopher is
    entry Named(name : index);
  end Philosopher;

  task Table is
    entry Get_Fork(index);
    entry Return_Fork(I : index);
  end Table;

  task Deadlock_Prevention is
    entry Enters;
    entry Leaves;
  end Deadlock_Prevention;

  task body Deadlock_Prevention is
    Max : constant Integer := Table_Size  -1;
    Number_Eating : Integer := 0;
  begin
    loop
      select 
         when Number_Eating < Max =>
           accept Enters;
           Number_Eating := Number_Eating + 1;
      or
         accept Leaves;
         Number_Eating := Number_Eating - 1;
      or terminate;
      end select;
    end loop;
 
  end Deadlock_Prevention;

  Phil : array(index) of Philosopher;

  task body Philosopher is
    Me : index;
    M : integer;
    seed : Rand_Int.Generator;
    Num : Rand_Range;
  begin
    Rand_Int.Reset(seed);
    accept Named (name : index) do
      Me := name;
      M := integer(Me);
    end Named;
    for I in 1..4 loop
      Deadlock_Prevention.Enters;
      Table.Get_Fork(Me);
      put(M); Put_Line(" Got first fork");
      Num := Rand_Int.Random(seed);
      delay Duration(Num);
      Table.Get_Fork(Me+1);
      put(M); put("  eating"); new_line;
      delay 5.0;
      Table.Return_Fork(Me);
      Table.Return_Fork(Me+1);
      Deadlock_Prevention.Leaves;
      put(M); put("  sleeping"); new_line;
      delay 20.0;
    end loop;
  end Philosopher;

  task body Table is
    On_Table : array(index) of boolean := (index => true);
  begin
    loop
       select
         when On_table(1) =>
         accept Get_Fork(1);
         On_Table(1) := false;
       or
         when On_table(2) =>
         accept Get_Fork(2);
         On_Table(2) := false;
       or
         when On_table(3) =>
         accept Get_Fork(3);
         On_Table(3) := false;
       or
         when On_table(4) =>
         accept Get_Fork(4);
         On_Table(4) := false;
       or
         when On_table(0) =>
         accept Get_Fork(0);
         On_Table(0) := false;
       or
         accept Return_Fork(I : index) do
           On_Table(I) := true;
         end Return_Fork;
       or
         terminate;
       end select;
    end loop;
  end Table;
begin
  for I in index loop
    Phil(I).Named(I);
  end loop;
end Ex5;