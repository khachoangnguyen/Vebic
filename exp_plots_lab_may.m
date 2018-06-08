%% 
close all
clear all
clc
font_size_ticks = 16;
set(0,'DefaultFigureWindowStyle','docked')


font_size = 20;
font_size_2 = 20;
line_width = 2;
%% Read excel file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Model validation data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% num = importdata('test_data.xlsx');
% num = importdata('test_data_25102016.xlsx'); %speed, load and VGT open-loop
% num = num.x1400Rpm;
% num = num.x1600Rpm;
% num = importdata('test_data_29102016.xlsx'); % VGT data
% num = num.VGTtest;
numfiles = 15; mm = 6; dd = 15; speed = 1600; load = 100;
%num = cell(1, numfiles);
for k = 1:numfiles
myfilename = sprintf('2017%02d%02d-%drpm-load%d_doe_%d.txt', [mm,dd,speed,load,k]);
num{k} = importdata(myfilename);
%num = importdata('20170615-1600rpm-load100_doe_1.txt');
num{k} = num{k}.data;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Controllers testing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% num = importdata('test_data_18112016.xlsx'); % VGT data
% num = num.PID;
% num = num.PID_act;
% num = num.MRAC;
% num = num.MRAC_act;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Controllers testing
% num = importdata('test_data_24112016.xlsx'); % VGT data
% num = num.PID;
% num = num.PID_act;
% num = num.MRAC;
% num = num.MRAC_act;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Save data into variables
% for j = 1:numfiles
%     a(j) = size(num{1,j},1);
% end
% mat_size = max(a);
% speed_ref = zeros(mat_size,numfiles);
% speed_exp = zeros(mat_size,numfiles);
% torque_ref = zeros(mat_size,numfiles);
% torque_exp = zeros(mat_size,numfiles);
% boost_ref = zeros(mat_size,numfiles);
% boost_exp = zeros(mat_size,numfiles);
% vgt_ref = zeros(mat_size,numfiles);
% vgt_exp = zeros(mat_size,numfiles);
% cr_pressure_ref = zeros(mat_size,numfiles);
% cr_pressure_exp = zeros(mat_size,numfiles);
% cr_pressure_control_exp = zeros(mat_size,numfiles);
% 
% p_x_exp = zeros(mat_size,numfiles);
% 
% inj_qty = zeros(mat_size,numfiles);
% flow_rate = zeros(mat_size,numfiles);
% power = zeros(mat_size,numfiles);
% bsfc_exp = zeros(mat_size,numfiles);
% start_of_inj = zeros(mat_size,numfiles);
for i = 1:numfiles

read_start = 1; % might vary depending which row data starts apear in excel file
speed_ref = num{i}(read_start:end,1);
speed_exp = num{i}(read_start:end,2);
torque_ref = num{i}(read_start:end,3);
torque_exp = num{i}(read_start:end,4);
boost_ref = num{i}(read_start:end,5)+1.013;
boost_exp = num{i}(read_start:end,6)+1.013;
vgt_ref = num{i}(read_start:end,15)./4.2;
vgt_exp = num{i}(read_start:end,16)./4.2;

% vgt_ref =cellfun(@str2num,num(read_start:end,12))./3.5; %older version
% vgt_exp =cellfun(@str2num,num(read_start:end,13))./3.5;

cr_pressure_ref = num{i}(read_start:end,10);
cr_pressure_exp = num{i}(read_start:end,12);
cr_pressure_control_exp = num{i}(read_start:end,11);

p_x_exp = num{i}(read_start:end,8) + 1.013;

inj_qty = num{i}(read_start:end,14) + 31;
flow_rate = (2.*(inj_qty./1000).*60.*speed_exp);
power = (((speed_exp.*(2*pi/60)).*torque_exp)./1000);
bsfc_exp = flow_rate./power;
start_of_inj = num{i}(read_start:end,13);

% bsfc_exp =cellfun(@str2num,num(8:end,14))./3600; %[g/h] %older version
% afr_exp =cellfun(@str2num,num(8:end,read_start));
%fuel_flow_exp =cellfun(@str2num,num(read_start:end,15))./3600; %[g/h]
%afr_exp =cellfun(@str2num,num(read_start:end,19));



% Filtering
% close all
scaling=30;
coeff24hMA = ones(1, scaling)/scaling;
speed_filt = filter(coeff24hMA, 1, speed_exp);
boost_filt = filter(coeff24hMA, 1, boost_exp);
boost_ref_filt = filter(coeff24hMA, 1, boost_ref);
torque_exp_filt =filter(coeff24hMA, 1, torque_exp);
cr_pressure_filt = filter(coeff24hMA, 1, cr_pressure_exp);
cr_pressure_ref_filt = filter(coeff24hMA, 1, cr_pressure_ref);

