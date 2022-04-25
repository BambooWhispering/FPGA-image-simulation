% �Ҷ�ͼ����ı��ļ� ת��Ϊ�Ҷ�ͼ���ͼ���ļ�

close;
clear;
clc;


% RGBͼ��������������ֶ��޸ĳ���������ı��ļ���Ӧ�ĻҶ�ͼ��Ĳ�����������
num_row = 480; % ������ͼ��ߣ�
num_col = 640; % ������ͼ���

% ���ı��ļ�
fid_gray = fopen('./img_dst_gray/img_gray.txt', 'r'); % �Զ��ķ�ʽ���ļ�

% ��ȡ�ı��ļ�
[gray_pre, count] = fscanf(fid_gray, '%d', Inf); % ��ȡ�ļ����fid_gray����Ӧ���ļ� �����ݣ���ʮ���Ƶķ�ʽ����ȡȫ�����ݣ���count��1�ľ���gray_pre ��ȥ

% �Ҷ�ͼ����� ��ת��
gray1 = zeros(num_col, num_row, 'uint8');
% ���� �Ҷ�ͼ����� ��ת��
for i=1:1:num_row*num_col
    gray1(i) = gray_pre(i);
end
% ���� �Ҷ�ͼ�����
gray = gray1';
gray_normalization = mat2gray(gray);

% ��ͼ��д�뵽���̣�image write��
imwrite(gray_normalization, './img_dst_gray/img_gray.jpeg'); % ͼ������Ҫд��Ĵ���·��

% �ر��ı��ļ�
fclose(fid_gray);

gray_test = imread( './img_dst_gray/img_gray.jpeg'); 

