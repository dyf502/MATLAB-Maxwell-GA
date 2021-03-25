%% ��ʼ
% ��2-25��
for yr = 2:3
    false = 0;
    true = 1;
    %% ���븸���������Ӵ���Ⱥ
    %��ز���
    GGAP = 0.9; %����
    %yr = 2; %��������
    year = num2str(yr);
    Pm = 0.1; %�������
    k_1 = 3; %n����Ľ����
    k_2 = 4; %d����Ľ����

    SUBPOP = 1; %��P88��
    InsOpt = [0, 1]; %�Ӵ������ʽ ��P88��
    load data_fc;
    Nonun = zeros (N_total, 1);

    for i = 1:N_total
        Nonun(i, 1) = (data_need(i, 1) - data_need(i, 2)) / ((data_need(i, 1) + data_need(i, 2)) / 2);
    end

    FintV = ranking(Nonun); %������Ӧ��ֵ
    SelCh = select('sus', Chrom, FintV); %ѡ��
    %[m,n]=size(SelCh);
    SelCh_str = num2str(SelCh);
    SelCh_str = char(strrep(cellstr(SelCh_str), ' ', '')); %ȥ���ַ����ڿո�

    for i = 1:N_total
        SelCh_str_n(i, 1:6) = SelCh_str(i, 1:6);
        SelCh_str_d(i, 1:8) = SelCh_str(i, 7:14);
    end

    %ȥ�ո�
    %SelCh_dig_n = zeros (x,1); SelCh_dig_d = zeros (x,1);

    SelCh_dig_n = zeros(N_total, 6); SelCh_dig_d = zeros(N_total, 8);

    for i = 1:N_total

        for n_1 = 1:6
            SelCh_dig_n(i, n_1) = str2double(SelCh_str_n(i, n_1));
            %SelCh_str_n_new(i,:) = dec2bin(SelCh_dig_n(i,:));
        end

        for m_1 = 1:8
            SelCh_dig_d(i, m_1) = str2double(SelCh_str_d(i, m_1));
            %SelCh_str_d_new(i,:) = dec2bin(SelCh_dig_d(i,:));
        end

    end

    %SelCh_str_d = char(strrep(cellstr(SelCh_str_d),' ',''));  %ȥ���ַ����ڿո�
    %recombin part
    %SelCh_n = recombin('xovsp',SelCh_str_n);
    %SelCh_d = recombin('xovsp',SelCh_str_d);

    %�������
    SelCh_n = xovsprs (SelCh_dig_n, k_1);
    SelCh_d = xovsprs (SelCh_dig_d, k_2);
    SelCh_new = [SelCh_n, SelCh_d]; %�ѻ���Ƭ���������
    %����
    SelCh_new = mut(SelCh_new, Pm);
    Chrom = reins(Chrom, SelCh, SUBPOP, InsOpt);
    %��������
    data_need = zeros(N_total, 3);
    Chrom_dig_n = zeros(N_total, 1);
    Chrom_dig_d = zeros(N_total, 1);
    Chrom_str = num2str(Chrom);
    Chrom_str = char(strrep(cellstr(Chrom_str), ' ', '')); %ȥ���ַ����ڿո�

    for i = 1:N_total
        Chrom_10_n = Chrom_str(i, 1:6);
        Chrom_dig_n(i, 1) = bin2dec (Chrom_10_n);
        Chrom_10_d = Chrom_str(i, 7:14);
        Chrom_dig_d(i, 1) = bin2dec (Chrom_10_d);
    end

    %save data_fc  Chrom_dig_n Chrom_dig_d data_need Chrom N_total;
    % ���.mat�ļ�
    %save data_fc  Chrom_dig_n Chrom_dig_d data_need
    for model_n = 1:N_total
        %% �ļ�·��
        hfssExePath = 'C:\Program Files\AnsysEM\Maxwell16.0\Win64\maxwell.exe';
        % maxwell����·��
        model_n_n = num2str(model_n);
        tmpPrjFile = 'E:\WXY\mx\Tes_3_23_';
        tmpPrjFile = strcat(tmpPrjFile, year);
        tmpPrjFile = strcat(tmpPrjFile, '_');
        tmpPrjFile = strcat(tmpPrjFile, model_n_n);
        tmpPrjFile = strcat(tmpPrjFile, '.mxwl');
        %tmpDataFile = 'E:\ansoft\temp\tmpData.dat';
        tmpScriptFile = 'E:\WXY\vbs\Tes_3_23_';
        tmpScriptFile = strcat(tmpScriptFile, year);
        tmpScriptFile = strcat(tmpScriptFile, '_');
        tmpScriptFile = strcat(tmpScriptFile, model_n_n);
        tmpScriptFile = strcat(tmpScriptFile, '.vbs');
        %tmpScriptFile = 'E:\WXY\vbs\Tes_3_23.vbs';
        % ��ʱ�ļ�·��
        fid = fopen(tmpScriptFile, 'wt'); % д��

        %% ����һ���µĹ��̲�����һ���µ����
        if model_n == 1
            hfssNewProject(fid);
            DesignName = 'Tes_3_23_';
            DesignName = strcat(DesignName, year);
            DesignName = strcat(DesignName, '_');
            DesignName = strcat(DesignName, model_n_n);
            hfssInsertDesign(fid, DesignName);
            hfssSaveProject(fid, tmpPrjFile, true);
        else
            DesignName = 'Tes_3_23_';
            DesignName = strcat(DesignName, year);
            DesignName = strcat(DesignName, '_');
            DesignName = strcat(DesignName, model_n_n);
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
        batname = strcat(batname, year);
        batname = strcat(batname, '_');
        batname = strcat(batname, model_n_n);
        batname = strcat(batname, '.vbs');
        path = fullfile('E:\WXY\vbs\', batname);
        Cmd = [path];
        system(Cmd);
        %% ��ȡ���ɵ�report 1-21
        data_max = zeros(N_total, 1);
        data_min = zeros(N_total, 1);

        for report_n = 2:21
            path_data = "E:\WXY\csv\Report_";
            report_n_n = num2str(report_n);
            path_data = strcat(path_data, report_n_n);
            path_data = strcat(path_data, ".csv");
            data = csvread(path_data, 1, 1, [1, 1, 179, 1]);
            data_max(report_n - 1, 1) = max(max(data));
            data_min(report_n - 1, 1) = min(min(data));
        end

        Data_Max_Full = max(max(data_max));
        Data_Min_Full = min(min(data_min));
        data_need(model_n, 1) = Data_Max_Full;
        data_need(model_n, 2) = Data_Min_Full;
        data_need(model_n, 3) = (Data_Max_Full - Data_Min_Full) / ((Data_Max_Full + Data_Min_Full) / 2);
        % ���.mat�ļ�
        save data_fc Chrom_dig_n Chrom_dig_d data_need Chrom N_total
    end

end
