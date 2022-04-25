/*
目的视频保存模块：
将处理后的目的视频 保存为txt文件，以便用matlab生成目的图片
*/
module vedio_store(
	// 系统信号
	rst_n			,	// 复位（reset）
	
	// 控制信号
	src_sel			,	// 数据源选择（source selection）（用于选择要输出的图像文本文件）
	
	// 目的视频信号
	dst_pclk		,	// 目的视频 像素时钟输出（pixel clock）
	dst_hsync		,	// 目的视频 行同步信号（数据有效输出中标志）
	dst_vsync		,	// 目的视频 场同步信号
	dst_data_out		// 目的视频 像素数据输出
	);
	
	
	// ******************************************参数声明****************************************
	// 目的视频参数
	parameter	DST_DW		=	'd24			;	// 目的视频输出像素数据位宽（data width of source）
	
	// 调试辅助信号
	parameter	FILE_ADDR0	=	"D:/FPGA_learning/Projects/08_ImageProcessing/01_simulation_platform_advanced/doc/img_dst/img_dst0.txt";	// src_sel为0时选择的输出文件地址
	parameter	FILE_ADDR1	=	"D:/FPGA_learning/Projects/08_ImageProcessing/01_simulation_platform_advanced/doc/img_dst/img_dst1.txt";	// src_sel为1时选择的输出文件地址
	parameter	FILE_ADDR2	=	"D:/FPGA_learning/Projects/08_ImageProcessing/01_simulation_platform_advanced/doc/img_dst/img_dst2.txt";	// src_sel为2时选择的输出文件地址
	parameter	FILE_ADDR3	=	"D:/FPGA_learning/Projects/08_ImageProcessing/01_simulation_platform_advanced/doc/img_dst/img_dst3.txt";	// src_sel为3时选择的输出文件地址
	// ******************************************************************************************
	
	
	// *******************************************端口声明***************************************
	// 系统信号
	input						rst_n			;	// 复位（reset）
	
	// 控制信号
	input		[ 1:0]			src_sel			;	// 数据源选择（source selection）（用于选择要输入的图像文本文件）
	
	// 目的视频信号
	input						dst_pclk		;	// 目的视频 像素时钟输出（pixel clock）
	input						dst_hsync		;	// 目的视频 行同步信号
	input						dst_vsync		;	// 目的视频 场同步信号
	input		[DST_DW-1:0]	dst_data_out	;	// 目的视频 像素数据输出
	// *******************************************************************************************
	
	
	// ******************************************内部信号声明*************************************
	// 文件参数
	integer						fid				;	// 文件指针
	
	// 目的视频场同步信号
	reg							dst_vsync_r		;	// 目的视频场同步信号 打1拍
	wire						dst_vsync_pos	;	// 目的视频场同步信号 上升沿
	wire						dst_vsync_neg	;	// 目的视频场同步信号 下降沿
	// *******************************************************************************************
	
	
	// 目的视频场同步信号 打1拍（用于检测目的视频场同步信号上升沿、下降沿）
	always @(posedge dst_pclk, negedge rst_n)
	begin
		if(!rst_n)
			dst_vsync_r <= 1'b0;
		else
			dst_vsync_r <= dst_vsync;
	end
	
	// 目的视频场同步信号 上升沿、下降沿
	assign	dst_vsync_pos	=	~dst_vsync_r && dst_vsync;	// 01
	assign	dst_vsync_neg	=	dst_vsync_r && ~dst_vsync;	// 10
	
	// 将目的视频数据写入磁盘.txt文件中
	always @(posedge dst_pclk, negedge rst_n)
	begin
		if(!rst_n)
			fid = 0;
		else if(dst_vsync_pos) // 目的视频场同步信号上升沿（一帧的开始）时，打开文件
		begin
			case(src_sel) // 数据源选择
				2'd0	:	fid = $fopen(FILE_ADDR0, "w"); // 以只写的方式打开文本文件，文件不存在则创建
				2'd1	:	fid = $fopen(FILE_ADDR1, "w");
				2'd2	:	fid = $fopen(FILE_ADDR2, "w");
				2'd3	:	fid = $fopen(FILE_ADDR3, "w");
			endcase
		end
		else if(dst_hsync) // 目的视频场行同步信号有效期间（数据有效输出中标志），将目的视频数据写入磁盘文件中
			$fdisplay(fid, "%d", dst_data_out);
		else if(dst_vsync_neg) // 目的视频场同步信号下降沿（一帧的结束）时，关闭文件
			$fclose(fid);
	end
	
endmodule
