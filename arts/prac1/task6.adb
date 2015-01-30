with Ada.Text_IO;
with Ada.Numerics.Discrete_Random;

procedure Main is
	type Tasks is new Integer range 1 .. 7;
	type TaskBool is array (Tasks) of Boolean;

	subtype Delay_Time is Integer range 1 .. 10;
	package Random_Integer is new Ada.Numerics.Discrete_Random(Delay_Time);

	protected Controller is
		entry Barrier(Client : Tasks);
	private
		entry Wait(Tasks'Range) (Client : Tasks);
		Queued : Integer := 0;
		Release : TaskBool := (others => False);
	end Controller;

	protected body Controller is
		entry Barrier(Client : Tasks) when True is
		begin
			Queued := Queued + 1;
			if Queued = Integer(Tasks'Last) then
				Release(Tasks'Last) := True;
			end if;
			requeue Wait (Client);
		end Barrier;

		entry Wait(for I in Tasks'Range) (Client : Tasks) when Release(I) is
		begin
			--Ada.Text_IO.Put_Line("Client " & Tasks'Image(I) & " entered.");
			delay 1.0;
			if I /= Tasks'First then
				Release(Tasks'Pred(I)) := True;
			end if;
		end Wait;
	end Controller;

	task type Client(Id : Tasks);

	task body Client is
		Gen : Random_Integer.generator;
		Random_Int : Integer;
	begin
		Random_Integer.Reset(Gen, Integer (Id));
		Random_Int := Random_Integer.Random(Gen);
		Ada.Text_IO.Put_Line("Client " & Tasks'Image(Id) & " delayed.");
		delay Random_Int * 1.0;
		Controller.Barrier(Id);
		Ada.Text_IO.Put_Line("Client " & Tasks'Image(Id) & " released.");
	end Client;

	T1 : Client(1);
	T2 : Client(2);
	T3 : Client(3);
	T4 : Client(4);
	T5 : Client(5);
	T6 : Client(6);
	T7 : Client(7);

begin
	null;
end Main;
