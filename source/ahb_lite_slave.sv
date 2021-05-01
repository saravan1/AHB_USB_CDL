// $Id: $
// File name:   ahb_lite_slave.sv
// Created:     4/15/2021
// Author:      Lohith Chittineni
// Lab Section: 337-03

// Version:     1.0  Initial Design Entry
// Description: ahb lite slave interface

module ahb_lite_slave
(
    input wire clk,
    input wire n_rst,
    input wire hsel,
    input wire[3:0] haddr,
    input wire[1:0] hsize,
    input wire[1:0] htrans,
    input wire hwrite, 
    input wire[31:0] hwdata,
    input wire [3:0] rx_packet,
    input wire rx_data_ready,
    input wire rx_trans_active,
    input wire rx_error,
    input wire [6:0] buffer_occupancy,
    input wire [7:0] rx_data,
    input wire tx_trans_active,
    input wire tx_error,

    output reg[31:0] hrdata,
    output reg hready,
    output reg hresp,
    output reg clear,
    output reg get_rx_data,
    output reg store_tx_data,
    output reg [7:0] tx_data,
    output reg [3:0] tx_packet
);

    // memory
    // [0x1, 0x0
    //  0x3, 0x2
    //  0x5, 0x4
    //  0x7, 0x6
    //  0x9, 0x8
    //  0xB, 0xA
     // 0xD, 0xC]

    reg[6:0][15:0] mem;
    reg[1:0][15:0] data_buffer_reg;
    reg[31:0]      nxt_hrdata;
    reg            nxt_clear;
    reg[3:0]       nxt_tx_packet;

    reg            prev_hwrite;
    reg[1:0]       prev_htrans;
    reg[1:0]       prev_hsize;
    reg[3:0]       prev_haddr;

    // Internal wires for push and pop from FIFO
    reg            start_push;
    reg            start_pop;
    reg[2:0]       size; // keeps track of num bytes left
    reg[2:0]       nxt_size;
    reg[2:0]       pos;  // keeps track of position in mem for data buffer
    reg[2:0]       nxt_pos;

    // FSM for pushing bytes onto Data Buffer and popping from data buffer
    typedef enum bit [5:0] {IDLE, WBYTE, RBYTE} stateType;
    stateType state;
    stateType nxt_state;

    always_ff @ (posedge clk, negedge n_rst)
    begin 
        if(!n_rst) begin
            hrdata <= '0;
            data_buffer_reg[0] <= '0;
            data_buffer_reg[1] <= '0;
            prev_hwrite <= hwrite;
            prev_htrans <= htrans;
            prev_hsize  <= hsize;
            prev_haddr  <= haddr;
        end
        else begin
            hrdata <= nxt_hrdata;
            data_buffer_reg[0] <= mem[0];
            data_buffer_reg[1] <= mem[1];
            prev_hwrite <= hwrite;
            prev_htrans <= htrans;
            prev_hsize  <= hsize;
            prev_haddr  <= haddr;
        end
    end

   always_comb begin : MEM_LOGIC
        
        // data buffer register
        mem[4'h0>>1] = data_buffer_reg[0];
        mem[4'h2>>1] = data_buffer_reg[1];
        
        // push or pop starter off FIFO
        start_push = 1'b0;
        start_pop = 1'b0;
    
        // status register
        mem[4'h4 >> 1] = 16'd0;
        if(rx_data_ready) mem[4'h4 >> 1] = 16'h0001;
        else if(rx_packet == 4'b1001) mem[4'h4 >> 1] = 16'h0002;
        else if(rx_packet == 4'b0001 ) mem[4'h4 >> 1] = 16'h0004;
        else if(rx_packet == 4'b0010) mem[4'h4 >> 1] = 16'h0008;
        else if(rx_packet == 4'b1010) mem[4'h4 >> 1] = 16'h0010;
        else if(rx_trans_active || get_rx_data) mem[4'h4 >> 1] = 16'h0100;
        else if(tx_trans_active || store_tx_data) mem[4'h4 >> 1] = 16'h0200;

        // error register
        mem[4'h6 >> 1] = 16'b0;
        if(rx_error) mem[4'h6 >> 1] = 16'h0001;
        else if(tx_error) mem[4'h6 >> 1] = 16'h0100;

        // buffer occupancy
        mem[4'h8 >> 1][7:0] = {1'b0,buffer_occupancy};
        mem[4'h9 >> 1][15:8] = 8'b0;

        // extra address
        mem[4'hA >> 1] = 16'b0;
        mem[4'hC >> 1][7:0] = 8'b0;

        // Flush Buffer Control
        mem[4'hD >> 1][15:8] = 8'b0;
    
        hresp = 1'b0;
        hready = 1'b1;
        nxt_hrdata = hrdata;

        if(hsel) begin
            if(haddr > 4'hD) begin
                hresp = 1'b1; 
                hready = 1'b0;
            end                       
            else if ((haddr < 4'h9) && (haddr > 4'h3) && hwrite) begin
                hresp = 1'b1;
                hready = 1'b0;
            end
            else begin
                // write selection logic: based on previous clock
                if(prev_htrans==2'd2) begin
                    if (prev_hwrite) begin
                        case(prev_hsize)
                        2'd0: if(prev_haddr[0] == 1'b0) mem[prev_haddr>>1][7:0] = hwdata[7:0];
                              else mem[prev_haddr>>1][15:8] = hwdata[7:0];
                        2'd1: mem[prev_haddr>>1][15:0] = hwdata[15:0];
                        2'd2: begin
                            mem[0][15:0] = hwdata[15:0];
                            mem[1][15:0] = {8'b0,hwdata[23:16]};
                        end
                        2'd3: begin
                            mem[0][15:0] = hwdata[15:0];
                            mem[1][15:0] = hwdata[31:16];
                        end
                        endcase
                        if(prev_haddr < 4'h4) begin
                            start_push = 1'b1;
                        end
                    end
                end
                // read selection logic: based on current clock
                if(htrans==2'd2) begin
                    if(~hwrite) begin
                        if(haddr < 4'h4) begin
                            start_pop = 1'b1;
                        end
                        else begin
                            case(hsize)
                            2'd0: if(haddr[0] == 1'b0) nxt_hrdata = {24'b0,mem[haddr>>1][7:0]};
                                    else nxt_hrdata = {24'b0, mem[haddr>>1][15:8]};
                            2'd1: nxt_hrdata = {16'b0,mem[haddr>>1][15:0]};
                            2'd2: begin
                                    nxt_hrdata[15:0] = mem[haddr>>1][15:0];
                                    nxt_hrdata[31:16] = {8'b0,mem[haddr>>1+1'd1][7:0]};
                            end
                            2'd3: begin 
                                    nxt_hrdata[15:0] = mem[haddr>>1][15:0];
                                    nxt_hrdata[31:16] = mem[haddr>>1 + 1'd1][15:0];
                            end
                            endcase
                        end
                    end
                end
            end 
        end 

        // assign rx_data to memory, then assign mem to nxt_hrdata
        case(state)
        RBYTE: 
        if(pos == 3'd1) begin 
            mem[4'h0][7:0] = rx_data;
            if(size == 3'd1) nxt_hrdata = {24'b0,mem[4'h0][7:0]};
        end
        else if(pos == 3'd2) begin
            mem[4'h0][15:8] = rx_data;
             if(size == 3'd1) nxt_hrdata = {16'b0,mem[4'h0]};   
        end
        else if(pos == 3'd3) begin
            mem[4'h1][7:0] = rx_data;
             if(size == 3'd1)  nxt_hrdata = {8'b0,mem[4'h1][7:0],mem[4'h0]};
        end
        else if(pos == 3'd4) begin
            mem[4'h1][15:8] = rx_data;
             if(size == 3'd1)  nxt_hrdata = {mem[4'h1],mem[4'h0]};
        end
        endcase

        case(state)
        WBYTE: if(nxt_size != 1'b0) hready = 1'b0;
        RBYTE: if(nxt_size != 1'b0) hready = 1'b0;
        endcase
    end

    // Clear logic
    always_ff @ (posedge clk, negedge n_rst)
    begin
        if(!n_rst) clear <= '0;
        else clear <= nxt_clear;
    end

    always_comb begin : CLEAR_lOGIC
        nxt_clear = clear;
        if(mem[4'hd >> 1][15:8] == 8'd1) begin
            nxt_clear = 1'b1;
        end
        else nxt_clear = 1'b0;
    end        

    // tx packet logic
    always_ff @ (posedge clk, negedge n_rst)
    begin
        if(!n_rst) tx_packet <= '0;
        else tx_packet <= nxt_tx_packet;
    end

    always_comb begin : TX_PACK_CTRL_LOGIC
        nxt_tx_packet = tx_packet;
        case(mem[4'hc >> 1][7:0])
        3'd1: nxt_tx_packet = 4'b0011; //need to change codes
        3'd2: nxt_tx_packet = 4'b0010;
        3'd3: nxt_tx_packet = 4'b1010;
        3'd4: nxt_tx_packet = 4'b1110;
        endcase   
    end  

    // NEXT STATE LOGIC
    always_ff @ (posedge clk, negedge n_rst)
    begin : REG_LOGIC
        if(!n_rst) begin
            state <= IDLE;
            size <= '0;
            pos <= '0;
        end
        else begin
            state <= nxt_state;
            size <= nxt_size;
            pos <= nxt_pos;
        end
    end

    // fsm next state logic data buff reg
    always_comb begin : NXT_LOGIC
        nxt_state = state;
        case(state)
        IDLE: if(start_push)  nxt_state = WBYTE;
              else if (start_pop) nxt_state = RBYTE;
              else nxt_state = IDLE;
        WBYTE: if(size == 3'd1) nxt_state = IDLE;
               else if(buffer_occupancy < 7'd64) nxt_state = WBYTE;
               else nxt_state = IDLE; 
        RBYTE: if(size == 3'd1) nxt_state = IDLE;
               else if(buffer_occupancy > 3'd0) nxt_state = RBYTE;
               else nxt_state = IDLE; 
        endcase
    end

    always_comb begin : NXT_SIZE_LOGIC
        nxt_size = size;
        case(state)
        IDLE: if(start_push) nxt_size = prev_hsize + 1'd1;
              else if (start_pop) nxt_size = hsize + 1'd1;
              else nxt_size = '0;
        WBYTE: nxt_size = nxt_size - 1'd1;
        RBYTE: nxt_size = nxt_size - 1'd1;
        endcase
    end

    always_comb begin : NXT_POS_LOGIC
        nxt_pos = pos;
        case(state)
        IDLE: if(start_push) nxt_pos = nxt_pos + 1'd1;
              else if (start_pop) nxt_pos = nxt_pos + 1'd1;
              else nxt_pos = '0;
        WBYTE: if(size == 3'd1) nxt_pos = '0;
                else nxt_pos = nxt_pos + 1'd1;
        RBYTE: if(size == 3'd1) nxt_pos = '0;
                else nxt_pos = nxt_pos + 1'd1;
        endcase
    end

    // STORE TX DATA LOGIC
    always_comb begin : STORE_TX_LOGIC
        store_tx_data = 1'b0;
        case(state)
        WBYTE: store_tx_data = 1'b1;
        endcase
    end

    //TX DATA LOGIC
    always_comb begin : TX_DATA_LOGIC
        tx_data = 8'b0;
        case(state) 
        WBYTE: if(pos == 3'd1) tx_data = mem[0][7:0];
               else if(pos == 3'd2) tx_data = mem[0][15:8];
               else if(pos == 3'd3) tx_data = mem[1][7:0];
               else if(pos == 3'd4) tx_data = mem[1][15:8];
        endcase
    end

    // GET RX DATA LOGIC
    always_comb begin : GET_RX_LOGIC
        get_rx_data = 1'b0;
        case(state)
        RBYTE: get_rx_data = 1'b1;
        endcase
    end

endmodule