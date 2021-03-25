%% ��ʼ
clear all;
false = 0;
true = 1;
%% ������ʼ��Ⱥ
N = 0; %��ʼ����������0��20��
N_total = 20; %���������
Chrom = zeros (N_total, 14);
% ����Ⱥ�е�n��dʵ����(����ǵ�һ�ν�����Ⱥ��n��d��ʵ��ֵ)
Chrom_dig_n = zeros(N_total, 1);
Chrom_dig_d = zeros(N_total, 1);
data_need = zeros(N_total, 3);
while (N < N_total)
    var = crtbp(1, 14);
    var_str = num2str(var); %�Ѷ����Ʊ��ַ���
    var_str = strrep(var_str, ' ', ''); %ȥ���ַ����ڿո�
    % var_str = deblank(var_str);        %ȥ����β�Ķ���ո�
    var_str_n = var_str(1:6);
    var_str_d = var_str(7:14); %ȡ��n��d��ֵ
    % var_dig_n = str2num(var_str_n); var_dig_d = str2num(var_str_n); %���ַ����������
    var_10_n = bin2dec (var_str_n);
    var_10_d = bin2dec (var_str_d);

    if (var_10_n * var_10_d) < 390 && (var_10_n * var_10_d) > 0 && (var_10_n <= 30) &&  (var_10_n >= 3)
        N = N + 1;
        Chrom_dig_n(N, 1) = var_10_n;
        Chrom_dig_d(N, 1) = var_10_d;

        for i = 1:14
            Chrom(N, i) = var(1, i);
        end

    end

end
% ���.mat�ļ�
%save data_fc  Chrom_dig_n Chrom_dig_d data_need
for model_n = 1:N_total
    %% �ļ�·��
    hfssExePath = 'C:\Program Files\AnsysEM\Maxwell16.0\Win64\maxwell.exe';
    % maxwell����·��
    model_n_n = num2str(model_n);
    tmpPrjFile = 'E:\WXY\mx\Tes_3_23_';
    tmpPrjFile = strcat(tmpPrjFile,model_n_n);
    tmpPrjFile = strcat(tmpPrjFile,'.mxwl');
    %tmpDataFile = 'E:\ansoft\temp\tmpData.dat';
    tmpScriptFile = 'E:\WXY\vbs\Tes_3_23_';
    tmpScriptFile = strcat(tmpScriptFile,model_n_n);
    tmpScriptFile = strcat(tmpScriptFile,'.vbs');
    %tmpScriptFile = 'E:\WXY\vbs\Tes_3_23.vbs';
    % ��ʱ�ļ�·��
    fid = fopen(tmpScriptFile, 'wt'); % д��

    %% ����һ���µĹ��̲�����һ���µ����
    if model_n == 1
        hfssNewProject(fid);
        DesignName = 'Tes_3_23_';
        DesignName = strcat(DesignName,model_n_n);
        hfssInsertDesign(fid, DesignName);
        hfssSaveProject(fid, tmpPrjFile, true);
    else
        DesignName = 'Tes_3_23_';
        DesignName = strcat(DesignName,model_n_n);
        MaxNewProject(fid);
        hfssInsertDesign(fid, DesignName);
        hfssSaveProject(fid, tmpPrjFile, true);
    end
    %��Ȧ��
    n = Chrom_dig_n(model_n, 1);
    %n = 10;
    %ys ���
    d = Chrom_dig_d(model_n, 1);
    ys = (390 - (n - 1) * d) / n;
    % ys = 20;
    % d = 10;
    %% ����ģ��&����
    %����������CS1
    CreateCSBox(fid);
    FRP_copper = "copper";
    count = 1;
    zs = 0.2;
    for level = 1:4
        if level == 1
            zp = 0;
        elseif level == 2
            zp = 22;
        elseif level == 3
            zp = 316;
        elseif level == 4
            zp = 338;
        end
        ChangeCS(fid, 0);
        level_s = num2str(level);
        for i = 1:n
            yp = (i - 1) * (d + ys);
            i_n = num2str(i);
            BoxName = strcat('BOX_', level_s);
            BoxName = strcat(BoxName, '_');
            BoxName = strcat(BoxName, i_n);
            %������ģ
            MaxBoxFRP(fid, BoxName, ys, yp, zs, zp, FRP_copper);
        end
        fprintf(fid, '\n');
        level_s = num2str(level);
        section_n = count * 2 - 1;
        MaxSection(fid, level_s, n, section_n); %�������沢��ӵ���
    end
    %% ��ӹ۲�����
    ChangeCS(fid, 0);
    FRP_vacuum = "vacuum";
    BoxName_ob = "BoxObserve";
    zs = 345;
    zp = 0;
    ys = yp + ys;
    yp = 0;
    MaxBoxFRP(fid, BoxName_ob, ys, yp, zs, zp, FRP_vacuum);
    % ���5���۲�����

    %% ���analysis
    count_i = 10; %��������
    p_error = 1;
    Maxanlysis(fid, count_i, p_error);
    hfssSaveProject(fid, tmpPrjFile, true);
    %% ��ʼ����
    MaxRun(fid);

    %% ���ɹ۲��沢ȡ��
    y = ys / 2;
    x = 270;
    R = 100;
    MaxCreateBY(fid);
    open = 0;

    for i = 1:21
        i_n = num2str(i);
        doc_count = 1;
        CS_Name = "CS_Ob_";
        CS_Name = strcat(CS_Name, i_n);
        Circle = "Circle_";
        Circle = strcat(Circle, i_n);
        FileName = "Report_";
        FileName = strcat(FileName, i_n);
        z = 59 + 10 * i;

        if i == 1
            continue
        end

        if i == 21
            z = 169;
            MaxChangeCStoXZ(fid);
            R_tem = 100;
            MaxBuildCir(fid, Circle, z, -y, R_tem);
            R_p = 2 * pi * R_tem;
            MaxReport(fid, FileName, Circle, R_p);
            break
        end

        CreateCS(fid, CS_Name, x, y, z);
        ChangeCS(fid, 0);
        h = 10 * abs(11 - i);
        R_tem = sqrt(R^2 - h^2);
        MaxBuildCir(fid, Circle, y, z, R_tem);
        R_p = 2 * pi * R_tem;
        MaxReport(fid, FileName, Circle, R_p);
    end

    %% �����ļ�
    hfssSaveProject(fid, tmpPrjFile, true);

