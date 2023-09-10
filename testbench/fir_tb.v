`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/20/2023 10:38:55 AM
// Design Name: 
// Module Name: fir_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fir_tb
#(  parameter pADDR_WIDTH = 12,
    parameter pDATA_WIDTH = 32,
    parameter Tape_Num    = 11,
    parameter Data_Num    = 600
)();
    wire                        awready;
    wire                        wready;
    reg                         awvalid;
    reg   [(pADDR_WIDTH-1): 0]  awaddr;
    reg                         wvalid;
    reg signed [(pDATA_WIDTH-1) : 0] wdata;
    reg                         ss_tvalid;
    reg signed [(pDATA_WIDTH-1) : 0] ss_tdata;
    reg                         ss_tlast;
    reg                         sm_tready;
    wire                        ss_tready;
    wire                        sm_tvalid;
    wire signed [(pDATA_WIDTH-1) : 0] sm_tdata;
    wire                        sm_tlast;
    reg                         axi_clk;
    reg                         axis_clk;
    reg                         axi_reset_n;
    reg                         axis_rst_n;
    reg                         ap_start;
    wire                        ap_done;
    fir fir_DUT(
        .awready(awready),
        .wready(wready),
        .awvalid(awvalid),
        .awaddr(awaddr),
        .wvalid(wvalid),
        .wdata(wdata),
        .ss_tvalid(ss_tvalid),
        .ss_tdata(ss_tdata),
        .ss_tlast(ss_tlast),
        .sm_tready(sm_tready),
        .ss_tready(ss_tready),
        .sm_tvalid(sm_tvalid),
        .sm_tdata(sm_tdata),
        .sm_tlast(sm_tlast),
        .axi_clk(axi_clk),
        .axis_clk(axis_clk),
        .axi_reset_n(axi_reset_n),
        .axis_rst_n(axis_rst_n),
        .ap_start(ap_start),
        .ap_done(ap_done));

    reg signed [31:0] Din_list[0:599];
    reg signed [31:0] golden_list[0:599];
    
    initial begin
        $dumpfile("fir.vcd");
        $dumpvars();
    end
    
    initial begin
        axis_clk = 1; axi_clk = 1;
        forever begin
            #5 axis_clk = (~axis_clk); axi_clk = (~axi_clk);
        end
    end

    integer Din, golden, input_data, golden_data, m;
    initial begin
        Din = $fopen("./samples_triangular_wave.dat","r");
        golden = $fopen("./out_gold.dat","r");
        for(m=0;m<600;m=m+1) begin
            input_data = $fscanf(Din,"%d", Din_list[m]);
            golden_data = $fscanf(golden,"%d", golden_list[m]);
        end
    end

    initial begin
        axis_rst_n = 0; axi_reset_n = 0;
        #5 axis_rst_n = 1; axi_reset_n = 1;
    end

    integer i;
    reg error;
    initial begin
        #10 $display("----start simulation----");
        ss_tvalid = 0;
        #1000
        $display("----start input the data(AXI-lite)-----");
        error = 0;
        for(i=0;i<599;i=i+1) begin
            #10 ss_tlast = 0; test(Din_list[i],golden_list[i],i);
        end
        #10 ss_tlast = 1; test(Din_list[599],golden_list[599],599);
        if (error == 0) begin
            $display("---------------------------------");
            $display("----Congratulations! Pass----");
        end
        else begin
        end
        $finish;
    end
    
    initial begin
        #20 $display("----Start the coefficient input(AXI-lite)----");
        ap_start = 1;
        #10   awvalid = 1; awaddr = 12'd0; wvalid = 0; ap_start = 0;
        #10   awvalid = 1; wvalid = 1;     wdata = 32'd0;
        wait(wvalid == 1 & wready == 1);
        #10   awvalid = 0; wvalid = 0;
        #10   awvalid = 1; awaddr = 12'd1; wvalid = 0;
        #10   awvalid = 1; wvalid = 1;     wdata = -32'd10;
        wait(wvalid == 1 & wready == 1);
        #10   awvalid = 0; wvalid = 0;
        #10   awvalid = 1; awaddr = 12'd2; wvalid = 0;
        #10   awvalid = 1; wvalid = 1;     wdata = -32'd9;
        wait(wvalid == 1 & wready == 1);
        #10   awvalid = 0; wvalid = 0;
        #10   awvalid = 1; awaddr = 12'd3; wvalid = 0;
        #10   awvalid = 1; wvalid = 1;     wdata = 32'd23;
        wait(wvalid == 1 & wready == 1);
        #10   awvalid = 0; wvalid = 0;
        #10   awvalid = 1; awaddr = 12'd4; wvalid = 0;
        #10   awvalid = 1; wvalid = 1;     wdata = 32'd56;
        wait(wvalid == 1 & wready == 1);
        #10   awvalid = 0; wvalid = 0;
        #10   awvalid = 1; awaddr = 12'd5; wvalid = 0;
        #10   awvalid = 1; wvalid = 1;     wdata = 32'd63;
        wait(wvalid == 1 & wready == 1);
        #10   awvalid = 0; wvalid = 0;
        #10   awvalid = 1; awaddr = 12'd6; wvalid = 0;
        #10   awvalid = 1; wvalid = 1;     wdata = 32'd56;
        wait(wvalid == 1 & wready == 1);
        #10   awvalid = 0; wvalid = 0;
        #10   awvalid = 1; awaddr = 12'd7; wvalid = 0;
        #10   awvalid = 1; wvalid = 1;     wdata = 32'd23;
        wait(wvalid == 1 & wready == 1);
        #10   awvalid = 0; wvalid = 0;
        #10   awvalid = 1; awaddr = 12'd8; wvalid = 0;
        #10   awvalid = 1; wvalid = 1;     wdata = -32'd9;
        wait(wvalid == 1 & wready == 1);
        #10   awvalid = 0; wvalid = 0;
        #10   awvalid = 1; awaddr = 12'd9; wvalid = 0;
        #10   awvalid = 1; wvalid = 1;     wdata = -32'd10;
        wait(wvalid == 1 & wready == 1);
        #10   awvalid = 0; wvalid = 0;
        #10   awvalid = 1; awaddr = 12'd10;wvalid = 0;
        #10   awvalid = 1; wvalid = 1;     wdata = 32'd0;
        wait(wvalid == 1 & wready == 1);
        #10   awvalid = 0; wvalid = 0;
        $display("----End the coefficient input(AXI-lite)----");
    end

    task test;
        input  signed [31:0] in1;
        input  signed [31:0] in2;
        input         [31:0] in3;
        begin
            ss_tvalid = 1;
            ss_tdata = in1;
            sm_tready = 1;
            wait (sm_tready == 1 & sm_tvalid == 1);
            #10 sm_tready = 0; 
            if (sm_tdata != in2) begin
                $display("[ERROR] [Pattern %d] Golden answer: %d, Your answer: %d", in3, in2, sm_tdata);
                error = 1;
            end
            else begin
                // $display("[PASS] [Pattern %d] Golden answer: %d, Your answer: %d", in3, in2, sm_tdata);
            end
        end
    endtask
endmodule

