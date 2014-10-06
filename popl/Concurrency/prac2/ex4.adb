with Ada.integer_text_IO; use Ada.integer_text_IO;
with Text_IO; use Text_IO;
procedure Ex4 is
	task type Readers;
	task type Writers;

	W : array (1..4) of Writers;
	R : array (1..4) of Readers;

	protected Controller is
    	entry startRead;
    	entry startWrite;
    	procedure stopRead;
    	procedure stopWrite;
	private
		writing : boolean := false;
		reading : integer := 0;
	end Controller;

protected body Controller is
	entry startRead when (not writing and startWrite'count = 0) is --start only when not writing or waiting to write.
	begin
		reading := reading + 1;
	end startRead;

	entry startWrite when (not writing and reading = 0) is
	begin
		writing := true;
	end startWrite;

	procedure stopRead is
	begin
		reading := reading - 1;
	end stopRead;

	procedure stopWrite is
	begin
		writing := false;
	end stopWrite;
end Controller;

task body Readers is
begin
	for i in 1..2 loop
		Controller.startRead;
		Put_line("Reading...");
		Controller.stopRead;
	end loop;
end Readers;

task body Writers is
begin
	for i in 1..4 loop
		Controller.startWrite;
		Put_line("Writing...");
		Controller.stopWrite;
	end loop;
end Writers;

begin
	null;
end Ex4;