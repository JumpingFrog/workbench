pragma Task_Dispatching_Policy(FIFO_Within_Priorities);
with Ada.Text_IO; use Ada.Text_IO;
with System; use System;
with Ada.Real_Time; use Ada.Real_Time;

procedure Main is
  protected Controlled_IRQ is
    entry Wait;
    procedure IRQ_Go;
  private
   go : Boolean := False;
  end Controlled_IRQ;

  protected body Controlled_IRQ is
    entry Wait when go is
    begin
      go := False;
    end Wait;

    procedure IRQ_Go is
    begin
      go := True;
    end IRQ_Go;
  end Controlled_IRQ;

  task Boss is
    pragma Priority(System.Priority'First + 5);
  end Boss;

  task body Boss is 
  begin
    delay 1.0;
    Controlled_IRQ.IRQ_Go;
  end Boss; 

  task Worker is
    pragma Priority(System.Priority'First + 1);
  end Worker;

  task body Worker is
    procedure Infinite_Work is
      F : Duration := 0.0;
    begin
      Put_Line("Working");
      loop
        for J in 1 .. 10000000 loop
          F := F + Duration(J * 10.0);
        end loop;
        Put_Line("Still Working");
      end loop;
    end Infinite_Work;
  begin
    select
      Controlled_IRQ.Wait;
      Put_Line("Interrupted");
    then abort
      Infinite_Work;
    end select;
  end Worker;

begin
  null;
end Main;
