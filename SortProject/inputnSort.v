// fourInputBits.v + registerArray.v are integrated together



//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================



module inputnSort(

	//////////// CLOCK //////////
	input 		         		FPGA_CLK1_50,

	//////////// KEY //////////
	input 		    [1:0]		KEY, // the push button key in the FPGA board

	//////////// LED //////////
	output		    [3:0]		LED,// the LED to display the outputs

	//////////// SW //////////
	input 		    [3:0]		SW, // THe switch to give the ALU inputs to the board

	input even_clk
);	//port declarations

	
	//internal variables

	parameter k	=	4; //bit lenght is 4 bits
	parameter N	=	4; //no.of numbers

	//Reg and Wire Declaration
	//------------------------

	wire 	clk;
	wire 	reset;	//for reset 
	reg 	[k-1:0] 	inp_reg;	//the inputs are temporarily stored in this
	reg	[k-1:0] 	reg_out;
	reg inputs_done; //to indicate that all the N inputs are given by the user
	//reg even_clk;

	//assigning internal signal to the QSF mapped signals///////////
	//--------------------------------------

	assign reset 		= 	KEY[0];
	assign clk              =  	FPGA_CLK1_50;
	assign LED[3:0]         =  	reg_out;
	reg [k-1 : 0] myrows [0 : N-1];	
	integer i;
	//internal counter
	reg	[5:0]	counter; // no.of bits depend on N and so change this value accordingly
	reg		mykey;
	reg		key_delay;
	wire		pulses;
	wire		pulse_input;	
	assign pulses		=	mykey ^ key_delay;
	assign pulse_input 	=	pulses & key_delay;
	
	

always @(posedge pulse_input) begin // push the inputs to queue by shifting
		if(counter<N) begin //counter not N-1 because of extra inp_reg
			myrows[0] <= inp_reg;
			//myrows[1] <= myrows[0];
			for (i=1; i<N ; i=i+1) begin
				myrows[i] <= myrows[i-1];
			end
		end // counter if ends here
end //always ended here

always @(posedge clk or negedge reset) begin
	if(!reset) begin
		inp_reg			<= 4'b0;
		counter[5:0]		<= 5'b0;
		reg_out[3:0]		<= 4'b0;		
	end // reset if ends here
	
	else begin
		mykey		<=	KEY[1];
		key_delay	<=	mykey;
		if(pulse_input) begin
					counter  <=	counter + 1'b1;		
					if(counter == N+1) begin // not N, we used an extra register inp_reg and counter=0 is reset
							//counter <= 4'b0;
							inputs_done <= 1'b1;
					end		
					if(counter < N) begin
							inp_reg	<=	SW;
							reg_out <=	SW;
							inputs_done <= 0;
					end 
		end // pulse input if ends here	
			
		if(inputs_done == 1) begin // sorting begins here
			
			if(even_clk==1'b1) begin			
				for(i=0; i<N ; i=i+2) begin
					if( myrows[i] > myrows[i+1]) begin
					myrows [i+1] <= myrows [i];
					myrows [i] <= myrows [i+1];
					end // if ends here
				end // for ends
			end // even if ends here

			if(even_clk == 1'b0) begin
				for(i=1; i<=N-3 ; i=i+2) begin // first and last registers not included in odd
					if( myrows[i] > myrows[i+1]) begin
					myrows [i+1] <= myrows [i];
					myrows [i] <= myrows [i+1];
					end // if ends here
				end // for ends
			end // odd if ends here		
		
		end // inputs_done if ends here


	end // reset else ends here

end //always ended here



endmodule //inputnSort ends here

