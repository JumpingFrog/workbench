with Text_IO; use Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Calendar; use Ada.Calendar;
with Ada.Numerics.Discrete_Random;
procedure Ex6 is
	Table_Size : constant := 5;
	type index is mod Table_size;

	type Rand_Range is range 0..9;

	package Rand_Int is new Ada.Numerics.Discrete_Random(Rand_Range);

	task type Philosopher is
		entry Named(name : index);
	end Philosopher;

	task body Philosopher is
    	seed : Rand_Int.Generator;
    	Num : Rand_Range;
    	Me : index;
    	M : integer;
    begin
    	Rand_Int.Reset(seed);
    	accept Named(name : index) do
    		Me := name;
    		M := integer(Me);
    	end Named;
    	loop
			-- pick up fork
			Num := Rand_Int.Random(seed);
			delay Duration(Num)
			-- pickup right fork  
			-- eat
			-- put down forks
			-- sleep
		end loop;
	end Philosopher; 

begin
	null;
end Ex6;