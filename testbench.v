// This testbench simulates the top-level module with virtual inputs.

`timescale 1ns / 1ps

module testbench;
    // --- Testbench signals for the top-level module ---
    reg clk;
    reg reset_n;
    reg [1:0] push_buttons;
    wire [7:0] leds;

    // --- Connect the testbench signals to the top-level module ---
    top_level uut (
        .clk(clk),
        .reset_n(reset_n),
        .push_buttons(push_buttons),
        .leds(leds)
    );

    // --- Clock Generator ---
    always #10 clk = ~clk;

    // --- Test Sequence ---
    initial begin
        $display("Starting I2C Simulation...");

        // Initialize signals
        clk = 0;
        reset_n = 0;
        push_buttons = 2'b00;

        // Release from reset after 100ns
        #100;
        reset_n = 1;
        $display("System released from reset. LEDs should be at 0.");

        // Simulate incrementing the counter 5 times
        $display("--- Simulating 5 Increments ---");
        repeat (5) begin
            push_buttons = 2'b01; // Press the increment button
            #500; // Hold the button for 500ns
            push_buttons = 2'b00; // Release the button
            #500;
        end

        // Simulate decrementing the counter 3 times
        $display("--- Simulating 3 Decrements ---");
        repeat (3) begin
            push_buttons = 2'b10; // Press the decrement button
            #500;
            push_buttons = 2'b00;
            #500;
        end

        // Finish the simulation
        $display("--- Simulation complete. Final LED count is %d", leds);
        $stop;
    end
endmodule
