with Ada.Text_IO;

procedure Main is
	Releaser : constant Integer := 2;

	protected Controller is
		entry Barrier(C : Integer);
	private
		entry Wait(C : Integer);
		Queued : Integer := 0;
		Releasing : Boolean := False;
	end Controller;

	protected body Controller is
		entry Barrier(C : Integer) when True is
		begin
			if C = Releaser and Wait'Count /= 0 then
				Releasing := True;
			elsif C = Releaser then
				null;
			else
				requeue Wait with abort;
			end if;
		end Barrier;

		entry Wait(C : Integer) when Releasing is
		begin
			if Wait'Count = 0 then
				Releasing := False;
			end if;
		end Wait;
	end Controller;

	task type Client(Id : Integer);

	task body Client is
	begin
		Ada.Text_IO.Put_Line("Client " & Integer'Image(Id) & " at barrier.");
		select
			Controller.Barrier(Id);
			Ada.Text_IO.Put_Line("Client " & Integer'Image(Id) & " released.");
		or delay 3.0;
			Ada.Text_IO.Put_Line("Client " & Integer'Image(Id) & " missed.");
		end select;
	end Client;

	T1 : Client(1);
	T2 : Client(2);
	T3 : Client(3);
	T4 : Client(4);
	T5 : Client(5);
	T6 : Client(6);

begin
	null;
end Main;