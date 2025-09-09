// This module acts as the I2C Master, sending commands.
// It uses a simple state machine to send increment and decrement commands.

`timescale 1ns / 1ps

module i2c_master (
    input wire clk,
    input wire reset_n,
    input wire [1:0] push_buttons, // Virtual buttons to control commands

    output wire i2c_scl, // I2C Clock
    inout wire i2c_sda    // I2C Data
);
    // --- State Machine Definitions ---
    localparam IDLE           = 3'b000;
    localparam SEND_CMD       = 3'b001;
    localparam WAIT_ACK       = 3'b010;
    localparam SEND_DATA      = 3'b011;
    localparam WAIT_DATA_ACK  = 3'b100;

    reg [2:0] state;
    reg [7:0] command;
    reg [7:0] bit_count;
    reg scl_out, sda_out_reg;

    // We'll use a slow clock to drive the I2C bus
    reg [9:0] clk_div_count;
    wire slow_clk;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            clk_div_count <= 10'd0;
        end else begin
            clk_div_count <= clk_div_count + 1'b1;
        end
    end
    assign slow_clk = clk_div_count[9];

    // Main I2C state machine
    always @(posedge slow_clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= IDLE;
            scl_out <= 1'b1;
            sda_out_reg <= 1'b1;
        end else begin
            case (state)
                IDLE: begin
                    scl_out <= 1'b1;
                    sda_out_reg <= 1'b1;
                    if (push_buttons[0] == 1'b1) begin
                        state <= SEND_CMD;
                        command <= 8'h01; // Increment command
                    end else if (push_buttons[1] == 1'b1) begin
                        state <= SEND_CMD;
                        command <= 8'h02; // Decrement command
                    end
                end
                
                SEND_CMD: begin
                    scl_out <= 1'b0; // Start condition
                    sda_out_reg <= 1'b0;
                    state <= WAIT_ACK;
                end
                
                WAIT_ACK: begin
                    scl_out <= 1'b1;
                    if (i2c_sda == 1'b0) begin // Acknowledge received
                        state <= SEND_DATA;
                        scl_out <= 1'b0;
                        bit_count <= 8'd0;
                    end else begin
                        state <= IDLE; // No acknowledge, stop
                    end
                end

                SEND_DATA: begin
                    sda_out_reg <= command[7-bit_count];
                    if (bit_count == 8'd7) begin
                        state <= WAIT_DATA_ACK;
                    end else begin
                        bit_count <= bit_count + 1'b1;
                    end
                end

                WAIT_DATA_ACK: begin
                    scl_out <= 1'b1;
                    if (i2c_sda == 1'b0) begin
                        state <= IDLE; // Go back to idle after command is sent
                        scl_out <= 1'b0; // Send stop
                        sda_out_reg <= 1'b1;
                    end else begin
                        state <= IDLE; // No acknowledge, go to idle
                    end
                end
            endcase
        end
    end

    // Assign physical bus lines to internal logic
    assign i2c_scl = scl_out;
    assign i2c_sda = (sda_out_reg == 1'b1) ? 1'bz : 1'b0;

endmodule
