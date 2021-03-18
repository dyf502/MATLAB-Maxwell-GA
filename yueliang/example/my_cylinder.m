% �������������һ��Բ����

clear all;

false = 0;
true = 1;

% Բ����ߴ�
r = 0.5; % �뾶
h = 1.0; % �߶�

% HFSSִ��·��
hfssExePath = 'C:\Program Files\AnsysEM\Maxwell16.0\Win64\maxwell.exe';

% ��ʱ�ļ�·��
tmpPrjFile = 'C:\Users\95340\Desktop\MRI\api\my_conicalhorn.mxwl';
%tmpDataFile = 'E:\ansoft\temp\tmpData.dat';
tmpScriptFile = 'C:\Users\95340\Desktop\MRI\api\my_conicalhorn.vbs';

    % ����һ���µ�HFSS��ʱ�ű��ļ�
    fid = fopen(tmpScriptFile, 'wt'); % 'wt'��ʾ���ı�ģʽ���ļ�����д������ԭ������ 

	% ����һ���µĹ��̲�����һ���µ����
	hfssNewProject(fid);
	hfssInsertDesign(fid, 'cylinder_test');

	% ����Բ����
	hfssCylinder(fid, 'Cylinder', 'Z', [0, 0, 0], r, h, 'mm');

	% ���湤�̵���ʱ�ļ���
	hfssSaveProject(fid, tmpPrjFile, true);

	% �ر�HFSS�ű��ļ�
	fclose(fid);