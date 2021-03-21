%% 利用软件包创建一个圆柱体
clear all;
false = 0;
true = 1;
%% HFSS执行路径
hfssExePath = 'C:\Program Files\AnsysEM\Maxwell16.0\Win64\maxwell.exe';
% 临时文件路径
tmpPrjFile = 'C:\Users\95340\Desktop\MRI\api\testing3_16_1.mxwl';
%tmpDataFile = 'E:\ansoft\temp\tmpData.dat';
tmpScriptFile = 'C:\Users\95340\Desktop\MRI\api\testing3_16_1.vbs';
% 创建一个新的HFSS临时脚本文件
fid = fopen(tmpScriptFile, 'wt'); % 'wt'表示以文本模式打开文件，可写，覆盖原有内容
%% 创建一个新的工程并插入一个新的设计 设计参数
hfssNewProject(fid);
hfssInsertDesign(fid, 'Testing3_16_1');
% 线圈数目
n = 10;
% 层数 nc = 4;
% 线圈宽度 ys
ys = 20;
d = 10;
%% 创建模型&电流
%创建坐标轴CS1
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

    %改回global CS
    ChangeCS(fid, 0);
    %建立底层线路
    level_s = num2str(level);

    for i = 1:n
        yp = (i - 1) * (d + ys);
        i_n = num2str(i);
        %BoxName = strcat(box,)
        BoxName = strcat('BOX_', level_s);
        BoxName = strcat(BoxName, '_');
        BoxName = strcat(BoxName, i_n);
        %建立底层线路
        MaxBoxFRP(fid, BoxName, ys, yp, zs, zp, FRP_copper);
    end

    fprintf(fid, '\n');
    level_s = num2str(level);
    section_n = count * 2 - 1;
    MaxSection(fid, level_s, n, section_n); %建立截面并添加电流
    %count = count + 1;
end

%% 添加观测区域
ChangeCS(fid, 0);
FRP_vacuum = "vacuum";
BoxName_ob = "BoxObserve";
zs = 345;
zp = 0;
ys = yp + ys;
yp = 0;
MaxBoxFRP(fid, BoxName_ob, ys, yp, zs, zp, FRP_vacuum);
% 添加5倍观测区域

%% 添加analysis
count_i = 10; %迭代次数
p_error = 1;
Maxanlysis(fid, count_i, p_error);

%% 开始运行
MaxRun(fid);

%% 生成观测面并取点
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
    Circle = strcat(Circle,i_n);
    FileName = "Report_";
    FileName = strcat(FileName,i_n);

    z = 59 + 10*i;
    
    %生成截面

    if i == 1
        continue
    end
    if i == 21
        z = 169;
        MaxChangeCStoXZ(fid);
        R_tem = 100;
        MaxBuildCir(fid,Circle,z,-y,R_tem);
        R_p = 2*pi*R_tem;
        MaxReport(fid,FileName,Circle,R_p);
        break
    end 
        CreateCS(fid, CS_Name, x, y, z);
        ChangeCS(fid, 0);
        h = 10*abs(11 - i);
        R_tem = sqrt(R^2 - h^2);
        MaxBuildCir(fid,Circle,y,z,R_tem);
        R_p = 2*pi*R_tem;
        MaxReport(fid,FileName,Circle,R_p);
    end


%    
    %取点
    
%     if i == 1 || i == 21
%         open = 1;
%         Mag_Name = "Mag_Y_";
%         Mag_Name = strcat(Mag_Name,i_n);
%         MaxFieldBY(fid,Mag_Name,CS_Name);
%         ChangeCS(fid, 0);
%         MaxGetPoint(fid, x, y, z,FileName);
%     else

% for i = 1:2
%     i_n = num2str(i);
%     CS_Name = "CS_Ob_";
%     CS_Name = strcat(CS_Name, i_n);
%     Mag_Name = "Mag_";
%     Mag_Name = strcat(Mag_Name,i_n);
%     z = 158 + i;
%     CreateCS(fid, CS_Name, x, y, z);
%     %生成截面
%     MaxField(fid,Mag_Name,CS_Name);
%     %取点
%     if i == 1 || i == 21
%         ChangeCS(fid, 0);
%         MaxGetPoint(fid, x, y, z);
%     else
%         ChangeCS(fid, 0);
%         for j = 1:180
%             h = abs(11 - i);
%             R_tem = sqrt(R^2 - h^2);
%             x_p = R_tem * sind(2*j);
%             y_p = R_tem * cosd(2*j);
%             MaxGetPoint(fid, x+x_p, y+y_p, z);
%         end
%     end
% 
%     ChangeCS(fid, 0);
% end

% for i = 1:21
%     i_n = num2str(i);
%     CS_Name = strcat(CS_Name, i_n);
%     z = 158 + i;
%     CreateCS(fid, CS_Name, x, y, z);
%     %生成截面
%     MaxField(fid);
%     %取点
%     if i == 1 || i == 21
%         MaxGetPoint(fid, x, y, z);
%     else
%         for j = 1:360
%             h = abs(11 - i);
%             R_tem = sqrt(R^2 - h^2);
%             x_p = R_tem * sind(j);
%             y_p = R_tem * cosd(j);
%             MaxGetPoint(fid, x_p, y_p, z)
%         end
%     end
% 
%     ChangeCS(fid, 0);
% end

% 导出csv文件

%% 保存文件
hfssSaveProject(fid, tmpPrjFile, true);
fclose(fid);
fclose('all');
