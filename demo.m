% clear all
% clc
val_data = importdata('Validation_data_240418.xlsx');

bsfc_nom = val_data.data(:,4);
bsfc_hicon = val_data.data(:,8);
bsfc_uncon = val_data.data(:,12);
bsfc_locon = val_data.data(:,16);

fuel_nom = val_data.data(:,3);
fuel_hicon = val_data.data(:,7);
fuel_uncon = val_data.data(:,11);
fuel_locon = val_data.data(:,15);

nox_nom = val_data.data(:,5);
nox_hicon = val_data.data(:,9);
nox_uncon = val_data.data(:,13);
nox_locon = val_data.data(:,17);

temp_nom = val_data.data(:,6);
temp_hicon = val_data.data(:,10);
temp_uncon = val_data.data(:,14);
temp_locon = val_data.data(:,18);

% Val = struct('fuel_nom',fuel_nom,'fuel_con',fuel_con,'fuel_uncon',fuel_uncon,'bsfc_nom',bsfc_nom,'bsfc_con',bsfc_con,'bsfc_uncon',...
%     bsfc_uncon,'nox_nom',nox_nom,'nox_con',nox_con,'nox_uncon',nox_uncon,...
%     'temp_nom',temp_nom,'temp_con',temp_con,'temp_uncon',temp_uncon);
% save('Val_data_240418.mat','Val');
%% Plotting fuel
figure
y_fuel = [fuel_nom fuel_hicon fuel_uncon fuel_locon];
bar(y_fuel)
ylabel('Fuel consumption (g/s)')
xlabel('Validating points')
title('Fuel consumption comparison')
legend('Nominal', 'High constrained', 'Unconstrained', 'Low constrained')
set(gca,'fontsize',30)
set(findall(gca, 'Type', 'Line'),'LineWidth',2.5);

fuel_diff_1 = fuel_hicon-fuel_nom;
fuel_diff_2 = fuel_uncon-fuel_nom;
fuel_diff_3 = fuel_locon-fuel_nom;
y_fuel_diff = [fuel_diff_1 fuel_diff_2 fuel_diff_3];
figure
bar(y_fuel_diff)
ylabel('(g/s)')
xlabel('Validating points')
title('Fuel consumption difference')
legend('High constrained vs. Nominal','Unconstrained vs. Nominal','Low constrained vs. Nominal')
set(gca,'fontsize',30)
set(findall(gca, 'Type', 'Line'),'LineWidth',2.5);

fuel_per_1 = ((fuel_hicon-fuel_nom)./fuel_nom)*100;
fuel_per_2 = ((fuel_uncon-fuel_nom)./fuel_nom)*100;
fuel_per_3 = ((fuel_locon-fuel_nom)./fuel_nom)*100;
y_fuel_per = [fuel_per_1 fuel_per_2 fuel_per_3];
figure
bar(y_fuel_per)
ylabel('Percent (%)')
xlabel('Validating points')
title('Fuel consumption change in percentage')
legend('High constrained vs. Nominal','Unconstrained vs. Nominal','Low constrained vs. Nominal')
set(gca,'fontsize',25)
set(findall(gca, 'Type', 'Line'),'LineWidth',2.5);
ylim([-4 7])
%% Plotting bsfc
figure
y_bsfc = [bsfc_nom bsfc_hicon bsfc_uncon bsfc_locon];
bar(y_bsfc)
ylabel('BSFC (g/kWh)')
xlabel('Validating points')
title('BSFC comparison')
legend('Nominal', 'High constrained', 'Unconstrained', 'Low constrained')
set(gca,'fontsize',30)
set(findall(gca, 'Type', 'Line'),'LineWidth',2.5);

bsfc_per_1 = ((bsfc_hicon-bsfc_nom)./bsfc_nom)*100;
bsfc_per_2 = ((bsfc_uncon-bsfc_nom)./bsfc_nom)*100;
bsfc_per_3 = ((bsfc_locon-bsfc_nom)./bsfc_nom)*100;
y_bsfc_per = [bsfc_per_1 bsfc_per_2 bsfc_per_3];
figure
bar(y_bsfc_per)
ylabel('Percent (%)')
xlabel('Validating points')
title('BSFC change in percentage')
legend('High constrained vs. Nominal','Unconstrained vs. Nominal','Low constrained vs. Nominal')
set(gca,'fontsize',25)
set(findall(gca, 'Type', 'Line'),'LineWidth',2.5);
ylim([-4 7])

%% Plotting NOx
figure
y_nox = [nox_nom nox_hicon nox_uncon nox_locon];
bar(y_nox)
ylabel('NOx (ppm)')
xlabel('Validating points')
title('NOx emissions measurements')
legend({'Nominal', 'High constrained', 'Unconstrained', 'Low constrained'},'Location','NorthWest')
set(gca,'fontsize',30)
set(findall(gca, 'Type', 'Line'),'LineWidth',2.5);
ylim([380 2300])

nox_per_1 = ((nox_hicon-nox_nom)./nox_nom)*100;
nox_per_2 = ((nox_uncon-nox_nom)./nox_nom)*100;
nox_per_3 = ((nox_locon-nox_nom)./nox_nom)*100;
y_nox_per = [nox_per_1 nox_per_2 nox_per_3];
figure
bar(y_nox_per)
ylabel('Percent (%)')
xlabel('Validating points')
title('NOx change in percentage')
legend('High constrained vs. Nominal','Unconstrained vs. Nominal','Low constrained vs. Nominal')
set(gca,'fontsize',25)
set(findall(gca, 'Type', 'Line'),'LineWidth',2.5);
ylim([-60 90])
%%
% nox_1 = NOx(:,1:5);
% figure
% bar(nox_1)
% ylabel('NOx (ppm)')
% xlabel('Running order')
% title('NOx emissions at different loads')
% legend({'1000rpm-100kW','1000rpm-200kW','1000rpm-400kW','1000rpm-600kW','1000rpm-800kW'},'CenterNorth')
% set(gca,'fontsize',25)
% set(findall(gca, 'Type', 'Line'),'LineWidth',2.5);
% 
% nox_2 = NOx(:,[2 7 10 13]);
% figure
% bar(nox_2)
% ylabel('NOx (ppm)')
% xlabel('Running order')
% title('NOx emissions at different speeds')
% legend({'1000rpm-200kW','900rpm-200kW','800rpm-200kW','700rpm-200kW'},'CenterNorth')
% set(gca,'fontsize',25)
% set(findall(gca, 'Type', 'Line'),'LineWidth',2.5);

%% Plotting temp
figure
y_temp = [temp_nom temp_hicon temp_uncon temp_locon];
bar(y_temp)
ylabel('Exhaust Gas Temp. (C degree)')
xlabel('Validating points')
title('Exhaust Gas Temp. comparison')
legend('Nominal', 'High constrained', 'Unconstrained', 'Low constrained')
set(gca,'fontsize',30)
set(findall(gca, 'Type', 'Line'),'LineWidth',3);
ylim([250 440])