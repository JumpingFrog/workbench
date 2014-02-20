with Ada.integer_text_IO; use Ada.integer_text_IO;
procedure Ex2 is
	protected Object is
		entry read(Val : out integer);
		procedure write(Val : integer);
	private
		i : integer;
		allowed : boolean := false;
	end Object;

	task type Consumer;
	task Producer;
	
	A,B,C,D: Consumer;

	task body Consumer is
		v : integer;
	begin
		for i in 0..99 loop
			Object.read(v);
			put(v);
		end loop;
	end Consumer;

	task body Producer is
	begin
		for i in 100..199 loop
			delay 0.5;
			Object.write(i);
		end loop;
	end Producer;
	
	protected body Object is
		entry read(Val : out integer) when allowed is
		begin
			if read'count = 0 then allowed := false; end if;
			Val := i;
		end read;
		
		procedure write(Val : integer) is
		begin
			i := Val;
			allowed := true;
		end write;
	end Object;

begin
	null;
end Ex2;
