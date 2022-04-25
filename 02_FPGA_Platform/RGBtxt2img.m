% ģ������ͷ��Ƶ֡��RGB��ͨ�����ı��ļ� ת��Ϊ Rͨ����Gͨ����Bͨ����RGBͼ���ͼ���ļ�

close;
clear;
clc;


% RGBͼ��������������ֶ��޸ĳ���������ı��ļ���Ӧ��RGBͼ��Ĳ�����������
num_row = 480; % ������ͼ��ߣ�
num_col = 640; % ������ͼ���

% ���ı��ļ�
fid_rgb = fopen('./img_dst_rgb/img_rgb.txt', 'r'); % �Զ��ķ�ʽ���ļ�

% ��ȡ�ı��ļ�
[RGB_pre, count] = fscanf(fid_rgb, '%d', Inf); % ��ȡ�ļ����fid_rgb����Ӧ���ļ� �����ݣ���ʮ���Ƶķ�ʽ����ȡȫ�����ݣ���count��1�ľ���RGB_pre ��ȥ

% Rͨ����Gͨ����Bͨ����ͼ����� ��ת��
R1 = zeros(num_col, num_row, 'uint8');
G1 = zeros(num_col, num_row, 'uint8');
B1 = zeros(num_col, num_row, 'uint8');
% ���� Rͨ����Gͨ����Bͨ����ͼ����� ��ת��
for i=1:1:num_row*num_col
    R1(i) = mod(RGB_pre(i)./(2^16), (2^8));
    G1(i) = mod(RGB_pre(i)./(2^8), (2^8));
    B1(i) = mod(RGB_pre(i)./(2^0), (2^8));
end
% ���� Rͨ����Gͨ����Bͨ����ͼ�����
R = R1';
G = G1';
B = B1';

% ���� matlab��ʽ��RGBͼ�����
RGB = zeros(num_row, num_col, 3, 'uint8');
RGB(:, :, 1) = R;
RGB(:, :, 2) = G;
RGB(:, :, 3) = B;

% ����RGBͼ���ͼ���ļ�
% ��ͼ��д�뵽���̣�image write��
imwrite(R, './img_dst_rgb/img_r.jpeg'); % ͼ������Ҫд��Ĵ���·��
imwrite(G, './img_dst_rgb/img_g.jpeg');
imwrite(B, './img_dst_rgb/img_b.jpeg');
imwrite(RGB, './img_dst_rgb/img_rgb.jpeg');

% �ر��ı��ļ�
fclose(fid_rgb);




% % ģ������ͷ��Ƶ֡��RGB��ͨ�����ı��ļ� ת��Ϊ Rͨ����Gͨ����Bͨ����RGBͼ���ͼ���ļ�
% 
% close;
% clear;
% clc;
% 
% 
% % RGBͼ��������������ֶ��޸ĳ���������ı��ļ���Ӧ��RGBͼ��Ĳ�����������
% num_row = 480; % ������ͼ��ߣ�
% num_col = 640; % ������ͼ���
% 
% % ���ı��ļ�
% fid_rgb = fopen('./img_dst_rgb/img_rgb.txt', 'r'); % �Զ��ķ�ʽ���ļ�
% 
% % ��ȡ�ı��ļ�
% [RGB_pre, count] = fscanf(fid_rgb, '%d', Inf); % ��ȡ�ļ����fid_rgb����Ӧ���ļ� �����ݣ���ʮ���Ƶķ�ʽ����ȡȫ�����ݣ���count��1�ľ���RGB_pre ��ȥ
% 
% % Rͨ����Gͨ����Bͨ����ͼ����� ��ת��
% R1 = zeros(num_col, num_row, 'uint8');
% G1 = zeros(num_col, num_row, 'uint8');
% B1 = zeros(num_col, num_row, 'uint8');
% % ���� Rͨ����Gͨ����Bͨ����ͼ����� ��ת��
% for i=1:1:num_row*num_col*3
%     if mod(i, 3)==1 % Rͨ��������
%         R1(floor((i-1)/3) + 1) = RGB_pre(i); % floor����ȡ�����൱�ڽضϣ�+1����Ϊmatlab���������Ǵ�1��ʼ�Ķ�����0
%     elseif mod(i, 3)==2 % Gͨ��������
%         G1(floor((i-1)/3) + 1) = RGB_pre(i);
%     else % Bͨ��������
%         B1(floor((i-1)/3) + 1) = RGB_pre(i);
%     end
% end
% % ���� Rͨ����Gͨ����Bͨ����ͼ�����
% R = R1';
% G = G1';
% B = B1';
% 
% % matlab��ʽ��RGBͼ����� ��ת��
% RGB1 = zeros(num_col, num_row, 'uint32');
% % ���� RGBͼ������ת��
% RGB1 = uint32(R1).*(2^16) + uint32(G1).*(2^8) + uint32(B1);
% % ���� RGBͼ�����
% RGB = RGB1';
% 
% % ���� matlab��ʽ��RGBͼ�����
% RGB = zeros(num_row, num_col, 3, 'uint8');
% RGB(:, :, 1) = R;
% RGB(:, :, 2) = G;
% RGB(:, :, 3) = B;
% 
% % ����RGBͼ���ͼ���ļ�
% % ��ͼ��д�뵽���̣�image write��
% imwrite(R, './img_dst_rgb/img_r.jpeg'); % ͼ������Ҫд��Ĵ���·��
% imwrite(G, './img_dst_rgb/img_g.jpeg');
% imwrite(B, './img_dst_rgb/img_b.jpeg');
% imwrite(RGB, './img_dst_rgb/img_rgb.jpeg');
% 
% % �ر��ı��ļ�
% fclose(fid_rgb);

