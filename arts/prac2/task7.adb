pragma Task_Dispatching_Policy(FIFO_Within_Priorities);
with Ada.Text_IO;
with Ada.Real_Time; use Ada.Real_Time;
with System; use System;

procedure Main is
	StartTime : Time := Clock + Milliseconds(200);

	task Periodic is
		pragma Priority(System.Priority'First);
	end Periodic;

	task body Periodic is
		NextRelease : Time := StartTime;
		Interval : Time_Span := Milliseconds(100);
	begin
		for I in 1 .. 50 loop
			delay until NextRelease;
			Ada.Text_IO.Put_Line("Periodic...");
			NextRelease := NextRelease + Interval;
		end loop;
	end Periodic;

	task Worker is
		pragma Priority(System.Priority'First);
	end Worker;

	task body Worker is
		I : Integer := 0;
		F : Duration := 0.0;
	begin
		loop
			Ada.Text_IO.Put_Line("Low Executing");
			for J in 1 .. 10000000 loop
				F := F + Duration(J * 10.0);
			end loop;
			I := I + 1;
			exit when I = 50;
		end loop;
		Ada.Text_IO.Put_Line("Low terminating");
	end Worker;
begin
	null;
end Main;