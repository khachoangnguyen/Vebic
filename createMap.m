function [pi_fit,crp,mfi] = createMap(X_op,speeds,load,r)

Pi = X_op(:,3);
Crp = X_op(:,1);
SoI = X_op(:,2);

r_1 = 100;
r_2 = 20;
% Scatter map for Pi
figure()
for k = 1:size(X_op,1)
scatter3(speeds(k),load(k),X_op(k,3),'filled')
hold on
end
ylabel('Load (kW)','fontsize',20)
xlabel('Speeds (rpm)','fontsize',20)
zlabel('Boost pressure (gauge pressure)','fontsize',20)
title('Boost Pressure','fontsize',20)
set(gca,'fontsize',20)

% Pi map
[fitresult_pi, gof_pi] = Lowess_Fit(speeds, load, Pi);
[x_p,y_p] = meshgrid(500:r_1:1050, 80:r_2:800);
% [x_p,y_p] = meshgrid(0:50:2500, 0:1.8:90);
% [x_p,y_p] = meshgrid(0:125:2500, 0:4.5:90);
pi_fit = fitresult_pi(x_p,y_p);
figure()
surf(x_p,y_p,pi_fit)
hold on
plot3(speeds,load,X_op(:,3),'o')
ylabel('Load (kW)','fontsize',30)
xlabel('Speeds (rpm)','fontsize',30)
zlabel('Boost pressure (gauge pressure)','fontsize',30)
title('Boost Pressure map','fontsize',30)
set(gca,'fontsize',30)
xlim([500 1050])
ylim([80 800])
zlim([0 4.5])

% Scatter map for CRP
figure()
for n = 1:size(X_op,1)
scatter3(speeds(n),load(n),X_op(n,1),'filled')
hold on
end
ylabel('Load (kW)','fontsize',20)
xlabel('Speeds (rpm)','fontsize',20)
zlabel('CRP (bar)','fontsize',20)
title('Common Rail Pressure','fontsize',20)
set(gca,'fontsize',20)

% Crp map
[fitresult_crp, gof_crp] = Lowess_Fit(speeds, load, Crp);
[x_c,y_c] = meshgrid(500:r_1:1050, 80:r_2:800);
% [x_c,y_c] = meshgrid(0:50:2500, 0:1.8:90);
% [x_c,y_c] = meshgrid(0:125:2500, 0:4.5:90);
crp = fitresult_crp(x_c,y_c);
figure()
surf(x_c,y_c,crp)
hold on
plot3(speeds,load,X_op(:,1),'o')
ylabel('Load (kW)','fontsize',30)
xlabel('Speeds (rpm)','fontsize',30)
zlabel('CRP (bar)','fontsize',30)
title('Common Rail Pressure map','fontsize',30)
set(gca,'fontsize',30)
xlim([500 1050])
ylim([80 800])
zlim([700 1700])

% Scatter map for SoI
figure()
for m = 1:size(X_op,1)
scatter3(speeds(m),load(m),X_op(m,2),'filled')
hold on
end
ylabel('Load (kW)','fontsize',20)
xlabel('Speeds (rpm)','fontsize',20)
zlabel('Start of Inj. (deg BTDC)','fontsize',20)
title('Start of Injection','fontsize',20)
set(gca,'fontsize',20)
% SoI map
[fitresult_soi, gof_soi] = Lowess_Fit(speeds, load, SoI);
[x_s,y_s] = meshgrid(500:r_1:1050, 80:r_2:800);
% [x_s,y_s] = meshgrid(0:50:2500, 0:1.8:90);
% [x_s,y_s] = meshgrid(0:125:2500, 0:4.5:90);
mfi = fitresult_soi(x_s,y_s);
figure()
surf(x_s,y_s,mfi)
hold on
plot3(speeds,load,X_op(:,2),'o')
ylabel('Load (kW)','fontsize',30)
xlabel('Speeds (rpm)','fontsize',30)
zlabel('Start of Inj. (deg BTDC)','fontsize',30)
title('Start of Injection map','fontsize',30)
set(gca,'fontsize',30)
xlim([500 1050])
ylim([80 800])
zlim([20 190])
end