% RGB图像文件 转化为 R通道、G通道、B通道、灰度图像的文本文件及图像文件

close;
clear;
clc;

% ---读取源图像文件
% 读取图像文件到图像句柄中
img = imread('./img_src/img.jpeg');

% ---获取源图像文件的信息
% 获取图像行数、列数、通道数
[num_row, num_col, num_channel] = size(img);

% 获取图像RGB各个通道的图像
R = img(:, :, 1); % R通道
G = img(:, :, 2); % G通道
B = img(:, :, 3); % B通道

% 将 行数×列数 存放的图像文件转置为 列数×行数，
% 因为matlab中，矩阵的一维访问是按列一列一列访问的，而不是按行一行一行访问的
R1 = R';
G1 = G';
B1 = B';


% ---生成R、G、B单个通道的文本文件
% R通道
fid_r = fopen('./img_src/img_r.txt', 'wt'); % 以写的方式打开文件，文件不存在则创建
fprintf(fid_r, '%d\n', R1); % 以整数形式，将R通道图像矩阵R1，输出（写入）fid_r句柄所指向的文件（'img_r.txt'）中，每输出一个数据就换一次行
fclose(fid_r); % 关闭文件
% G通道
fid_g = fopen('./img_src/img_g.txt', 'wt'); % 以写的方式打开文件，文件不存在则创建
fprintf(fid_g, '%d\n', G1); % 以整数形式，将G通道图像矩阵G1，输出（写入）fid_g句柄所指向的文件（'img_g.txt'）中，每输出一个数据就换一次行
fclose(fid_g); % 关闭文件
% B通道
fid_b = fopen('./img_src/img_b.txt', 'wt'); % 以写的方式打开文件，文件不存在则创建
fprintf(fid_b, '%d\n', B1); % 以整数形式，将B通道图像矩阵B1，输出（写入）fid_b句柄所指向的文件（'img_b.txt'）中，每输出一个数据就换一次行
fclose(fid_b); % 关闭文件


% ---生成模仿摄像头视频帧的RGB三通道的文本文件（R1，G1，B1， R2，G2，B2， ...）
% 每3个数据为一个完整数据的RGB转置矩阵
RGB1 = zeros(num_col*3, num_row, 'uint8');
for i=1:1:num_row*num_col*3
    if mod(i, 3)==1
        RGB1(i) = R1(floor((i-1)/3) + 1); % floor向下取整，相当于截断；+1是因为matlab矩阵索引是从1开始的而不是0
    elseif mod(i, 3)==2
        RGB1(i) = G1(floor((i-1)/3) + 1);
    else
        RGB1(i) = B1(floor((i-1)/3) + 1);
    end
end
fid_rgb = fopen('./img_src/img.txt', 'wt'); % 以写的方式打开文件，文件不存在则创建
fprintf(fid_rgb, '%d\n', RGB1); % 以整数形式，将RGB三通道图像矩阵RGB1，输出（写入）fid_rgb句柄所指向的文件（'img_rgb.txt'）中，每输出一个数据就换一次行
fclose(fid_rgb); % 关闭文件


% ---生成单通道灰度图像的文本文件
% 单通道灰度图像
gray = rgb2gray(img);
gray1 = gray';
fid_gray = fopen('./img_src/img_gray.txt', 'wt'); % 以写的方式打开文件，文件不存在则创建
fprintf(fid_gray, '%d\n', gray1); % 以整数形式，将灰度图像矩阵gray1，输出（写入）fid_gray句柄所指向的文件（'img_gray.txt'）中，每输出一个数据就换一次行
fclose(fid_gray); % 关闭文件


% ---生成R通道、G通道、B通道、灰度图像的图像文件
% 将图像写入到磁盘（image write）
imwrite(R, './img_src/img_r.jpeg'); % 图像句柄，要写入的磁盘路径
imwrite(G, './img_src/img_g.jpeg');
imwrite(B, './img_src/img_b.jpeg');
imwrite(gray, './img_src/img_gray.jpeg');
