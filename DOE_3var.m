function [b_coeff,X_op,fval,b,mdl] = DOE_3var(range,y_i,plot_title,factor_1,factor_2,factor_3,response);
% fitresult(x,y) = b0 + b1*x + b2*y + b12*x*y  + b11*x^2 + b22*y^2

%% Design of Experiments (DoE)

%ranges = [0.1, 0.9; 1100, 1400; -4, 13];
% range_x1 = ranges(1,:);
% range_x2 = ranges(2,:);
% range_x3 = ranges(3,:);


%[matrix,c1,c2,c3] = matrixDesign_3var(range_x1,range_x2,range_x3); %Getting running table
%[matrix,c1,c2,c3] =  matrixDesign_BoxBehnken(range_x1,range_x2,range_x3);

CodedValue = [1	-1	0;
0	1	-1;
0	1	1;
-1	0	-1;
-1	0	1;
0	-1	-1;
0	-1	1;
-1	-1	0;
1	0	-1;
1	0	1;
0	0	0;
1	1	0;
-1	1	0;
];
% bounds = [range_x1; range_x2; range_x3];  % Min and max values for each factor
matrix = zeros(size(CodedValue));
for i = 1:size(CodedValue,2) % Convert coded values to real-world units
    zmax = max(CodedValue(:,i));
    zmin = min(CodedValue(:,i));
    matrix(:,i) = interp1([zmin zmax],range(i,:),CodedValue(:,i));
end
%% Data extracting & processing
%[x1,x2,x3,y] = simulation_3var(matrix,noise);  %Model simulation
% rpm = 1600; load = 200; 
n = size(matrix,1);
%y = extractData(rpm,load,n);
%y = extractData(mm,dd,speed,load,n); %Extract experiment data by month,day,speed,load
y = y_i;
x1 = zeros(length(matrix),1);
x2 = zeros(length(matrix),1);
x3 = zeros(length(matrix),1);
for i = 1:length(matrix)
   x_1 = matrix(i,1);
   x_2 = matrix(i,2);
   x_3 = matrix(i,3);
      

   x1(i,:) = x_1;
   x2(i,:) = x_2;
   x3(i,:) = x_3;
end
% Visualizing data
runorder = randperm(size(CodedValue,1)); 
% disp({'Run Number','Boost Pressure','CRP','SoI','BSFC'})
% disp(sortrows([runorder' matrix y]))

%% Fitting model

% [b] = fitting(x1,x2,x3,y)

% Using Machine Learning toolbox
Expmt = table(x1, x2, x3, y,'VariableNames',{'CRP','MFI','CA_press','BSFC'});
mdl = fitlm(Expmt,'BSFC~CRP*MFI*CA_press-CRP:MFI:CA_press+CRP^2+MFI^2+CA_press^2');
b = mdl.Coefficients;
b_coeff = mdl.Coefficients.Estimate;
% Visualize the coefficients
set(0,'DefaultFigureWindowStyle','docked')
figure()
h = bar(mdl.Coefficients.Estimate(2:10));
set(h,'facecolor',[0.8 0.8 0.9])
legend('Coefficient')
%set(gcf,'units','normalized','position',[0.05 0.4 0.35 0.4])
set(gca,'xticklabel',mdl.CoefficientNames(2:10))
set(gca,'fontsize',20)
ylabel('BSFC (g/(kW.h))')
xlabel('Normalized Coefficient')
title('Quadratic Model Coefficients')

%% Validation

%[SS_e,s_e,SS_total,r_sq,r_sq_adj] = validation_3var(range_x1,range_x2,range_x3,noise,b,y)

% [SS_e,s_e,SS_total,r_sq,r_sq_adj] = validation_test(matrix,b1,y)

% Validation test results from Machine learning toolbox
SS_e = mdl.SSE;
SS_total = mdl.SST;
r_sqr = mdl.Rsquared;

%% Optimization

%X0 = [c1 c2 c3];
X0 = sum(range',1)/size(range',1);
[X_op,fval,iter] = find_opt(X0,b.Estimate,range);

% Visualize surface response (x3 fixed at optimal value)
VisualizeData(b_coeff,range,X_op,fval,plot_title,factor_1,factor_2,factor_3,response);
%% Data saving
% data = struct('Pi',x1,'CRP',x2,'SoI',x3,response,y,'Coefficients',b.Estimate,'Optimal_points',X_op,...
%     'Minimum_values',fval,'Modelling',mdl);
% datetime = datestr(date);
% datetime = strrep(datetime,'-','_');%Replace minus sign with underscore
% save(datetime,'data')

end
