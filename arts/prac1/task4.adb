with Ada.Text_IO;
with Ada.Integer_Text_IO;

procedure Main is
	Buffer : array (1 .. 100) of Integer;

	protected MyObject is
		entry Wait_One(Idx : Integer);
		entry Wait_Seven(Idx : Integer);
		procedure Print;
	private
		Last : Integer := 0;
		Count : Integer := 0;
	end MyObject;

	protected body MyObject is

		entry Wait_One(Idx: Integer) when (Count = 1 and Last = 7) or (Count = 0 and Last = 1) or (Last = 0) is
		begin
			-- Set last if first item.
			if Last = 0 then
				Last := 1;
			end if;

			-- Increment count
			Count := Count + 1;
			--Reset count
			if Count = 2 then
				Count := 0;
				Last := 1;
			end if;

			Buffer(Idx) := 1;
		end Wait_One;

		entry Wait_Seven(Idx : Integer) when (Count = 1 and Last = 1) or (Count = 0 and Last = 7) or (Last = 0) is
		begin
			-- Set last if first item.
			if Last = 0 then
				Last := 7;
			end if;

			-- Increment count
			Count := Count + 1;
			--Reset count
			if Count = 2 then
				Count := 0;
				Last := 7;
			end if;

			Buffer(Idx) := 7;
		end Wait_Seven;

		procedure Print is
		begin
			for i in Buffer'Range loop
				Ada.Text_IO.Put_Line(Integer'Image(Buffer(i)));
			end loop;
		end Print;
	end MyObject;


	procedure Start is
		Task One;
		Task Seven;

		task body One is

		begin
			for i in Buffer'Range loop
				MyObject.Wait_One(i);
			end loop;
		end One;

		task body Seven is

		begin
			for i in Buffer'Range loop
				MyObject.Wait_Seven(i);
			end loop;
		end Seven;
	begin
		null;
	end Start;
begin
	Start;
	MyObject.Print;
end Main;