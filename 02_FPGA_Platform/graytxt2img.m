% 灰度图像的文本文件 转化为灰度图像的图像文件

close;
clear;
clc;


% RGB图像基本参数（请手动修改成你输入的文本文件对应的灰度图像的参数！！！）
num_row = 480; % 行数（图像高）
num_col = 640; % 列数（图像宽）

% 打开文本文件
fid_gray = fopen('./img_dst_gray/img_gray.txt', 'r'); % 以读的方式打开文件

% 读取文本文件
[gray_pre, count] = fscanf(fid_gray, '%d', Inf); % 读取文件句柄fid_gray所对应的文件 的数据，以十进制的方式，读取全部数据，到count×1的矩阵gray_pre 中去

% 灰度图像矩阵 的转置
gray1 = zeros(num_col, num_row, 'uint8');
% 生成 灰度图像矩阵 的转置
for i=1:1:num_row*num_col
    gray1(i) = gray_pre(i);
end
% 生成 灰度图像矩阵
gray = gray1';
gray_normalization = mat2gray(gray);

% 将图像写入到磁盘（image write）
imwrite(gray_normalization, './img_dst_gray/img_gray.jpeg'); % 图像句柄，要写入的磁盘路径

% 关闭文本文件
fclose(fid_gray);

gray_test = imread( './img_dst_gray/img_gray.jpeg'); 

