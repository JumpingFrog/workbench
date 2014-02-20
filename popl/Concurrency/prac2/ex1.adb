with Ada.integer_text_IO; use Ada.integer_text_IO;

procedure Ex1 is
	c : integer;

	task type P;
	task body P is
	begin
		for i in 1..20 loop
			c := c + 1;
		end loop;
	end P;
begin
	c := 0;
	declare
		A, B : P;
	begin
		null;
	end;
	put(c);
end Ex1;
