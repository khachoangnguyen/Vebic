

Pi = X_op(:,1);
Crp = X_op(:,2);
SoI = X_op(:,3);
%SoI(7,1)= -3.702835;
Pi_nox = x_op_con(:,1);
Crp_nox = x_op_con(:,2);
SoI_nox = x_op_con(:,3);
% Scatter map for Pi

% Pi map
[fitresult_pi, ~] = Lowess_Fit(speeds, quantity, Pi);
[fitresult_pi_nox, ~] = Lowess_Fit(speeds, quantity, Pi_nox);
[x_p,y_p] = meshgrid(0:125:2500, 10:3.25:80);
pi_fit = fitresult_pi(x_p,y_p);
pi_nox_fit = fitresult_pi_nox(x_p,y_p);
figure()
surf(x_p,y_p,pi_fit)
hold on
mesh(x_p,y_p,pi_nox_fit)
%plot3(speeds,quantity,X_op(:,1),'o')
ylabel('Inj. Quantity (mg)','fontsize',30)
xlabel('Speeds (rpm)','fontsize',30)
zlabel('Boost pressure (gauge pressure)','fontsize',30)
title('Boost Pressure map','fontsize',30)
set(gca,'fontsize',30)
xlim([900 2600])
ylim([0 80])
zlim([0 2.2])
legend({'Without constraints','Constrained'},'FontSize',20,'Location','NorthEast')
% Scatter map for CRP

% Crp map
[fitresult_crp, ~] = Lowess_Fit(speeds, quantity, Crp);
[fitresult_crp_nox, ~] = Lowess_Fit(speeds, quantity, Crp_nox);
[x_c,y_c] = meshgrid(0:125:2500, 0:4.5:90);
crp = fitresult_crp(x_c,y_c);
crp_nox = fitresult_crp_nox(x_c,y_c);
figure()
surf(x_c,y_c,crp)
hold on
mesh(x_c,y_c,crp_nox)
ylabel('Inj. Quantity (mg)','fontsize',30)
xlabel('Speeds (rpm)','fontsize',30)
zlabel('CRP (bar)','fontsize',30)
title('Common Rail Pressure map','fontsize',30)
set(gca,'fontsize',30)
xlim([900 2600])
ylim([0 80])
zlim([200 2000])
legend({'Without constraints','Constrained'},'FontSize',20,'Location','NorthEast')
% Scatter map for SoI
% SoI map
[fitresult_soi, ~] = Lowess_Fit(speeds, quantity, SoI);
[fitresult_soi_nox, ~] = Lowess_Fit(speeds, quantity, SoI_nox);
[x_s,y_s] = meshgrid(0:125:2500, 0:4.5:90);
soi = fitresult_soi(x_s,y_s);
soi_nox = fitresult_soi_nox(x_s,y_s);
figure()
surf(x_s,y_s,soi)
hold on
mesh(x_s,y_s,soi_nox,'FaceLighting','gouraud','LineWidth',0.3)
% plot3(speeds,quantity,X_op(:,3),'o')
ylabel('Inj. Quantity (mg)','fontsize',30)
xlabel('Speeds (rpm)','fontsize',30)
zlabel('Start of Inj. (deg BTDC)','fontsize',30)
title('Start of Injection map','fontsize',30)
set(gca,'fontsize',30)
xlim([900 2600])
ylim([0 80])
zlim([-10 6])
legend({'Without constraints','Constrained'},'FontSize',20,'Location','NorthEast')
