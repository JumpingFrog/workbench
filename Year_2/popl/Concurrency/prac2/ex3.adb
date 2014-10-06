with Ada.integer_text_IO; use Ada.integer_text_IO;
with Text_IO; use Text_IO;
procedure Ex3 is
	type Buff is array(0..4) of integer;

	protected Buffer is
		entry get(val : out integer);
		entry put(val : integer);
	private
		pos : integer := -1;
		data : Buff;
	end Buffer;

	task type Consumer;
	task type Producer;

	C : array (1..10) of Consumer;
	P : array (1..10) of Producer;
	
	task body Consumer is
		e : integer;
	begin
		for i in 0..3 loop
			Buffer.get(e);
			put(e);
			Put_Line("");
		end loop;
	end Consumer;
	
	task body Producer is
	begin
		for i in 0..3 loop
			Buffer.put(i);
		end loop;
	end Producer;

	protected body Buffer is
		entry get(val : out integer) when pos > -1 is
		begin
			val := data(pos);
			pos := pos - 1;
		end get;

		entry put(val : integer) when pos < 4 is
		begin
			pos := pos + 1;
			data(pos) := val;
		end put;
	end Buffer;

begin
	null;
end Ex3;


