/*
源视频数据的产生（相当于摄像头）：
从matlab生成的图像的.txt文件中读取图像数据，并产生 像素时钟、行同步信号、场同步信号、数据有效输出中标志、像素数据输出。

一般来说，若采用RGB888的格式，
则摄像头输出的数据是8位的，即连续的3个8位数据分别为R通道、G通道、B通道的像素数据
*/
`timescale  1ns/1ps
module vedio_src(
	// 系统信号
	clk				,	// 参考时钟（clock）
	rst_n			,	// 复位（reset）
	
	// 控制信号
	src_sel			,	// 数据源选择（source selection）（用于选择要输入的图像文本文件）
	
	// 源视频信号
	src_pclk		,	// 源视频 像素时钟输出（pixel clock）
	src_hsync		,	// 源视频 行同步信号（数据有效输出中标志）
	src_vsync		,	// 源视频 场同步信号
	src_data_out		// 源视频 像素数据输出
	);
	
	
	// ******************************************参数声明****************************************
	// 图像基本参数
	parameter	IW			=	'd640						;	// 图像宽（image width）
	parameter	IH			=	'd480						;	// 图像高（image height）
	
	// 源视频参数
	// 基本参数
	parameter	SRC_DW		=	'd8							;	// 源视频输出像素数据位宽（data width of source）
	parameter	SRC_CHN		=	'd3							;	// 源视频通道数（channels of source）
	// 行参数（对完整的像素（该像素必须包含所有通道）进行计数）
	parameter	H_TOTAL		=	'd1440						;	// 行总时间
	parameter	H_DISP		=	IW							;	// 行显示时间
	parameter	H_SYNC		=	H_TOTAL-H_DISP				;	// 行同步时间
	// 行参数（对像素时钟进行计数）（一个像素时钟输出一个像素的一个通道，故 每经过SRC_CHN个像素时钟，就输出完一个完整的像素数据）
	parameter	H_TOTAL_PIX	=	H_TOTAL*SRC_CHN				;	// 行总时间
	parameter	H_DISP_PIX	=	H_DISP*SRC_CHN				;	// 行显示时间
	parameter	H_SYNC_PIX	=	H_TOTAL_PIX-H_DISP_PIX		;	// 行同步时间
	// 场参数（对行数进行计数）
	parameter	V_TOTAL		=	'd600						;	// 场总时间
	parameter	V_SYNC		=	'd45						;	// 场同步时间
	parameter	V_BACK		=	'd55						;	// 场后肩
	parameter	V_DISP		=	IH							;	// 场显示时间
	parameter	V_FRONT		=	V_TOTAL-V_SYNC-V_BACK-V_DISP;	// 场前肩
	
	// 调试辅助信号
	parameter	FILE_ADDR0	=	"D:/FPGA_learning/Projects/08_ImageProcessing/01_simulation_platform_advanced/doc/img_src/img_src0.txt";	// src_sel为0时选择的输入文件地址
	parameter	FILE_ADDR1	=	"D:/FPGA_learning/Projects/08_ImageProcessing/01_simulation_platform_advanced/doc/img_src/img_src1.txt";	// src_sel为1时选择的输入文件地址
	parameter	FILE_ADDR2	=	"D:/FPGA_learning/Projects/08_ImageProcessing/01_simulation_platform_advanced/doc/img_src/img_src2.txt";	// src_sel为2时选择的输入文件地址
	parameter	FILE_ADDR3	=	"D:/FPGA_learning/Projects/08_ImageProcessing/01_simulation_platform_advanced/doc/img_src/img_src3.txt";	// src_sel为3时选择的输入文件地址
	
	// ******************************************************************************************
	
	
	// *******************************************端口声明***************************************
	// 系统信号
	input						clk					;	// 参考时钟（clock）
	input						rst_n				;	// 复位（reset）
	
	// 控制信号
	input		[ 1:0]			src_sel				;	// 数据源选择（source selection）（用于选择要输入的图像文本文件）
	
	// 源视频信号
	output						src_pclk			;	// 源视频 像素时钟输出（pixel clock）
	output						src_hsync			;	// 源视频 行同步信号
	output						src_vsync			;	// 源视频 场同步信号
	output	reg	[SRC_DW-1:0]	src_data_out		;	// 源视频 像素数据输出
	// *******************************************************************************************
	
	
	// *****************************************内部信号声明**************************************
	
	// 行、场计数
	reg		[13:0]		cnt_h			;	// 行扫描时的像素时钟计数
	reg		[13:0]		cnt_v			;	// 场扫描时的行数计数
	
	// 场同步信号上升沿检测
	reg					src_vsync_r		;	// 场同步信号打1拍
	wire				src_vsync_pos	;	// 场同步信号上升沿
	
	// 文件参数
	integer				fid				;	// 文件指针
	reg					is_fclose		;	// 文件是否已关闭标志
	wire				data_fvalid		;	// 用于控制从文本文件中读出数据的标志
	reg					callback		;	// 没什么用，只是用于消除警告
	// *******************************************************************************************
	
	
	// ***********************************行、场计数**********************************************
	
	// 行扫描时的像素时钟计数
	always @(posedge clk, negedge rst_n)
	begin
		if(!rst_n)
			cnt_h <= 1'b0;
		else // 每来一个时钟，计数值+1
			cnt_h <= (cnt_h>=H_TOTAL_PIX-1'b1) ? 1'b0 : cnt_h+1'b1;
	end
	
	// 场扫描时的行数计数
	always @(posedge clk, negedge rst_n)
	begin
		if(!rst_n)
			cnt_v <= 1'b0;
		else if(cnt_h == H_TOTAL_PIX-1'b1) // 每行最后一个像素的下一拍，计数值+1
			cnt_v <= (cnt_v>=V_TOTAL-1'b1) ? 1'b0 : cnt_v+1'b1;
	end
	// *******************************************************************************************
	
	
	// *********************************行、场同步信号********************************************
	
	// 行同步信号 的生成
	// 行同步信号：在场有效显示期时，行同步信号 高电平为行有效显示期，低电平为行同步期
	assign	src_hsync	=	(cnt_h>=H_SYNC_PIX && cnt_v>=V_SYNC+V_BACK && cnt_v<V_TOTAL-V_FRONT) ? 1'b1 : 1'b0;
	
	// 场同步信号 的生成
	// 场同步信号：高电平为场后肩+场显示期+场前肩，低电平为场同步期
	assign	src_vsync	=	(cnt_v>=V_SYNC) ? 1'b1 : 1'b0;
	
	// 场同步信号打1拍
	always @(posedge clk)
		src_vsync_r <= src_vsync;
	// 场同步信号上升沿
	assign	src_vsync_pos	=	~src_vsync_r && src_vsync;	// 01
	// *******************************************************************************************
	
	
	// ***********************************像素数据输出********************************************
	
	// 由于从文件中读出数据会使得数据输出滞后1拍，故，文件读出需要比数据有效输出中标志提前1拍
	assign	data_fvalid	=	src_vsync && (cnt_h>=H_SYNC_PIX-1'b1 && cnt_h<H_TOTAL_PIX-1'b1 && cnt_v>=V_SYNC+V_BACK && cnt_v<V_TOTAL-V_FRONT);
	
	// 从图像文本文件中读出像素数据
	// 注意：系统任务不是非阻塞赋值，必须使用阻塞赋值！！！
	always @(posedge clk, negedge rst_n)
	begin
		if(!rst_n)
			is_fclose <= 1'b1; // 文件已关闭
		else if(src_vsync_pos) // 场同步信号上升沿时（场有效标志），打开文件
		begin
			case(src_sel) // 数据源选择
				2'd0	:	fid = $fopen(FILE_ADDR0, "r"); // 以只读的方式打开文本文件
				2'd1	:	fid = $fopen(FILE_ADDR1, "r");
				2'd2	:	fid = $fopen(FILE_ADDR2, "r");
				2'd3	:	fid = $fopen(FILE_ADDR3, "r");
			endcase
			is_fclose <= 1'b0; // 文件未关闭
		end
		else if(data_fvalid) // 数据有效输出中标志提前1拍时，读取文本文件的数据
		begin
			if(!$feof(fid)) // 如果未读到文件尾，则没来一个时钟就读取一行数据（文件中一行只有一个数据）
				callback = $fscanf(fid, "%d", src_data_out);
			else if(!is_fclose) // 读到文件尾，且文件未关闭时（is_fclose用于防止重复关闭已关闭的文件），关闭文件
			begin
				$fclose(fid); // 关闭文件
				is_fclose <= 1'b1; // 文件已关闭
			end
		end
	end
	// *******************************************************************************************
	
	
	// *************************************像素时钟输出******************************************
	assign	src_pclk	=	clk;
	//********************************************************************************************
	
	
endmodule
