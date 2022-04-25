/*
源视频数据的产生（相当于摄像头） 测试模块
*/
`timescale  1ns/1ps
module vedio_src_tb();
	
	// 系统信号
	reg					clk				;	// 参考时钟（clock）（51.84MHz）
	reg					rst_n			;	// 复位（reset）
	
	// 控制信号
	reg		[ 3:0]		src_sel			;	// 数据源选择（source selection）（用于选择要输入的图像文本文件）
	
	// 源视频信号
	wire				src_pclk		;	// 源视频 像素时钟输出（pixel clock）
	wire				src_hsync		;	// 源视频 行同步信号
	wire				src_vsync		;	// 源视频 场同步信号
	wire	[ 7:0]		src_data_out	;	// 源视频 像素数据输出
	
	// 实例化设计模块
	// ----通道数为1时（灰度图像）：
	// 单场所需像素时钟数 = H_TOTAL*V_TOTAL = 1440*600 = 864,000
	// 扫描频率为60Hz时（即每s扫描60帧图像），1s内所需像素时钟数 = 单场所需像素时钟数*每s扫描的场数 = 864,000*60 = 51,840,000
	// 故，像素时钟频率至少为 51,840,000Hz = 51.84MHz
	// 取 像素时钟频率 = 51.84MHz
	// -----通道数为3时（RGB888）：
	// 单场所需像素时钟数 = H_TOTAL*SRC_CHN*V_TOTAL = 1440*3*600 = 2,592,000
	// 扫描频率为60Hz时（即每s扫描60帧图像），1s内所需像素时钟数 = 单场所需像素时钟数*每s扫描的场数 = 2,592,000*60 = 155,520,000
	// 故，像素时钟频率至少为 155,520,000Hz = 155.52MHz
	// 取 像素时钟频率 = 155.52MHz
	vedio_src #(
		// 图像基本参数
		.IW				(640			),	// 图像宽（image width）
		.IH				(480			),	// 图像高（image height）
		
		// 源视频参数
		// 基本参数
		.SRC_DW			(8				),	// 源视频输出像素数据位宽（data width of source）
		// .SRC_CHN		(1				),	// 源视频通道数（channels of source）
		.SRC_CHN		(3				),	// 源视频通道数（channels of source）
		// 行参数（对完整的像素（该像素必须包含所有通道）进行计数）
		.H_TOTAL		(1440			),	// 行总时间
		// 场参数（对行数进行计数）
		.V_TOTAL		(600			),	// 场总时间
		.V_SYNC			(55				),	// 场同步时间
		.V_BACK			(65				)	// 场后肩
		)
	vedio_src_u0(
		// 系统信号
		.clk			(clk			),	// 参考时钟（clock）
		.rst_n			(rst_n			),	// 复位（reset）
		
		// 控制信号
		.src_sel		(src_sel		),	// 数据源选择（source selection）（用于选择要输入的图像文本文件）
		
		// 源视频信号
		.src_pclk		(src_pclk		),	// 源视频 像素时钟输出（pixel clock）
		.src_hsync		(src_hsync		),	// 源视频 行同步信号
		.src_vsync		(src_vsync		),	// 源视频 场同步信号
		.src_data_out	(src_data_out	)	// 源视频 像素数据输出
		);
	
	// 系统时钟信号 产生
	// localparam T_CLK = 19.29; // 系统时钟（51.84MHz）周期：19.29ns
	localparam T_CLK = 6.43; // 系统时钟（155.52MHz）周期：6.43ns
	initial
		clk = 1'b1;
	always #(T_CLK/2)
		clk = ~clk;
	
	// 复位 任务
	task task_reset;
	begin
		rst_n = 1'b0;
		repeat(10) @(negedge clk)
			rst_n = 1'b1;
	end
	endtask
	
	// 系统初始化 任务
	task task_sysinit;
	begin
		// src_sel = 'd0;
		src_sel = 'd1;
	end
	endtask
	
	// 激励信号 产生
	initial
	begin
		task_sysinit;
		task_reset;
		
		#100_000_000 $stop;
	end
	
endmodule
