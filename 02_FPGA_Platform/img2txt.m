% RGBͼ���ļ� ת��Ϊ Rͨ����Gͨ����Bͨ�����Ҷ�ͼ����ı��ļ���ͼ���ļ�

close;
clear;
clc;

% ---��ȡԴͼ���ļ�
% ��ȡͼ���ļ���ͼ������
img = imread('./img_src/img.jpeg');

% ---��ȡԴͼ���ļ�����Ϣ
% ��ȡͼ��������������ͨ����
[num_row, num_col, num_channel] = size(img);

% ��ȡͼ��RGB����ͨ����ͼ��
R = img(:, :, 1); % Rͨ��
G = img(:, :, 2); % Gͨ��
B = img(:, :, 3); % Bͨ��

% �� ���������� ��ŵ�ͼ���ļ�ת��Ϊ ������������
% ��Ϊmatlab�У������һά�����ǰ���һ��һ�з��ʵģ������ǰ���һ��һ�з��ʵ�
R1 = R';
G1 = G';
B1 = B';


% ---����R��G��B����ͨ�����ı��ļ�
% Rͨ��
fid_r = fopen('./img_src/img_r.txt', 'wt'); % ��д�ķ�ʽ���ļ����ļ��������򴴽�
fprintf(fid_r, '%d\n', R1); % ��������ʽ����Rͨ��ͼ�����R1�������д�룩fid_r�����ָ����ļ���'img_r.txt'���У�ÿ���һ�����ݾͻ�һ����
fclose(fid_r); % �ر��ļ�
% Gͨ��
fid_g = fopen('./img_src/img_g.txt', 'wt'); % ��д�ķ�ʽ���ļ����ļ��������򴴽�
fprintf(fid_g, '%d\n', G1); % ��������ʽ����Gͨ��ͼ�����G1�������д�룩fid_g�����ָ����ļ���'img_g.txt'���У�ÿ���һ�����ݾͻ�һ����
fclose(fid_g); % �ر��ļ�
% Bͨ��
fid_b = fopen('./img_src/img_b.txt', 'wt'); % ��д�ķ�ʽ���ļ����ļ��������򴴽�
fprintf(fid_b, '%d\n', B1); % ��������ʽ����Bͨ��ͼ�����B1�������д�룩fid_b�����ָ����ļ���'img_b.txt'���У�ÿ���һ�����ݾͻ�һ����
fclose(fid_b); % �ر��ļ�


% ---����ģ������ͷ��Ƶ֡��RGB��ͨ�����ı��ļ���R1��G1��B1�� R2��G2��B2�� ...��
% ÿ3������Ϊһ���������ݵ�RGBת�þ���
RGB1 = zeros(num_col*3, num_row, 'uint8');
for i=1:1:num_row*num_col*3
    if mod(i, 3)==1
        RGB1(i) = R1(floor((i-1)/3) + 1); % floor����ȡ�����൱�ڽضϣ�+1����Ϊmatlab���������Ǵ�1��ʼ�Ķ�����0
    elseif mod(i, 3)==2
        RGB1(i) = G1(floor((i-1)/3) + 1);
    else
        RGB1(i) = B1(floor((i-1)/3) + 1);
    end
end
fid_rgb = fopen('./img_src/img.txt', 'wt'); % ��д�ķ�ʽ���ļ����ļ��������򴴽�
fprintf(fid_rgb, '%d\n', RGB1); % ��������ʽ����RGB��ͨ��ͼ�����RGB1�������д�룩fid_rgb�����ָ����ļ���'img_rgb.txt'���У�ÿ���һ�����ݾͻ�һ����
fclose(fid_rgb); % �ر��ļ�


% ---���ɵ�ͨ���Ҷ�ͼ����ı��ļ�
% ��ͨ���Ҷ�ͼ��
gray = rgb2gray(img);
gray1 = gray';
fid_gray = fopen('./img_src/img_gray.txt', 'wt'); % ��д�ķ�ʽ���ļ����ļ��������򴴽�
fprintf(fid_gray, '%d\n', gray1); % ��������ʽ�����Ҷ�ͼ�����gray1�������д�룩fid_gray�����ָ����ļ���'img_gray.txt'���У�ÿ���һ�����ݾͻ�һ����
fclose(fid_gray); % �ر��ļ�


% ---����Rͨ����Gͨ����Bͨ�����Ҷ�ͼ���ͼ���ļ�
% ��ͼ��д�뵽���̣�image write��
imwrite(R, './img_src/img_r.jpeg'); % ͼ������Ҫд��Ĵ���·��
imwrite(G, './img_src/img_g.jpeg');
imwrite(B, './img_src/img_b.jpeg');
imwrite(gray, './img_src/img_gray.jpeg');
