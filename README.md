# Quartus_I2C_Protocol
This project implements an I²C counter on an FPGA. It demonstrates a professional hardware design workflow by integrating a custom Verilog  module 

Project Overview
This project demonstrates a self-contained digital system that uses the I²C protocol to control a simple 8-bit counter. The system is built in Quartus Prime Lite v24.1 and verified through simulation.

Current Flow (Working So Far)
Wrote a custom I²C Slave module (i2c_slave.v) that acts as an 8-bit counter.
Created a testbench (tb_i2c_ip_project.v) to send I²C signals.
Successfully ran simulation in ModelSim, observing SDA/SCL signals and LED counter output in the waveform.
Verified that the counter increments/decrements as expected during simulation.

Planned Full System
I²C Master: Intel’s IP core (handles I²C protocol).
I²C Slave: Custom Verilog module (i2c_slave.v) implementing an 8-bit counter.
JTAG to Avalon Master Bridge: Provides a way for the testbench to send commands to the I²C Master.
Application: The counter increments/decrements when simulated “button presses” are sent. The value appears on virtual LEDs in the waveform.


Design Approach

System Creation: A new .qsys system was created in Platform Designer.

IP Integration:
Added Avalon I²C (Master) IP.
Added JTAG to Avalon Master Bridge.
Tried to add custom I²C Slave (i2c_slave.v).

Custom Module Packaging (Challenge):
I struggled to package i2c_slave.v as an IP in Platform Designer.
The issue was defining correct interfaces (Clock, Reset, I²C, and LED conduit) in the Component Editor.
Because of this, the slave module was not fully integrated into the .qsys system yet.

Simulation:
So far, simulation has only been tested in ModelSim (not yet in Questa Intel FPGA).
The testbench (tb_i2c_ip_project.v) verifies I²C transactions and shows the counter updates on virtual LEDs.




Challenges
Packaging the Slave Module: Quartus does not automatically recognize Verilog as IP. I needed to use the Component Editor, but faced difficulties with port/interface mapping.
Tool Versions: Options in Quartus Prime Lite v24.1 are different from older guides, making it harder to follow tutorials.
Simulation Tool: Only ModelSim has been used so far. Migration to Questa Intel FPGA is pending.
Conceptual Gap: Moving from sequential (software-style) thinking to parallel hardware design in Verilog.


How to Run (Current Flow)
Open Quartus Prime Lite v24.1.
Add i2c_slave.v and tb_i2c_ip_project.v to the project.
Compile the design.
Launch ModelSim and run tb_i2c_ip_project.v.
Observe SDA/SCL signals and the led_count output in the waveform.
⚠️ Note: The integration of the slave module into the full Platform Designer .qsys system is still in progress.


Files Included
code/ → i2c_slave.v, tb_i2c_ip_project.v, partial .qsys system
netlist/ → Netlist Viewer export (PDF/screenshots)
report/ → Project write-up (steps + challenges)

Tools
Quartus Prime Lite v24.1

Platform Designer
ModelSim (simulation done so far) 


## 📫 Connect with Me
[![LinkedIn]www.linkedin.com/in/priyavarsini-jm-74957927a
