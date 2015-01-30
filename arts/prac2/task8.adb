pragma Task_Dispatching_Policy(FIFO_Within_Priorities);
with Ada.Text_IO;
with Ada.Real_Time; use Ada.Real_Time;
with Ada.Real_Time.Timing_Events; use Ada.Real_Time.Timing_Events;

with System; use System;

procedure Main is
	StartTime : Time := Clock + Milliseconds(200);
	PeriodicEvent : aliased Timing_Event;
	Period : Time_Span := Milliseconds(100);

	protected MyEvent is
		entry Wait;
		procedure Handler(Event : in out Timing_Event);
	private
		Avaliable : Boolean := False;
		NextTime : Time := StartTime;
	end MyEvent;

	protected body MyEvent is
		entry Wait when Avaliable is
		begin
			Avaliable := False;
		end Wait;

		procedure Handler(Event : in out Timing_Event) is
		begin
			Avaliable := True;
			NextTime := NextTime + Period;
			Event.Set_Handler(NextTime, Handler'Unrestricted_Access);
		end Handler;
	end MyEvent;

	task Periodic is
		pragma Priority(System.Priority'First + 5);
	end Periodic;

	task body Periodic is
	begin
		PeriodicEvent.Set_Handler(StartTime, MyEvent.Handler'Unrestricted_Access);
		for I in 1 .. 50 loop
			MyEvent.Wait;
			Ada.Text_IO.Put_Line("Periodic...");
		end loop;
	end Periodic;

-- Worker

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