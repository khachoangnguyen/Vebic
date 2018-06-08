% function main(speed, injection_quantity)
clear all
clc
close all
% Read data from GT-suite model result
% bsfc_file = sprintf('GT model results.xlsx');
% bsfc_data = importdata(bsfc_file);
% bsfc = bsfc_data.data;

% bsfc_file = sprintf('GT model results_17.xlsx');
% bsfc_data = importdata(bsfc_file);
% bsfc = bsfc_data.data;

% bsfc_file = sprintf('GT model results_12.xlsx');
% bsfc_data = importdata(bsfc_file);
% bsfc = bsfc_data.data;

% ranges_file = sprintf('Ranges.xlsx'); % Limits of input factors
% ranges_data = importdata(ranges_file);
% ranges = ranges_data.data;

% ranges_file = sprintf('Ranges_17.xlsx'); % Limits of input factors
% ranges_data = importdata(ranges_file);
% ranges = ranges_data.data;

% ranges_file = sprintf('Ranges_12.xlsx'); % Limits of input factors
% ranges_data = importdata(ranges_file);
% ranges = ranges_data.data;
% 
% % speeds = [1600 1600 1600 1900 1900 1900 2200 2200 2200]; % 9 operating points (rpm)
% % quantity = [30 45 60 30 45 60 30 45 60]; % Injection quantity
% 
% % speeds = [1300 1300 1300 1600 1600 1600 1900 1900 1900 1900 1900 2200 2200 2200 2500 2500]; % 16 operating points (rpm)
% % quantity = [15 45 75 30 45 60 15 30 45 60 75 30 45 60 45 75]; % Injection quantity
% 
% speeds = [1300 1300 1600 1600 1600 1900 1900 1900 1900 2200 2200 2200]; % 12 operating points (rpm)
% quantity = [45 75 30 45 60 30 45 60 75 30 45 60]; % Injection quantity
% 
% % Map resolutions (number of intervals)
% r = 20;
%r = 50;
P1_high = mean([2.34 2.65 2.73 2.41]);
P1_med = mean([2.54 2.93 2.43 2.24 2.4]);
P1_low = mean([2.2 2.48 2.55 2.23]);

%fuel =[14.33;13.93;14.46;14.64;15.05;14.12;14.24;13.82;13.98];
%fuel = [24.96;24.72;23.8;25.37;24.48;25.65;24.63;25.78;24.91;24.04;24.69;24.19;24.4]; %400kW
fuel = [35.32;34.48;34.03;35.81;35.38;36.27;35.75;37.1;34.72;34.41;34.76;34.1;34.44];
bsfc = (fuel./600).*3600;
ranges=[1150 1650;95 185;2.25 2.65];
% vgt = [20,70];
% for j = 1:size(speeds,2)
% ranges(1,2*j-1)=vgt(1);
% ranges(1,2*j)=vgt(2);
% end
% % Inputs
% speeds = speed;
% quantity = injection_quantity;
%Optimization
% X_op = zeros(size(speeds,2),3);
% fval = zeros(size(speeds,2),1);

for i = 1 
    range = ranges(1:3,2*i-1:2*i);
    y_i = bsfc(:,i);
    plot_title = sprintf('Brake Specific Fuel Consumption');
   
    factor_1 = sprintf('CRP (bar)');
    factor_2 = sprintf('MFI (deg BTDC)');
    factor_3 = sprintf('CA press');
    response = sprintf('BSFC (g/kW.h)');
    [b_1,X_op,fval,b,mdl] = DOE_3var(range,y_i,plot_title,factor_1,factor_2,factor_3,response);
%     mdl_stat{:,:,i} = mdl;
%     b_stat{:,:,i} = b;
%     n = i; 
    fig_name = sprintf('BSFC');
    %dir = sprintf('C:\Users\nguyenk4\Downloads\GT-suite model MATLAB code\Plots');
%     save_all_figures(fig_name,'C:\Users\nguyenk4\Downloads\GT-suite model MATLAB code\Plots',n)
%     close all
end

