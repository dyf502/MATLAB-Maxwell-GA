% �������������һ��Բ׶����

clear all;

false = 0;
true = 1;

% HFSSִ��·��
hfssExePath = 'C:\Program Files\AnsysEM\Maxwell16.0\Win64\maxwell.exe';

% ��ʱ�ļ�·��
tmpPrjFile = 'C:\Users\95340\Desktop\MRI\api\my_conicalhorn.mxwl';
%tmpDataFile = 'E:\ansoft\temp\tmpData.dat';
tmpScriptFile = 'C:\Users\95340\Desktop\MRI\api\my_conicalhorn.vbs';

unit = 'mm'; % ��λ����
freq = 3.6e9; % ����Ƶ�� 
lambda = 0.3e9/freq; % ��������

% Բ�������ߴ�
wgr = 62.5; % �����뾶
wgh = 125; % �������� 

% СԲ̨�ߴ�
sbr = wgr; % �װ뾶
str = 100; % ���뾶
sh = 150; % �߶�

% ����Բ����
gwgr = str;
gwgh = 100;

% ��Բ̨�ߴ�
bbr = gwgr; % �װ뾶
btr = 300; % ���뾶
bh = 1000; % �߶�

% СԲƬ�ߴ�
ssr = wgr; % ԲƬ�뾶
ssh = -1; % ԲƬ�߶�

    % ����һ���µ�HFSS��ʱ�ű��ļ�
    fid = fopen(tmpScriptFile, 'wt'); % 'wt'��ʾ���ı�ģʽ���ļ�����д������ԭ������ 

	% ����һ���µĹ��̲�����һ���µ����
	hfssNewProject(fid);
	hfssInsertDesign(fid, 'conicalhorn_3.6GHz');

    % ����Բ������
    hfssCylinder(fid, 'Cylinder1', 'Z', [0, 0, 0], wgr, wgh, unit);
    
	% ����СԲ̨
	hfssCone(fid, 'Cone1', 'Z', [0, 0, wgh], sbr, str, sh, unit);
    
    % �������ɲ���
    hfssCylinder(fid, 'Cylinder2', 'Z', [0, 0, (wgh+sh)], gwgr, gwgh, unit);

	% ������Բ̨
    hfssCone(fid, 'Cone2', 'Z', [0, 0, (wgh+sh+gwgh)], bbr, btr, bh, unit);
    
    % ���Բ����Բ̨
    hfssUnite(fid, {'Cylinder1','Cone1'},{'Cylinder2','Cone2'});
    
    % ���ñ߽�����PE
    hfssAssignPE_face(fid, 'horn_pec', [7,16,25,34]);
    
    % ����β��СԲƬ
    hfssCylinder(fid, 'small_Cylinder', 'Z', [0, 0, 0], ssr, ssh, unit);
    
    % ����ԲƬ�Ĳ���Ϊpec
    hfssAssignMaterial(fid, 'small_Cylinder', 'pec');
    
    % ��������Բ��
    hfssCylinder(fid, 'Cylinder_Radiation', 'Z', [0, 0, ssh], (btr+lambda/4.0*1000), (wgh+sh+gwgh+bh+lambda/4.0*1000), unit);
    
    % ��ӷ���߽�����
    hfssAssignRadiation(fid, 'Radiation', 'Cylinder_Radiation');
    
    % ��Ӽ���waveport
    hfssAssignWavePort_face(fid, 'waveport', 8, 1, true, [0,-wgr,0], [0,wgr,0], unit);
    
    % �����ⰲװ
    hfssInsertSolution(fid, 'horn_solve', freq/1e9);
    
    % ����Զ��������ϵ
    hfssFarFieldSphere(fid, 'FFSphere', -180, 180, 2, 0, 360, 2);
    
    % ������
    %hfssSolveSetup(fid, 'horn_3.6GHz');
    
    % ���湤�̵���ʱ�ļ���
	hfssSaveProject(fid, tmpPrjFile, true);
    
	% �ر�HFSS�ű��ļ�
	fclose(fid);
    
    % ����HFSSִ�нű�����
	disp('Solving using HFSS ...');
	hfssExecuteScript(hfssExePath, tmpScriptFile);