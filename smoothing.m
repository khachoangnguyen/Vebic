function [smooth_map] = smoothing(map_NOx, thresh, tit, tit_smooth, zlab, limx, limy, limz,r)
% clear all
% clc
%load('Pi_map.mat')
%map_NOx = SoI_map_NOx;
Pi = map_NOx;
Pi_conv = map_NOx;
% %Convolution method
% A = 1/9*(ones(3,3));
% conv_mat = conv2(Pi_conv,A);
% smooth_map_conv = conv_mat(2:52,2:52);
%Matrix padding
a = size(map_NOx,1);
Pi = [Pi(:,1),Pi,Pi(:,a)];
Pi = [Pi(1,:);Pi;Pi(a,:)];
for k = 2 : a+1
   for i = 2 : a+1
      sq = [Pi(k-1,i-1), Pi(k-1,i), Pi(k-1,i+1);
            Pi(k,i-1), Pi(k,i), Pi(k,i+1);
            Pi(k+1,i-1), Pi(k+1,i), Pi(k+1,i+1)];
      ave = (Pi(k-1,i-1)+Pi(k-1,i)+Pi(k-1,i+1)+...
            Pi(k+1,i-1)+Pi(k+1,i)+Pi(k+1,i+1)+...
            Pi(k,i-1)+Pi(k,i+1)+Pi(k,i))/9;
        Pi(k,i) = ave;

%       r1 = abs(Pi(k,i)/ave);
%       R(k-1,i-1) = r1;
%       if isnan(R(k-1,i-1))
%           R(k-1,i-1) = 0;
%       end
%       if r1 > thresh
%       Pi(k,i) = ave;
%       end
   end
end
r_1 = 2500/r;
r_2 = (80-15)/r;
smooth_map = Pi(2:a+1,2:a+1);
[x_c,y_c] = meshgrid(0:r_1:2500, 15:r_2:80);
%[x_c,y_c] = meshgrid(0:50:2500, 0:1.8:90);
%[x_c,y_c] = meshgrid(0:125:2500, 0:4.5:90);
figure
surf(x_c,y_c,map_NOx)
ylabel('Inj. Quantity (mg)','fontsize',30)
xlabel('Speeds (rpm)','fontsize',30)
zlabel(zlab,'fontsize',30)
title(tit,'fontsize',30)
set(gca,'fontsize',30)
xlim(limx)
ylim(limy)
zlim(limz)
figure
surf(x_c,y_c,smooth_map)
ylabel('Inj. Quantity (mg)','fontsize',30)
xlabel('Speeds (rpm)','fontsize',30)
zlabel(zlab,'fontsize',30)
title(tit_smooth,'fontsize',30)
set(gca,'fontsize',30)
xlim(limx)
ylim(limy)
zlim(limz)
% figure
% surf(x_c,y_c,smooth_map_conv)
% ylabel('Inj. Quantity (mg)','fontsize',30)
% xlabel('Speeds (rpm)','fontsize',30)
% zlabel(zlab,'fontsize',30)
% title(tit_smooth,'fontsize',30)
% set(gca,'fontsize',30)
% xlim(limx)
% ylim(limy)
% zlim(limz)
% %
% load('SoI_map.mat')
% Soi = SoI_map_NOx;
% Soi = [Soi(:,1),Soi,Soi(:,16)];
% Soi = [Soi(1,:);Soi;Soi(16,:)];
% for i = 2:17
%    for k = 2:17
%       sq = [Soi(k-1,i-1), Soi(k-1,i), Soi(k-1,i+1);
%             Soi(k,i-1), Soi(k,i), Soi(k,i+1);
%             Soi(k+1,i-1), Soi(k+1,i), Soi(k+1,i+1)];
%       ave = (Soi(k-1,i-1)+Soi(k-1,i)+Soi(k-1,i+1)+...
%             Soi(k+1,i-1)+Soi(k+1,i)+Soi(k+1,i+1)+...
%             Soi(k,i-1)+Soi(k,i+1))/8;
%       r2 = Soi(k,i)/ave;
%       if r2 > 1.3
%       Soi(k,i) = ave;
%       end
%    end
% end
% Soi_smooth = Soi(2:17,2:17);
% %
% load('CRP_map.mat')
% Crp = CRP_map_NOx;
% Crp = [Crp(:,1),Crp,Crp(:,16)];
% Crp = [Crp(1,:);Crp;Crp(16,:)];
% for i = 2:17
%    for k = 2:17
%       sq = [Crp(k-1,i-1), Crp(k-1,i), Crp(k-1,i+1);
%             Crp(k,i-1), Crp(k,i), Crp(k,i+1);
%             Crp(k+1,i-1), Crp(k+1,i), Crp(k+1,i+1)];
%       ave = (Crp(k-1,i-1)+Crp(k-1,i)+Crp(k-1,i+1)+...
%             Crp(k+1,i-1)+Crp(k+1,i)+Crp(k+1,i+1)+...
%             Crp(k,i-1)+Crp(k,i+1))/8;
%       r3 = Crp(k,i)/ave;
%       if r3 > 1.3
%       Crp(k,i) = ave;
%       end
%    end
% end
% Crp_smooth = Crp(2:17,2:17);
end