%% Visualizing optimal maps without NOx
[Pi_map, CRP_map, SoI_map] = createMap(X_op,speeds,quantity,r);
% n = []; fig_name = sprintf('Optimal map w.o NOx');
% save_all_figures(fig_name,'C:\Users\nguyenk4\Downloads\GT-suite model MATLAB code\Plot_writing',n)
% close all
%% NOx emissions modeling
%NOx = [1170 1500 1580 945 973.1 1010 985 798 1312 1368 1165 1852 1225]; %400kW
NOx = [1465 1897 1966 1200 1179 1190 1130 860 1770 1835 1520 2300 1570];
for i = 1 
    range = ranges(1:3,2*i-1:2*i);
    y_i = NOx';
    plot_title = sprintf('NOx emissions');
     factor_1 = sprintf('CRP (bar)');
    factor_2 = sprintf('MFI (deg BTDC)');
    factor_3 = sprintf('CA press');
  
    response = sprintf('NOx concentration (ppm)');
    [b_nox(:,i),X_op_NOx(i,:),fval_NOx(i,:)] = DOE_3var(range,y_i,plot_title,factor_1,factor_2,factor_3,response);
    n = i;
%     fig_name = sprintf('NOx concentration');
%     save_all_figures(fig_name,'C:\Users\nguyenk4\Downloads\GT-suite model MATLAB code\Plots',n)
%     close all
end
%% Visualizing optimal maps with minimized NOx
[Pi_map_NOx, CRP_map_NOx, SoI_map_NOx] = createMap(X_op_NOx,speeds,quantity,r);
% n = []; fig_name = sprintf('Minimized NOx');
% %save_all_figures(fig_name,'C:\Users\nguyenk4\Downloads\GT-suite model MATLAB code\Plots',n)
% %close all
%% BSFC optimization with NOx constraints
for i = 1
range = ranges(1:3,2*i-1:2*i);
X0 = sum(range',1)/size(range',1);
%lim = 6500/11;
lim = fval_NOx(i);
b_nox_opt = b_nox(:,i);
b_1_opt = b_1(:,i);
[x_op_con(i,:),fval_con(i,:),iter] = find_opt_nox(X0,b_1_opt,b_nox_opt,range,lim);
plot_title = sprintf('Brake Specific Fuel Consumption (NOx constrained)');

factor_1 = sprintf('CRP (bar)');
factor_2 = sprintf('MFI (deg BTDC)');
factor_3 = sprintf('CA press');
response = sprintf('BSFC (g/kW.h)');
VisualizeData(b_1_opt,range,x_op_con(i,:),fval_con(i,:),plot_title,factor_1,factor_2,factor_3,response)
n = i;
% fig_name = sprintf('BSFC_cons');
% save_all_figures(fig_name,'C:\Users\nguyenk4\Downloads\GT-suite model MATLAB code\Plots',n)
% close all
end
%% Visualizing optimal maps with NOx constraints
[Pi_map_NOx, CRP_map_NOx, SoI_map_NOx] = createMap(x_op_con,speeds,quantity,r);
% n = []; fig_name = sprintf('Optimal map NOx constraints');
% save_all_figures(fig_name,'C:\Users\nguyenk4\Downloads\GT-suite model MATLAB code\Plot_writing',n)
% close all
%% Smoothing maps
title1 = sprintf('Boost Pressure map');title1_1 = sprintf('Boost Pressure smoothed map');
title2 = sprintf('Common Rail Pressure');title2_1 = sprintf('Common Rail Pressure smoothed map');
title3 = sprintf('Start of Injection');title3_1 = sprintf('Start of Injection smoothed map');
zlabel1 = sprintf('Boost Pressure');
zlabel2 = sprintf('Common Rail Pressure (bar)');
zlabel3 = sprintf('Start of Injection (dBTDC)');
limx = [900 2600]; limy = [10 90];
limz1 = [0 2.2]; limz2 = [200 2000]; limz3 = [-11 6]; 
[Pi_map_smooth] = smoothing(Pi_map_NOx,0.9,title1,title1_1,'Boost Pressure',limx,limy,limz1,r);
[CRP_map_smooth] = smoothing(CRP_map_NOx,0.8,title2,title2_1,'Common Rail Pressure (bar)',limx,limy,limz2,r);
[SoI_map_smooth] = smoothing(SoI_map_NOx,0.8,title3,title3_1,'Start of Injection (dBTDC)',limx,limy,limz3,r);

