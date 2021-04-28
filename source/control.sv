// $Id: $
// File name:   control.sv
// Created:     4/15/2021
// Author:      Aakash Saravanan
// Lab Section: 337-08
// Version:     1.0  Initial Design Entry
// Description: Control Finite State Machine for USB TX.

typedef enum bit [3:0] {IDLE, SYNCLOAD, SYNC, PIDLOAD, PID, GETDATA, DATALOAD, DATASEND, CR1LOAD, CR1, CR2LOAD, CR2, EOP, EOP1, ERROR} stateType;

module control(
	input wire clk,
	input wire n_rst,
	input wire [3:0] tx_packet,
	input wire [7:0] tx_packet_data,
	input wire [6:0] buffer_occupancy,
	input wire byte_sent,
	input wire packet_done,
	output reg eop_flag,
	output reg load_enable,
	output reg [7:0] parallel_in,
	output reg tx_error,
	output reg get_tx_packet_data,
	output reg tx_transfer_active,
	output reg enable_timer,
	output reg reset_out
);
	stateType state, next_state;
	
	always_ff @(posedge clk, negedge n_rst) begin 
		if(n_rst == 1'b0) begin
			state <= IDLE;
		end else begin
			state <= next_state;
		end
	end
	
	always_comb begin
		next_state = state;
		case(state)
			IDLE: next_state = (tx_packet) ? SYNCLOAD : IDLE;
			SYNCLOAD: next_state = SYNC;
			SYNC: next_state = (byte_sent) ? PIDLOAD : SYNC;
			PIDLOAD: next_state = PID;
			PID: begin
				if(byte_sent) begin
					if(tx_packet == 4'b0011 || tx_packet == 4'b1011) begin
						next_state = GETDATA;
					end else if(tx_packet == 4'b0010 || tx_packet == 4'b1010 || tx_packet == 4'b1110)begin
						next_state = EOP;
					end else begin
						next_state = ERROR;
					end
				end else
					next_state = PID;
				end
			GETDATA: next_state = (!buffer_occupancy) ? ERROR : DATALOAD;
			DATALOAD: next_state = DATASEND;
			DATASEND: begin
						if(byte_sent) begin
							if(!buffer_occupancy) begin
								next_state = CR1LOAD;
							end else begin
								next_state = GETDATA;
							end
						end else begin
							next_state = DATASEND;
						end
					end
			CR1LOAD: next_state = CR1;
			CR1: next_state = (byte_sent) ? CR2LOAD : CR1;
			CR2LOAD: next_state = CR2;
			CR2: next_state = (byte_sent) ? EOP : CR2;
			EOP: next_state = (packet_done) ? EOP1 : EOP;
			EOP1: next_state = IDLE;
			ERROR: next_state = IDLE;
		endcase
	end

	always_comb begin
		enable_timer = 1'b1;
		if(state == IDLE) begin
			enable_timer = 1'b0;
		end else if(state == ERROR) begin 
			enable_timer = 1'b0;
		end
	end

	always_comb begin
		tx_transfer_active = 1'b1;
		if(state == IDLE) begin
			tx_transfer_active = 1'b0;
		end
	end
	
	always_comb begin
		load_enable = 1'b0;
		if(state == SYNCLOAD) begin
			load_enable = 1'b1;
		end else if(state == PIDLOAD) begin
			load_enable = 1'b1;
		end else if(state == DATALOAD) begin
			load_enable = 1'b1;
		end else if(state == CR1LOAD) begin
			load_enable = 1'b1;
		end else if(state == CR2LOAD) begin
			load_enable = 1'b1;
		end
	end

	always_comb begin
		parallel_in = 8'd0;
		if(state == SYNCLOAD) begin
			parallel_in = 8'd1;
		end else if(state == PIDLOAD) begin
			parallel_in = 
{tx_packet[0], tx_packet[1], tx_packet[2], tx_packet[3], ~tx_packet[0], ~tx_packet[1], ~tx_packet[2], ~tx_packet[3]};
		end else if(state == DATALOAD) begin
			parallel_in = tx_packet_data;
		end else if(state == CR1LOAD) begin
			parallel_in = 8'b10000000;
		end else if(state == CR2LOAD) begin
			parallel_in = 8'b00001101;
		end
	end
	
	always_comb begin
		get_tx_packet_data = 1'b0;
		if(state == GETDATA) begin
			get_tx_packet_data = 1'b1;
		end
	end
	
	always_comb begin
		tx_error = 1'b0;
		if(state == ERROR) begin
			tx_error = 1'b1;
		end
	end
	
	always_comb begin
		eop_flag = 1'b0;
		if(state == EOP) begin
			eop_flag = 1'b1; 
		end else if(state == EOP1) begin
			eop_flag = 1'b1;
		end
	end

	always_comb begin
		reset_out = 1'b0;
		if(state == IDLE) begin
			reset_out = 1'b1;
		end
	end
endmodule
