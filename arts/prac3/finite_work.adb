with Ada.Text_IO; use Ada.Text_IO;

procedure Finite_Work(Cycles : Integer) is
   F : Duration := 0.0;
   I : Integer := 0;
   begin
      Put_Line("Working");
      loop
         I := I + 1;
         for J in 1 .. 10000000 loop
            F := F + Duration(J * 10.0);
         end loop;
         Put_Line("Still Working");
         exit when I = Cycles;
       end loop;
end Finite_Work;