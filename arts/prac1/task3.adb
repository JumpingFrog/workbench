with Ada.Text_IO;
with Ada.Integer_Text_IO;

procedure Main is
	type MyArray is array (1 .. 100) of Integer;
	buffer : Aliased MyArray;


	procedure Start is
		task type Write(X : Integer; B : Access MyArray);
		T1 : Write(1, buffer'Access);
		T2 : Write(7, buffer'Access);

		task body Write is
		begin
			for I in 1 .. 100 loop
				B(I) := X;
				for i in 1 .. 10000 loop
            		null;
         		end loop;
			end loop;
		end Write;

	begin
		null;
	end Start;
begin
	Start;
	for I in 1 .. 100 loop
		Ada.Integer_Text_IO.Put(buffer(I));
		Ada.Text_IO.New_Line;
	end loop;
end Main;