bsfc_exp_filt = filter(coeff24hMA, 1, bsfc_exp);
% cr_pressure_control_exp_filt = filter(coeff24hMA, 1, cr_pressure_control_exp);

p_x_filt = filter(coeff24hMA, 1, p_x_exp);

%afr_filt = filter(coeff24hMA, 1, afr_exp);

scaling = 20;
coeff24hMA = ones(1, scaling)/scaling;
vgt_ref_filt = filter(coeff24hMA, 1, vgt_ref);
vgt_exp_filt = filter(coeff24hMA, 1, vgt_exp);
% plot(speed_filt)
% cellfun(@str2num,d)


% Tests, Combustion Engine Lab (CEL) Oct 2016
% close all
time_exp = 1:length(speed_ref);
time_exp = time_exp/10;

t_start = 20;
% t_end = 250000;
speed_filt_t = ones(1,length(speed_filt));
speed_filt_t(t_start:end) = speed_filt(1:length(speed_filt)-t_start+1);

% Plot data
%close all

% figure
set(gca,'fontsize',20)
set(gcf, 'color', 'w')

%plot(time_exp,speed_ref,time_exp,speed_exp,time_exp,speed_filt,'k')
% hold on
% plot(time_exp,speed_ref,time_exp,speed_filt,'k')
% legend('reference','measured','Filtered')
% title('Engine speed','fontsize',20)
% ylabel('Speed (rpm)','Fontsize',font_size)
% xlabel('Time (sec)','Fontsize',font_size)
% % ylim([800 2000])
% % ylim([1400 1600])
% grid on
% hold on

% subplot(322)
% %plot(time_exp,torque_ref,time_exp,torque_exp)
% % hold on
% plot(time_exp,torque_ref,time_exp,torque_exp_filt)
% title('Torque','fontsize',20)
% ylabel('Torque (Nm)','Fontsize',font_size)
% xlabel('Time (sec)','Fontsize',font_size)
% % ylim([800 1600])
% grid on
% hold on

% subplot(323)
% plot(time_exp,inj_qty)
% title('Injection Quantity','fontsize',20)
% ylabel('Injection Qty (mg)','Fontsize',font_size)
% xlabel('Time (sec)','Fontsize',font_size)
% % ylim([800 1600])
% grid on
% hold on

subplot(221)
plot(time_exp,start_of_inj)
% hold on
% legend('reference','measured')
title('Start of Injection','fontsize',20)
ylabel('SoI (deg BTDC)','Fontsize',font_size)
xlabel('Time (sec)','Fontsize',font_size)
xlim([0 15])
grid on
hold on

% figure
subplot(222)
% plot(time_exp,boost_ref,time_exp,boost_exp)
% hold on
plot(time_exp,boost_ref_filt,'k',time_exp,boost_filt)
%legend('reference','Boost filtered')
title('Boost pressure','fontsize',20)
ylabel('Boost (bar)','Fontsize',font_size)
xlabel('Time (sec)','Fontsize',font_size)
xlim([0 15])
ylim([1 2.5])
grid on
hold on

subplot(223)
 %plot(time_exp,cr_pressure_ref,time_exp,cr_pressure_exp)
%  hold on
plot(time_exp,cr_pressure_ref_filt,time_exp,cr_pressure_filt)
%legend('reference','measured')
title('CR pressure','fontsize',20)
ylabel('CR pressure (bar)','Fontsize',font_size)
xlabel('Time (sec)','Fontsize',font_size)
xlim([0 15])
ylim([800 1500])
grid on
hold on

subplot(224)
plot(time_exp,bsfc_exp_filt)
% legend('reference','measured')
title('BSFC','fontsize',20)
ylabel('BSFC (g/kWh)','Fontsize',font_size)
xlabel('Time (sec)','Fontsize',font_size)
xlim([0 15])
ylim([525 700])
grid on
hold on
% subplot(212)
% plot(time_exp,vgt_exp_filt,time_exp,vgt_ref_filt,'k')
% legend('measured position','controller signal')
% title('VGT control')
% ylabel('VGT position (V)','Fontsize',font_size)
% xlabel('Time (sec)','Fontsize',font_size)
% % ylim([1.01 1.6])
% grid on

% figure


% subplot(312)
% plot(time_exp,cr_pressure_control_exp)
% % hold on
% % legend('reference','measured')
% title('CR control signal')
% % ylabel('CR pressure (bar)','Fontsize',font_size)
% xlabel('Time (sec)','Fontsize',font_size)
% % ylim([1.01 1.6])
% grid on

% 

% figure
end
% %% Lambda
% close all
% figure
% set(gcf, 'color', 'w')
% plot(time_exp+150,afr_exp./14.6,'k')
% % legend('reference','measured')
% title('Lambda')
% ylabel('Lambda','Fontsize',font_size)
% xlabel('Time (sec)','Fontsize',font_size)
% % ylim([1.01 1.6])
% % xlim([440 540])
% grid on
