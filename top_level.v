// This is the top-level module that connects the master and slave together.
// This is the file you will set as your top-level entity.

`timescale 1ns / 1ps

module top_level (
    // System Inputs
    input wire clk,
    input wire reset_n,
    input wire [1:0] push_buttons, // Virtual buttons

    // System Outputs
    output wire [7:0] leds         // The counter output
);

    // --- Internal Wires for the I2C Bus ---
    wire i2c_scl_wire;
    wire i2c_sda_wire;

    // --- Master and Slave Instantiation ---
    // The master sends the commands
    i2c_master master_inst (
        .clk(clk),
        .reset_n(reset_n),
        .push_buttons(push_buttons),
        .i2c_scl(i2c_scl_wire),
        .i2c_sda(i2c_sda_wire)
    );

    // The slave receives the commands and updates the counter
    i2c_slave slave_inst (
        .clk(clk),
        .reset_n(reset_n),
        .i2c_scl(i2c_scl_wire),
        .i2c_sda(i2c_sda_wire),
        .led_count(leds)
    );

endmodule
