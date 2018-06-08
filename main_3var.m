% function main(speed, injection_quantity)
clear all
clc
close all
load('bsfc.mat');

ranges_file = sprintf('Ranges.xlsx'); % Limits of input factors
ranges_data = importdata(ranges_file);
ranges = ranges_data.data;

speeds = [1000 1000 1000 1000 1000 900 900 900 800 800 800 700 700 600];
loads = [100 200 400 600 800 100 200 400 100 200 300 100 200 150];
% Map resolutions (number of intervals)
r = 20;


%Optimization
X_op = zeros(14,3);
fval = zeros(14,1);

for i = 1:size(speeds,2)
    range = ranges(1:3,2*i-1:2*i);
    y_i = bsfc(:,i);
    plot_title = sprintf('Brake Specific Fuel Consumption');
    factor_1 = sprintf('CRP (bar)');
    factor_2 = sprintf('MFI (deg BTDC)');
    factor_3 = sprintf('Pi (gauge pressure)');
    response = sprintf('BSFC (g/kW.h)');
    [b_1(:,i),X_op(i,:),fval(i,:),b,mdl] = DOE_3var(range,y_i,plot_title,factor_1,factor_2,factor_3,response);
    mdl_stat{:,:,i} = mdl;
    b_stat{:,:,i} = b;
    n = i; 
    fig_name = sprintf('BSFC');
    %dir = sprintf('C:\Users\nguyenk4\Downloads\GT-suite model MATLAB code\Plots');
%     save_all_figures(fig_name,'C:\Users\nguyenk4\Downloads\GT-suite model MATLAB code\Plots',n)
%     close all
end

%% Visualizing optimal maps without NOx
[Pi_map, CRP_map, MFI_map] = createMap(X_op,speeds,loads,r);
% n = []; fig_name = sprintf('Optimal map w.o NOx');
% save_all_figures(fig_name,'C:\Users\nguyenk4\Downloads\GT-suite model MATLAB code\Plot_writing',n)
% close all
%% NOx emissions modeling
load('NOx.mat');
for i = 1: size(NOx,2)
    range = ranges(1:3,2*i-1:2*i);
    y_i = NOx(:,i);
    plot_title = sprintf('NOx emissions');
    factor_1 = sprintf('CRP (bar)');
    factor_2 = sprintf('MFI (deg BTDC)');
    factor_3 = sprintf('Pi (gauge pressure)');
    response = sprintf('NOx (ppm)');
    [b_nox(:,i),X_op_NOx(i,:),fval_NOx(i,:)] = DOE_3var(range,y_i,plot_title,factor_1,factor_2,factor_3,response);
    n = i;
%     fig_name = sprintf('NOx concentration');
%     save_all_figures(fig_name,'C:\Users\nguyenk4\Downloads\GT-suite model MATLAB code\Plots',n)
%     close all
end
%% Visualizing optimal maps with minimized NOx
[Pi_map_NOx, CRP_map_NOx, MFI_map_NOx] = createMap(X_op_NOx,speeds,loads,r);
% n = []; fig_name = sprintf('Minimized NOx');
% %save_all_figures(fig_name,'C:\Users\nguyenk4\Downloads\GT-suite model MATLAB code\Plots',n)
% %close all
%% BSFC optimization with NOx constraints
for i = 1
range = ranges(1:3,2*i-1:2*i);
X0 = sum(range',1)/size(range',1);
lim = fval_NOx(i);
b_nox_opt = b_nox(:,i);
b_1_opt = b_1(:,i);
[x_op_con(i,:),fval_con(i,:),iter] = find_opt_nox(X0,b_1_opt,b_nox_opt,range,lim);
plot_title = sprintf('Brake Specific Fuel Consumption (NOx constrained)');
factor_1 = sprintf('CRP (bar)');
factor_2 = sprintf('MFI (deg BTDC)');
factor_3 = sprintf('Pi (gauge pressure)');
response = sprintf('BSFC (g/kW.h)');
%VisualizeData(b_1_opt,range,x_op_con(i,:),fval_con(i,:),plot_title,factor_1,factor_2,factor_3,response)
VisualizeData_con(b_1_opt,b_nox_opt,range,x_op_con(i,:),fval_con(i,:),fval_NOx(i),plot_title,factor_1,factor_2,factor_3,response)
%n = i;
% fig_name = sprintf('BSFC_cons');
% save_all_figures(fig_name,'C:\Users\nguyenk4\Downloads\GT-suite model MATLAB code\Plots',n)
% close all
end
%% Visualizing optimal maps with NOx constraints
[Pi_map_NOx, CRP_map_NOx, MFI_map_NOx] = createMap(x_op_con,speeds,loads,r);
% n = []; fig_name = sprintf('Optimal map NOx constraints');
% save_all_figures(fig_name,'C:\Users\nguyenk4\Downloads\GT-suite model MATLAB code\Plot_writing',n)
% close all
%% Smoothing maps
title1 = sprintf('Boost Pressure map');title1_1 = sprintf('Boost Pressure smoothed map');
title2 = sprintf('Common Rail Pressure');title2_1 = sprintf('Common Rail Pressure smoothed map');
title3 = sprintf('Main Fuel Injection');title3_1 = sprintf('Main Fuel Injection smoothed map');
zlabel1 = sprintf('Boost Pressure');
zlabel2 = sprintf('Common Rail Pressure (bar)');
zlabel3 = sprintf('Main Fuel Injection (dBTDC)');
limx = [900 2600]; limy = [10 90];
limz1 = [0 2.2]; limz2 = [200 2000]; limz3 = [-11 6]; 
[Pi_map_smooth] = smoothing(Pi_map_NOx,0.9,title1,title1_1,'Boost Pressure',limx,limy,limz1,r);
[CRP_map_smooth] = smoothing(CRP_map_NOx,0.8,title2,title2_1,'Common Rail Pressure (bar)',limx,limy,limz2,r);
[MFI_map_smooth] = smoothing(MFI_map_NOx,0.8,title3,title3_1,'Main Fuel Injection (dBTDC)',limx,limy,limz3,r);

