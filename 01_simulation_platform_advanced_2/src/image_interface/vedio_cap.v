/*
视频捕获（相当于缓存）：
将虚拟产生的图像数据源 捕获并转换为 所需的数据格式

因为一般来说，若采用RGB888的格式，
则摄像头输出的数据是8位的，
所以需要将摄像头输出的连续的3个8位数据即RGB三通道的数据合并，才能得到一个完整的24位像素数据
*/
module vedio_cap(
	// 系统信号
	rst_n			,	// 复位（reset）
	
	// 源视频信号（源视频产生模块 输出给 视频捕获模块）
	src_pclk		,	// 源视频 像素时钟（pixel clock）
	src_hsync		,	// 源视频 行同步信号（数据有效输出中标志）
	src_vsync		,	// 源视频 场同步信号
	src_data_out	,	// 源视频 像素数据输出
	
	// 捕获视频信号
	cap_pclk		,	// 捕获视频 像素时钟（pixel clock）
	cap_hsync		,	// 捕获视频 行同步信号（数据有效输出中标志）
	cap_vsync		,	// 捕获视频 场同步信号
	cap_data_out		// 捕获视频 像素数据输出
	);
	
	// ******************************************参数声明****************************************
	// 图像基本参数
	parameter	IW		=	'd640	;	// 图像宽（image width）
	parameter	IH		=	'd480	;	// 图像高（image height）
	
	// 源视频参数（摄像头输出参数）
	parameter	SRC_DW	=	'd8		;	// 源视频的像素数据位宽（data width of source）
	parameter	SRC_CHN	=	'd3		;	// 源视频通道数（channels of source）
	
	// 捕获视频参数（捕获输出参数）
	parameter	CAP_DW	=	'd24	;	// 目的视频的像素数据位宽（data width of capture）
	// ******************************************************************************************
	
	
	// *******************************************端口声明***************************************
	// 系统信号
	input						rst_n				;	// 复位（reset）
	
	// 源视频信号（源视频产生模块 输出给 视频捕获模块）
	input						src_pclk			;	// 源视频 像素时钟（pixel clock）
	input						src_hsync			;	// 源视频 行同步信号（数据有效输出中标志）
	input						src_vsync			;	// 源视频 场同步信号
	input		[SRC_DW-1:0]	src_data_out		;	// 源视频 像素数据输出
	
	// 捕获视频信号
	input						cap_pclk			;	// 捕获视频 像素时钟（pixel clock）
	output						cap_hsync			;	// 捕获视频 行同步信号（数据有效输出中标志）
	output						cap_vsync			;	// 捕获视频 场同步信号
	output	reg	[CAP_DW-1:0]	cap_data_out		;	// 捕获视频 像素数据输出
	// *******************************************************************************************
	
	
	// ******************************************内部信号声明*************************************
	
	// 通道计数
	reg			[ SRC_CHN:0]	cnt_channel						;	// 通道计数值，用于指示当前源视频像素输出的是哪个通道的像素
	
	// 源视频数据缓存（若源视频数据为3通道，则需要缓存2个历史数据）
	reg			[SRC_DW-1:0]	src_data_out_arr[SRC_CHN-2:0]	;	// 源视频数据缓存
	
	// for循环计数值
	integer						i								;
	
	// 源视频行同步信号、场同步信号打拍（若源视频数据为3通道，则需要缓存3拍）
	reg			[SRC_CHN-1'b1:0]	src_hsync_r_arr				;	// 源视频行同步信号打拍
	reg			[SRC_CHN-1'b1:0]	src_vsync_r_arr				;	// 源视频场同步信号打拍
	
	// 源视频数据整合为完整的数据（若为3通道，则3通道合并）
	reg			[CAP_DW-1:0]	mix_data						;	// 整合后的数据输出（数据输出 与 数据有效标志 同步）
	reg							mix_valid						;	// 整合后的数据正在有效输出中标志
	// *******************************************************************************************
	
	
	// ********************************************通道计数***************************************
	// 用于整合数据
	always @(posedge src_pclk, negedge rst_n)
	begin
		if(!rst_n)
			cnt_channel <= 1'b0;
		else if(src_hsync) // 源视频行同步信号有效（源视频数据正在输出中标志）时，才进行通道计数
			cnt_channel <= (cnt_channel>=SRC_CHN-1'b1) ? 1'b0 : cnt_channel+1'b1;
		else
			cnt_channel <= 1'b0;
	end
	// *******************************************************************************************
	
	
	// ********************************************缓存打拍***************************************
	
	// 源视频数据缓存
	always @(posedge src_pclk, negedge rst_n)
	begin
		if(!rst_n)
			for(i=0; i<SRC_CHN; i=i+1)
				src_data_out_arr[i] <= 1'b0;
		else // 数组更新
		begin
			src_data_out_arr[0] <= src_data_out;
			for(i=1; i<SRC_CHN; i=i+1)
				src_data_out_arr[i] <= src_data_out_arr[i-1];
		end
	end
	
	// 源视频行同步信号、场同步信号打拍
	always @(posedge src_pclk, negedge rst_n)
	begin
		if(!rst_n)
		begin
			src_hsync_r_arr <= 1'b0;
			src_vsync_r_arr <= 1'b0;
		end
		else
		begin
			src_hsync_r_arr <= {src_hsync_r_arr[SRC_CHN-'d2:0], src_hsync};
			src_vsync_r_arr <= {src_vsync_r_arr[SRC_CHN-'d2:0], src_vsync};
		end
	end
	// *******************************************************************************************
	
	
	// *****************************整合数据输出、数据正在有效输出中标志**************************
	
	// 整合数据输出
	always @(posedge src_pclk, negedge rst_n)
	begin
		if(!rst_n)
			mix_data <= 1'b0;
		else if(src_hsync && cnt_channel==SRC_CHN-1'b1) // 源视频行同步信号有效（源视频数据正在输出中标志），且通道计数计满时，整合数据
			case(SRC_CHN)
				1		:	mix_data <= src_data_out;
				2		:	mix_data <= {src_data_out_arr[0], src_data_out};
				3		:	mix_data <= {src_data_out_arr[1], src_data_out_arr[0], src_data_out};
				4		:	mix_data <= {src_data_out_arr[2], src_data_out_arr[1], src_data_out_arr[0], src_data_out};
				default	:	mix_data <= src_data_out;
			endcase
		else
			mix_data <= 1'b0;
	end
	
	// 整合数据正在有效输出中标志
	always @(posedge src_pclk, negedge rst_n)
	begin
		if(!rst_n)
			mix_valid <= 1'b0;
		else if(src_hsync && cnt_channel==SRC_CHN-1'b1) // 源视频行同步信号有效（源视频数据正在输出中标志），且通道计数计满时，整合数据正在有效输出
			mix_valid <= 1'b1;
		else
			mix_valid <= 1'b0;
	end
	// *******************************************************************************************
	
	
	// ************************************捕获视频信号*******************************************
	
	// 捕获视频行同步信号、场同步信号
	assign	cap_hsync		=	src_hsync_r_arr[SRC_CHN-1'b1];	// 捕获视频行同步信号 为 源视频行同步信号打通道数拍
	assign	cap_vsync		=	src_vsync_r_arr[SRC_CHN-1'b1];	// 捕获视频场同步信号 为 源视频场同步信号打通道数拍
	
	// 捕获视频数据输出
	always @(*)
	begin
		if(cap_hsync) // 捕获视频行同步信号有效（捕获视频数据正在输出中标志）
		begin
			if(mix_valid) // 更新捕获视频数据输出
				cap_data_out = mix_data;
			else
				cap_data_out = cap_data_out;
		end
		else // 非有效期，清0
			cap_data_out = 1'b0;
	end
	// *******************************************************************************************
	
endmodule
