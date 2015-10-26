
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

`timescale 1ns/100ps
module traffic_signal(

	//////////// CLOCK //////////
	input 		          		FPGA_CLK1_50,
	input 		          		FPGA_CLK2_50,
	input 		          		FPGA_CLK3_50,

	//////////// KEY //////////
	input 		     [1:0]		KEY,

	//////////// LED //////////
	output		     [7:0]		LED
);


//=======================================================
//  REG/WIRE declarations
//=======================================================
reg        [5:0]         counter            ;
reg        [2:0]         state              ;
reg                      seconds_clk        ;
reg        [24:0]        seconds_counter    ;

wire                     time_done_mlk_main ;
wire                     time_done_mlk_left ;
wire                     time_done_lib_main ;
wire                     time_done_wait     ;
wire                     reset_counter      ;

wire                     mlk_road ;
wire                     mlk_left; 
wire                     lib_road;
wire                     ped_mlk; 
wire                     ped_lib1; 
wire                     ped_lib2;

reg                      mlk_road_s         ; 
reg                      mlk_left_s         ; 
reg                      lib_road_s         ; 

reg                      ped_mlk_s          ; 
reg                      ped_lib1_s         ; 
reg                      ped_lib2_s         ; 

assign clk=FPGA_CLK1_50;
assign reset_n = KEY[0];


parameter   MLK_MAIN         =0             ;
parameter   WAIT1            =1             ;
parameter   MLK_LEFT         =2             ;
parameter   WAIT2            =3             ;
parameter   LIB_MAIN         =4             ;
parameter   WAIT3            =5             ;

parameter   MLK_MAIN_TIME    =60            ;
parameter   MLK_LEFT_TIME    =15            ;
parameter   LIB_MAIN_TIME    =30            ;
parameter   ALL_WAIT_TIME    =05            ;

always @(posedge seconds_clk or negedge reset_n) begin
 if (!reset_n) begin
   mlk_road_s      <=    1'b0;
   mlk_left_s      <=    1'b0;
   lib_road_s      <=    1'b0;
   ped_mlk_s       <=    1'b0;
   ped_lib1_s      <=    1'b0;
   ped_lib2_s      <=    1'b0;
   state           <=    3'b0;
 end else begin 
   case(state)
           MLK_MAIN: begin
          	 mlk_road_s <=1'b1;
                 mlk_left_s <=1'b0;
                 lib_road_s <=1'b0;
                 ped_mlk_s  <=1'b0;
                 ped_lib1_s <=1'b1;
                 ped_lib2_s <=1'b1;

          	 if (time_done_mlk_main) begin 
          	     state<=WAIT1;
          	 end else begin 
                 	     state <=MLK_MAIN;
          	 end
           end
           WAIT1:begin

          	 if (time_done_wait) begin
          	     state<=MLK_LEFT;
          	 end else begin 
          	     state <=WAIT1;
          	 end

           end
           MLK_LEFT:begin
          	 mlk_road_s <=1'b0;
                 mlk_left_s <=1'b1;
                 lib_road_s <=1'b0;
                 ped_mlk_s  <=1'b0;
                 ped_lib1_s <=1'b1;
                 ped_lib2_s <=1'b0;

          	 if (time_done_mlk_left) begin
          	     state<=WAIT2;
          	 end else begin 
                       state <=MLK_LEFT;
          	 end
           end
           WAIT2:begin

          	 if (time_done_wait) begin
          	     state<=LIB_MAIN;
          	 end else begin 
          	     state <=WAIT2;
                 end
           end
           LIB_MAIN:begin
          	 mlk_road_s <=1'b0;
                 mlk_left_s <=1'b0;
                 lib_road_s <=1'b1;
                 ped_mlk_s  <=1'b1;
                 ped_lib1_s <=1'b0;
                 ped_lib2_s <=1'b0;

          	 if (time_done_lib_main) begin
          	     state<=WAIT3;
          	 end else begin 
                       state <=LIB_MAIN;
                 end
           end
           WAIT3:begin

          	 if (time_done_wait) begin
          	     state<=MLK_MAIN;
          	 end else begin 
         		state <=WAIT3;
                 end
           end
           default:state <=MLK_MAIN;
   endcase
 end
end

always @(posedge seconds_clk or negedge reset_n) begin
  if (!reset_n) begin
       counter <=6'b0;
  end else begin
       if (reset_counter)
	  counter <=6'b0;
       else begin
          counter <=counter +1'b1;
       end
  end
end

always @(posedge clk or negedge reset_n) begin
  if (!reset_n) begin
      seconds_counter     <='b0;
      seconds_clk         <='b0;
  end else begin
      if (seconds_counter <'d25000000)
         seconds_counter  <= seconds_counter +1'b1;
      else 
         seconds_counter  <='d0;

      if (seconds_counter =='d25000000)
         seconds_clk      <= !seconds_clk;
  end
end

assign reset_counter      = (time_done_mlk_main |time_done_mlk_left |time_done_lib_main |time_done_wait) ; 
assign time_done_mlk_main = (counter==MLK_MAIN_TIME) & (state==MLK_MAIN);
assign time_done_mlk_left = (counter==MLK_LEFT_TIME) & (state==MLK_LEFT);
assign time_done_lib_main = (counter==LIB_MAIN_TIME) & (state==LIB_MAIN);
assign time_done_wait     = (counter==ALL_WAIT_TIME) & ((state==WAIT1) | (state==WAIT2) | (state==WAIT3)) ;
assign wait1              = (state==WAIT1); 
assign wait2              = (state==WAIT2); 
assign wait3              = (state==WAIT3);

assign mlk_road           = wait1 ?seconds_clk:mlk_road_s;
assign mlk_left           = wait2 ?seconds_clk:mlk_left_s;
assign lib_road           = wait3 ?seconds_clk:lib_road_s;
assign ped_mlk            = wait3 ?seconds_clk:ped_mlk_s;
assign ped_lib1           = (wait1 |wait2) ?seconds_clk:ped_lib1_s;
assign ped_lib2           = wait1 ?seconds_clk:ped_lib2_s;

assign LED[5:0]={mlk_road,ped_lib1,ped_lib2,mlk_left,lib_road,ped_mlk};

endmodule