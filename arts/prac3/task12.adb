with Finite_Work;
with Ada.Real_Time;      use Ada.Real_Time;
with Ada.Text_IO;        use Ada.Text_IO;
with Ada.Execution_Time; use Ada.Execution_Time;
with Ada.Execution_Time.Timers; use Ada.Execution_Time.Timers;

procedure Main is
   type Timer is new Integer;

   protected Overrun is
      entry Stop_Now;
      procedure Handler(TM : in out Timer);
   private
      Stop : Boolean := False;
   end Overrun;

   protected body Overrun is
      entry Stop_Now when Stop is
         begin
            Stop := False;
         end Stop_Now;

         procedure Handler(TM : in out Timer) is
         begin
            Stop := True;
         end Handler;

   end Overrun;

   task Worker;

   task body Worker is
      Id : aliased Task_Id := Current_Task;
      WCET : Time_Span := Microseconds(200);
      Timer : Timer(Id'Unchecked_Access);
   begin
      Set_Handler(Timer, WCET, Overrun.Handler'Unrestricted_Access);
      select
         Overrun.Stop_Now;
      then abort
         Finite_Work (100);
      end select;

   end Worker;
begin
   null;
end Main;