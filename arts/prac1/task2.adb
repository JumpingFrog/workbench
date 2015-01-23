with Ada.Text_IO;
with Ada.Integer_Text_IO;

procedure Main is
	task One;
	task Two;
	--Print 1-100
	task body One is

	begin
		for I in 1 .. 100 loop
			Ada.Integer_Text_IO.Put(I);
			Ada.Text_IO.New_Line;
		end loop;
	end One;

	-- a to Z
	task body Two is

	begin
		for I in 97 .. 122 loop
			Ada.Text_IO.Put(Character'Val(I));
			Ada.Text_IO.New_Line;
		end loop;

		for I in 65 .. 90 loop
			Ada.Text_IO.Put(Character'Val(I));
			Ada.Text_IO.New_Line;
		end loop;
	end Two;
begin
	null;
end Main;