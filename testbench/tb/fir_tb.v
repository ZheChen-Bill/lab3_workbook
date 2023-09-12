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
    wire                        ss_tready;
    reg                         sm_tready;
    wire                        sm_tvalid;
    wire signed [(pDATA_WIDTH-1) : 0] sm_tdata;
    wire                        sm_tlast;
    reg                         axis_clk;
    reg                         axis_rst_n;
    reg                         ap_start;
    wire                        ap_done;
    
    top_module fir_DUT(
        .awready(awready),
        .wready(wready),
        .awvalid(awvalid),
        .awaddr(awaddr),
        .wvalid(wvalid),
        .wdata(wdata),
        .ss_tvalid(ss_tvalid),
        .ss_tdata(ss_tdata),
        .ss_tlast(ss_tlast),
        .ss_tready(ss_tready),
        .sm_tready(sm_tready),
        .sm_tvalid(sm_tvalid),
        .sm_tdata(sm_tdata),
        .sm_tlast(sm_tlast),
        .axis_clk(axis_clk),
        .axis_rst_n(axis_rst_n),
        .ap_start(ap_start),
        .ap_done(ap_done));

    reg signed [(pDATA_WIDTH-1):0] Din_list[0:(Data_Num-1)];
    reg signed [(pDATA_WIDTH-1):0] golden_list[0:(Data_Num-1)];
    
    initial begin
        $dumpfile("fir.vcd");
        $dumpvars();
    end
    
    initial begin
        axis_clk = 1;
        forever begin
            #5 axis_clk = (~axis_clk);
        end
    end

    initial begin
        axis_rst_n = 0; 
        #5 axis_rst_n = 1; 
    end

    integer Din, golden, input_data, golden_data, m;
    initial begin
        Din = $fopen("./samples_triangular_wave.dat","r");
        golden = $fopen("./out_gold.dat","r");
        for(m=0;m<Data_Num;m=m+1) begin
            input_data = $fscanf(Din,"%d", Din_list[m]);
            golden_data = $fscanf(golden,"%d", golden_list[m]);
        end
    end

    integer i;
    initial begin
        $display("------------Start simulation-----------");
        #10 ss_tvalid = 0;
        #10 $display("----Start the coefficient input(AXI-Stream)----");
        for(i=0;i<(Data_Num-1);i=i+1) begin
            #10 ss_tlast = 0; ss(Din_list[i]);
        end
        #10 ss_tlast = 1; ss(Din_list[(Data_Num-1)]);
        $display("------End the coefficient input(AXI-Stream)------");
    end

    integer k;
    reg error;
    initial begin
        error = 0;
        #10 sm_tready = 1;
        for(k=0;k<(Data_Num-1);k=k+1) begin
            #10 sm(golden_list[k],k);
        end
        #10 sm(golden_list[(Data_Num-1)],k);
        if (error == 0) begin
            $display("---------------------------------------------");
            $display("-----------Congratulations! Pass-------------");
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
        #10   awvalid = 1; awaddr = 12'd1; wvalid = 0;
        #10   awvalid = 1; wvalid = 1;     wdata = -32'd10;
        wait(wvalid == 1 & wready == 1);
        #10   awvalid = 1; awaddr = 12'd2; wvalid = 0;
        #10   awvalid = 1; wvalid = 1;     wdata = -32'd9;
        wait(wvalid == 1 & wready == 1);
        #10   awvalid = 1; awaddr = 12'd3; wvalid = 0;
        #10   awvalid = 1; wvalid = 1;     wdata = 32'd23;
        wait(wvalid == 1 & wready == 1);
        #10   awvalid = 1; awaddr = 12'd4; wvalid = 0;
        #10   awvalid = 1; wvalid = 1;     wdata = 32'd56;
        wait(wvalid == 1 & wready == 1);
        #10   awvalid = 1; awaddr = 12'd5; wvalid = 0;
        #10   awvalid = 1; wvalid = 1;     wdata = 32'd63;
        wait(wvalid == 1 & wready == 1);
        #10   awvalid = 1; awaddr = 12'd6; wvalid = 0;
        #10   awvalid = 1; wvalid = 1;     wdata = 32'd56;
        wait(wvalid == 1 & wready == 1);
        #10   awvalid = 1; awaddr = 12'd7; wvalid = 0;
        #10   awvalid = 1; wvalid = 1;     wdata = 32'd23;
        wait(wvalid == 1 & wready == 1);
        #10   awvalid = 1; awaddr = 12'd8; wvalid = 0;
        #10   awvalid = 1; wvalid = 1;     wdata = -32'd9;
        wait(wvalid == 1 & wready == 1);
        #10   awvalid = 1; awaddr = 12'd9; wvalid = 0;
        #10   awvalid = 1; wvalid = 1;     wdata = -32'd10;
        wait(wvalid == 1 & wready == 1);
        #10   awvalid = 1; awaddr = 12'd10;wvalid = 0;
        #10   awvalid = 1; wvalid = 1;     wdata = 32'd0;
        wait (wvalid == 1 & wready == 1);
        #10   awvalid = 0; wvalid = 0;
        $display("----End the coefficient input(AXI-lite)----");
    end

    task ss;
        input  signed [31:0] in1;
        begin
            ss_tvalid = 1;
            ss_tdata = in1;
            wait (ss_tvalid == 1 & ss_tready == 1);
        end
    endtask

    task sm;
        input  signed [31:0] in2;
        input         [31:0] in3;
        begin
            wait (sm_tready == 1 & sm_tvalid == 1);
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

