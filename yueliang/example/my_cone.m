% �������������һ��Բ̨

clear all;

false = 0;
true = 1;

% Բ̨�ߴ�
br = 0.5; % �װ뾶
tr = 1.0; % ���뾶
h = 2.0; % �߶�

% ��ʱ�ļ�·��
tmpPrjFile = 'C:\Users\95340\Desktop\MRI\api\my_cone.mxwl';
% tmpDataFile = 'E:\ansoft\temp\tmpData.m';
tmpScriptFile = 'C:\Users\95340\Desktop\MRI\api\my_cone.vbs';

% HFSSִ��·��
hfssExePath = 'C:\Program Files\AnsysEM\Maxwell16.0\Win64\maxwell.exe';

    % ����һ���µ�HFSS��ʱ�ű��ļ�
    fid = fopen(tmpScriptFile, 'wt'); % 'wt'��ʾ���ı�ģʽ���ļ�����д������ԭ������ 

	% ����һ���µĹ��̲�����һ���µ����
	hfssNewProject(fid);
	hfssInsertDesign(fid, 'cone_test');

	% ����Բ̨
	hfssCone(fid, 'Cone', 'Z', [0, 0, 0], br, tr, h, 'mm');

	% ���湤�̵���ʱ�ļ���
	hfssSaveProject(fid, tmpPrjFile, true);

	% �ر�HFSS�ű��ļ�
	fclose(fid);