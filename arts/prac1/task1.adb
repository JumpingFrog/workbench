with Ada.Text_IO;

procedure Main is
	task T;
	task body T is

	begin
		Ada.Text_IO.Put_Line("Hello World");
	end T;
begin
	null;
end Main;