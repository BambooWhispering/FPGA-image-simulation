% 模仿摄像头视频帧的RGB三通道的文本文件 转化为 R通道、G通道、B通道、RGB图像的图像文件

close;
clear;
clc;


% RGB图像基本参数（请手动修改成你输入的文本文件对应的RGB图像的参数！！！）
num_row = 480; % 行数（图像高）
num_col = 640; % 列数（图像宽）

% 打开文本文件
fid_rgb = fopen('./img_dst_rgb/img_rgb.txt', 'r'); % 以读的方式打开文件

% 读取文本文件
[RGB_pre, count] = fscanf(fid_rgb, '%d', Inf); % 读取文件句柄fid_rgb所对应的文件 的数据，以十进制的方式，读取全部数据，到count×1的矩阵RGB_pre 中去

% R通道、G通道、B通道的图像矩阵 的转置
R1 = zeros(num_col, num_row, 'uint8');
G1 = zeros(num_col, num_row, 'uint8');
B1 = zeros(num_col, num_row, 'uint8');
% 生成 R通道、G通道、B通道的图像矩阵 的转置
for i=1:1:num_row*num_col
    R1(i) = mod(RGB_pre(i)./(2^16), (2^8));
    G1(i) = mod(RGB_pre(i)./(2^8), (2^8));
    B1(i) = mod(RGB_pre(i)./(2^0), (2^8));
end
% 生成 R通道、G通道、B通道的图像矩阵
R = R1';
G = G1';
B = B1';

% 生成 matlab格式的RGB图像矩阵
RGB = zeros(num_row, num_col, 3, 'uint8');
RGB(:, :, 1) = R;
RGB(:, :, 2) = G;
RGB(:, :, 3) = B;

% 生成RGB图像的图像文件
% 将图像写入到磁盘（image write）
imwrite(R, './img_dst_rgb/img_r.jpeg'); % 图像句柄，要写入的磁盘路径
imwrite(G, './img_dst_rgb/img_g.jpeg');
imwrite(B, './img_dst_rgb/img_b.jpeg');
imwrite(RGB, './img_dst_rgb/img_rgb.jpeg');

% 关闭文本文件
fclose(fid_rgb);




% % 模仿摄像头视频帧的RGB三通道的文本文件 转化为 R通道、G通道、B通道、RGB图像的图像文件
% 
% close;
% clear;
% clc;
% 
% 
% % RGB图像基本参数（请手动修改成你输入的文本文件对应的RGB图像的参数！！！）
% num_row = 480; % 行数（图像高）
% num_col = 640; % 列数（图像宽）
% 
% % 打开文本文件
% fid_rgb = fopen('./img_dst_rgb/img_rgb.txt', 'r'); % 以读的方式打开文件
% 
% % 读取文本文件
% [RGB_pre, count] = fscanf(fid_rgb, '%d', Inf); % 读取文件句柄fid_rgb所对应的文件 的数据，以十进制的方式，读取全部数据，到count×1的矩阵RGB_pre 中去
% 
% % R通道、G通道、B通道的图像矩阵 的转置
% R1 = zeros(num_col, num_row, 'uint8');
% G1 = zeros(num_col, num_row, 'uint8');
% B1 = zeros(num_col, num_row, 'uint8');
% % 生成 R通道、G通道、B通道的图像矩阵 的转置
% for i=1:1:num_row*num_col*3
%     if mod(i, 3)==1 % R通道的数据
%         R1(floor((i-1)/3) + 1) = RGB_pre(i); % floor向下取整，相当于截断；+1是因为matlab矩阵索引是从1开始的而不是0
%     elseif mod(i, 3)==2 % G通道的数据
%         G1(floor((i-1)/3) + 1) = RGB_pre(i);
%     else % B通道的数据
%         B1(floor((i-1)/3) + 1) = RGB_pre(i);
%     end
% end
% % 生成 R通道、G通道、B通道的图像矩阵
% R = R1';
% G = G1';
% B = B1';
% 
% % matlab格式的RGB图像矩阵 的转置
% RGB1 = zeros(num_col, num_row, 'uint32');
% % 生成 RGB图像矩阵的转置
% RGB1 = uint32(R1).*(2^16) + uint32(G1).*(2^8) + uint32(B1);
% % 生成 RGB图像矩阵
% RGB = RGB1';
% 
% % 生成 matlab格式的RGB图像矩阵
% RGB = zeros(num_row, num_col, 3, 'uint8');
% RGB(:, :, 1) = R;
% RGB(:, :, 2) = G;
% RGB(:, :, 3) = B;
% 
% % 生成RGB图像的图像文件
% % 将图像写入到磁盘（image write）
% imwrite(R, './img_dst_rgb/img_r.jpeg'); % 图像句柄，要写入的磁盘路径
% imwrite(G, './img_dst_rgb/img_g.jpeg');
% imwrite(B, './img_dst_rgb/img_b.jpeg');
% imwrite(RGB, './img_dst_rgb/img_rgb.jpeg');
% 
% % 关闭文本文件
% fclose(fid_rgb);

