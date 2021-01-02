module Matchstick (ds, ds2, leds, display, grounds,clk, pb, pb2);
output [3:0] leds;
output wire [6:0] display;
output wire [3:0] grounds;
input [3:0] ds, ds2;
input clk;
input pb;
input pb2;
reg [63:0] buffer;
reg button;


assign leds=ds;
reg [2:0] state;
reg [15:0] initStick;
reg user;
reg wrong;
reg finish;


always @(posedge clk)
begin
	buffer<={buffer[62:0],pb};
	if(buffer==64'hffffffffffffffff)
		button<=1;
	else
		button<=0;	
end

sevensegment ss(.datain(initStick), .grounds(grounds), .display(display), .user(user), .wrong(wrong), .finish(finish), .clk(clk));
always @(posedge clk)
begin
	case(state)
	3'b000:
		begin
			if(button==1)
				begin
				initStick<=16'h64;
				user<=0;
				wrong<=0;
				finish<=0;	
				state<=3'b001;
			end
			else
				state<=3'b000;
		end
	3'b001:   
		begin
		if(pb2==1)
			begin
				if(initStick -(ds+ds2) <= 0)
					begin
						if(button==0)
							begin
								finish<=1;
								state<=3'b100;
							end
					 end						
				else
					begin
						if(button == 0)
							begin
							if((ds+ds2)==0 || (ds+ds2) > 16'h000A || ((initStick-(ds+ds2) >= 16'h8000) && (initStick-(ds+ds2) <= 16'hffff)))
								begin
									wrong<=1;
									initStick<=initStick;
									state<=3'b001;
								end
							else
								begin
									initStick<=(initStick-(ds+ds2));
									user<=user+1;
									wrong<=0;
									state<=3'b010;
								end
							end
					end
			end
			else
				state<=3'b011;
		end
	3'b010:
		begin	
			if(button==1)
				state<=3'b001;
			else
				state<=3'b010;
		end
	3'b011:
		if(button==1)
			begin
				initStick<=16'h64;
				user<=0;
				wrong<=0;
				finish<=0;	
				state<=3'b001;
			end
		else
			state<=3'b011;
	3'b100:
		if(finish==1 && pb2==1)
			state<=3'b100;
		else if(pb2==0)
			state<=3'b011;
		else
			state<=3'b001;
	endcase
end

initial
	begin
		initStick<=16'h64;
		user<=0;
		wrong<=0;
		finish<=0;	
		buffer<=0;
		button<=0;
		state<=3'b000;
	end
endmodule
