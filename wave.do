onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /tb_usb_rx/tb_clk
add wave -noupdate -radix unsigned /tb_usb_rx/tb_n_rst
add wave -noupdate -radix unsigned /tb_usb_rx/tb_dplus_in
add wave -noupdate -radix unsigned /tb_usb_rx/tb_dminus_in
add wave -noupdate -radix unsigned /tb_usb_rx/tb_r_enable
add wave -noupdate -radix unsigned /tb_usb_rx/tb_buffer_occupancy
add wave -noupdate -radix unsigned /tb_usb_rx/tb_rx_packet_data
add wave -noupdate -radix unsigned /tb_usb_rx/tb_rx_packet
add wave -noupdate -radix unsigned /tb_usb_rx/tb_store_rx_packet_data
add wave -noupdate -radix unsigned /tb_usb_rx/tb_flush
add wave -noupdate -radix unsigned /tb_usb_rx/tb_rx_error
add wave -noupdate -radix unsigned /tb_usb_rx/tb_rx_trans_active
add wave -noupdate -radix unsigned /tb_usb_rx/tb_rx_data_ready
add wave -noupdate -radix unsigned /tb_usb_rx/tb_test_byte
add wave -noupdate -radix unsigned /tb_usb_rx/tb_PID
add wave -noupdate -radix unsigned /tb_usb_rx/tb_expected_PID
add wave -noupdate -radix unsigned /tb_usb_rx/tb_count_one
add wave -noupdate -radix unsigned /tb_usb_rx/tb_bit_num
add wave -noupdate -radix unsigned /tb_usb_rx/tb_test_num
add wave -noupdate -radix unsigned /tb_usb_rx/DUT/c1/clk
add wave -noupdate -radix unsigned /tb_usb_rx/DUT/c1/n_rst
add wave -noupdate -radix unsigned /tb_usb_rx/DUT/c1/edge_detect
add wave -noupdate -radix unsigned /tb_usb_rx/DUT/c1/eop
add wave -noupdate -radix unsigned /tb_usb_rx/DUT/c1/shift_enable
add wave -noupdate -radix unsigned /tb_usb_rx/DUT/c1/rcv_data
add wave -noupdate -radix unsigned /tb_usb_rx/DUT/c1/byte_received
add wave -noupdate -radix unsigned /tb_usb_rx/DUT/c1/PID_error
add wave -noupdate -radix unsigned /tb_usb_rx/DUT/c1/PID_byte
add wave -noupdate -radix unsigned /tb_usb_rx/DUT/c1/buffer_occupancy
add wave -noupdate -radix unsigned /tb_usb_rx/DUT/c1/write_en
add wave -noupdate -radix unsigned /tb_usb_rx/DUT/c1/EOP_err
add wave -noupdate -radix unsigned /tb_usb_rx/DUT/c1/PID_clear
add wave -noupdate -radix unsigned /tb_usb_rx/DUT/c1/PID_mode
add wave -noupdate -radix unsigned /tb_usb_rx/DUT/c1/rx_data_ready
add wave -noupdate -radix unsigned /tb_usb_rx/DUT/c1/rx_trans_active
add wave -noupdate -radix unsigned /tb_usb_rx/DUT/c1/state
add wave -noupdate -radix unsigned /tb_usb_rx/DUT/c1/n_state
add wave -noupdate -radix unsigned /tb_usb_rx/DUT/p1/clk
add wave -noupdate -radix unsigned /tb_usb_rx/DUT/p1/n_rst
add wave -noupdate -radix unsigned /tb_usb_rx/DUT/p1/rcv_data
add wave -noupdate -radix unsigned /tb_usb_rx/DUT/p1/PID_clear
add wave -noupdate -radix unsigned /tb_usb_rx/DUT/p1/PID_mode
add wave -noupdate -radix unsigned /tb_usb_rx/DUT/p1/PID_err
add wave -noupdate -radix unsigned /tb_usb_rx/DUT/p1/rx_packet
add wave -noupdate -radix unsigned /tb_usb_rx/DUT/p1/PID_byte
add wave -noupdate -radix unsigned /tb_usb_rx/DUT/p1/hold
add wave -noupdate -radix unsigned /tb_usb_rx/DUT/p1/next_hold
add wave -noupdate -radix unsigned /tb_usb_rx/DUT/t1/clk
add wave -noupdate -radix unsigned /tb_usb_rx/DUT/t1/n_rst
add wave -noupdate -radix unsigned /tb_usb_rx/DUT/t1/enable_timer
add wave -noupdate -radix unsigned /tb_usb_rx/DUT/t1/shift_enable
add wave -noupdate -radix unsigned /tb_usb_rx/DUT/t1/byte_sent
add wave -noupdate -radix unsigned /tb_usb_rx/DUT/t1/count_out_one
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {736438 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {2535750 ps}
