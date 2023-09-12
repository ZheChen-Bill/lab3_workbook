module fir 
#(  parameter pADDR_WIDTH = 12,
    parameter pDATA_WIDTH = 32,
    parameter Tape_Num    = 11,
    parameter Data_Num    = 600
)
(
    wire                     awready,
    wire                     wready,
    wire                     awvalid,
    wire [(pADDR_WIDTH-1):0] awaddr,
    wire                     wvalid,
    wire [(pDATA_WIDTH-1):0] wdata,
    wire                     ss_tvalid, 
    wire [(pDATA_WIDTH-1):0] ss_tdata, 
    wire                     ss_tlast, 
    wire                     ss_tready, 
    wire                     sm_tready, 
    wire                     sm_tvalid, 
    wire [(pDATA_WIDTH-1):0] sm_tdata, 
    wire                     sm_tlast, 
    wire                     axis_clk,
    wire                     axis_rst_n,
    wire                     ap_start,
    wire                     ap_done
);