%     ProjectName = "Tes_3_22_";
%     ProjectName = strcat(ProjectName,model_n_n);
%     
%     MaxDelete(fid, ProjectName);
    fclose(fid);
    fclose('all');


%     %% ��ȡ���ɵ�report 1-21
%     data_max = zeros(20,1);
%     data_min = zeros(20,1);
%     for report_n = 2:21
%         path_data = "E:\WXY\csv\Report_";
%         report_n_n = num2str(report_n);
%         path_data = strcat(path_data,report_n_n);
%         path_data = strcat(path_data,".csv");
%         data = csvread(path_data,1,1,[1,1,179,1]);
%         data_max(report_n-1,1) = max(max(data));
%         data_min(report_n-1,1) = min(min(data));
%     end
%     Data_Max_Full = max(max(data_max));
%     Data_Min_Full = min(min(data_min));
%     data_need(model_n,1) = Data_Max_Full;
%     data_need(model_n,2) = Data_Min_Full;
%     data_need(model_n,3) = (Data_Max_Full-Data_Min_Full)/((Data_Max_Full+Data_Min_Full)/2);
%     % ���.mat�ļ�
%     save data_fc  Chrom_dig_n Chrom_dig_d data_need
end

for model_n = 1:N_total
    %% ���нű��ļ�
    batname = 'Tes_3_23_';
    model_n_n = num2str(model_n);
    batname = strcat(batname,model_n_n);
    batname = strcat(batname,'.vbs');
    path = fullfile('E:\WXY\vbs\', batname);
    Cmd = [path];
    system(Cmd);  
    %% ��ȡ���ɵ�report 1-21
    data_max = zeros(N_total,1);
    data_min = zeros(N_total,1);
    for report_n = 2:21
        path_data = "E:\WXY\csv\Report_";
        report_n_n = num2str(report_n);
        path_data = strcat(path_data,report_n_n);
        path_data = strcat(path_data,".csv");
        data = csvread(path_data,1,1,[1,1,179,1]);
        data_max(report_n-1,1) = max(max(data));
        data_min(report_n-1,1) = min(min(data));
    end
    Data_Max_Full = max(max(data_max));
    Data_Min_Full = min(min(data_min));
    data_need(model_n,1) = Data_Max_Full;
    data_need(model_n,2) = Data_Min_Full;
    data_need(model_n,3) = (Data_Max_Full-Data_Min_Full)/((Data_Max_Full+Data_Min_Full)/2);
    % ���.mat�ļ�
    save data_fc  Chrom_dig_n Chrom_dig_d data_need Chrom N_total
end
