// This module implements the I2C Slave logic and the counter.

`timescale 1ns / 1ps

module i2c_slave (
    input wire clk,
    input wire reset_n,

    inout wire i2c_sda,
    input wire i2c_scl,

    output wire [7:0] led_count // The counter output
);
    // Internal registers
    reg [7:0] counter = 8'h00;
    reg [7:0] received_data;
    
    // Assign the output wire from our internal register
    assign led_count = counter;

    // Use a simplified logic to detect I2C events from the master
    wire start_condition = (i2c_scl == 1'b1) && (i2c_sda == 1'b0);
    wire stop_condition = (i2c_scl == 1'b1) && (i2c_sda == 1'b1);

    always @(negedge i2c_scl or negedge reset_n) begin
        if (!reset_n) begin
            counter <= 8'h00;
        end else if (start_condition) begin
            // On a simplified start condition, we'll wait for the command
            // A professional design would have a state machine here
        end else if (stop_condition) begin
            // On a stop condition, we process the received data
            if (received_data == 8'h01) begin
                counter <= counter + 1;
            end else if (received_data == 8'h02) begin
                counter <= counter - 1;
            end
        end else begin
            // Capture data on the falling edge of SCL
            received_data <= i2c_sda;
        end
    end
    
    // Assign the SDA line as an input since we are a slave receiver
    assign i2c_sda = 1'bz; // High impedance during reception

endmodule
