module sevensegment(datain, grounds, display, user, wrong, finish, clk);

	input wire [15:0] datain;
	input wire user;
	input wire wrong;
	input wire finish;
	output reg [3:0] grounds;
	output reg [6:0] display;
	input clk;
	integer a;
	
	reg [3:0] data [3:0];
	reg [3:0] data2 [3:0];
	reg [1:0] count;
	reg [25:0] clk1;
	
	always @(posedge clk1[15])
		begin
			grounds <= {grounds[2:0],grounds[3]};
			count <= count + 1;
		end
	
	always @(posedge clk)
		clk1 <= clk1 + 1;
	
	always @(*) 
		case(data2[count])	
			0:display=7'b1111110; //starts with a, ends with g
         1:display=7'b0110000;
         2:display=7'b1101101;
         3:display=7'b1111001;
         4:display=7'b0110011;
         5:display=7'b1011011;
         6:display=7'b1011111;
         7:display=7'b1110000;
         8:display=7'b1111111;
         9:display=7'b1111011;
			10:display=7'b0000001;
        default display=7'b1111111;
		endcase
	
	always @*
		begin
			data[0] = datain[15:12];
			data[1] = datain[11:8];
			data[2] = datain[7:4];
			data[3] = datain[3:0];
			a = (data[0]*16*16*16 + data[1]*16*16 + data[2]*16 + data[3]);
			data2[3] = a%10;
			data2[2] = (a/10)%10;
			data2[1] = (a/100)%10;
			data2[0] = (user+1);		
			if(wrong == 1)
				begin
					data2[3] = 10;
					data2[2] = 10;
					data2[1] = 10;
					data2[0] = (user+1);	
				end
			if(finish == 1)
				begin
				data2[3] = 10;
				data2[2]= (2-user);
				data2[1] = 10;
				data2[0] = 10;	
				end	
		end 
	
	initial begin		
		count = 2'b0;
		grounds =4'b1110;
		clk1 = 0;
	end
endmodule