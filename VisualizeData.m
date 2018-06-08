function VisualizeData(b1,ranges,X_op,fval,plot_title,factor_1,factor_2,factor_3,response)
% b1 = b.Estimate;
f1 = @(X1,X2) b1(1) + b1(2)*X1 + b1(3)*X2 + b1(4)*X_op(3)...
      + b1(5)*X1*X2 + b1(6)*X1*X_op(3) + b1(7)*X2*X_op(3)...
      + b1(8)*X1^2 + b1(9)*X2^2 + b1(10)*X_op(3)^2;
f2 = @(X1,X3) b1(1) + b1(2)*X1 + b1(3)*X_op(2) + b1(4)*X3...
      + b1(5)*X1*X_op(2) + b1(6)*X1*X3 + b1(7)*X_op(2)*X3...
      + b1(8)*X1^2 + b1(9)*X_op(2)^2 + b1(10)*X3^2;
f3 = @(X2,X3) b1(1) + b1(2)*X_op(1) + b1(3)*X2 + b1(4)*X3...
      + b1(5)*X_op(1)*X2 + b1(6)*X_op(1)*X3 + b1(7)*X2*X3...
      + b1(8)*X_op(1)^2 + b1(9)*X2^2 + b1(10)*X3^2;
f = {f1; f2; f3};  %# Cell array of function handles

x1_min = ranges(1,1); 
x1_max = ranges(1,2); 
x2_max = ranges(2,1);
x2_min = ranges(2,2);
x3_max = ranges(3,1);
x3_min = ranges(3,2);
t = 40;
d_1 = gridResolution(x1_max,x1_min,t);
d_2 = gridResolution(x2_max,x2_min,t);
d_3 = gridResolution(x3_max,x3_min,t);
d = [d_1, d_2, d_3];
  
% Showing minimum point
for m = 1:3
    f_v = f(m);
    if m == 1
        x1 = meshgrid(x1_min:d_1:x1_max);
        x2 = (meshgrid(x2_min:d_2:x2_max))';
        
        for i = 1:length(x1)
            for j = 1:length(x2)
                x_1 = x1(i,j);
                x_2 = x2(i,j);
                F(i,j) = feval(f_v{1,1},x_1,x_2);
            end
        end
        figure()
        surf(x1,x2,F)
        
        ylabel(factor_2,'fontsize',20)
        xlabel(factor_1,'fontsize',20)
        zlabel(response,'fontsize',20)
        title(plot_title,'fontsize',20)
        colorbar
        set(gca,'fontsize',20)
        hold on
        h = scatter3(X_op(1),X_op(2),fval,'filled');
        h.SizeData = 150;
        legend(h,'Optimum')
        hold off
    elseif m == 2
        f_v = f(m);
        x1 = meshgrid(x1_min:d_1:x1_max);
        x2 = (meshgrid(x3_min:d_3:x3_max))';
        
        for i = 1:length(x1)
            for j = 1:length(x2)
                x_1 = x1(i,j);
                x_2 = x2(i,j);
                F(i,j) = feval(f_v{1,1},x_1,x_2);
            end
        end
        figure()
        surf(x1,x2,F)
        
        ylabel(factor_3,'fontsize',20)
        xlabel(factor_1,'fontsize',20)
        zlabel(response,'fontsize',20)
        title(plot_title,'fontsize',20)
        colorbar
        set(gca,'fontsize',20)
        hold on
        h = scatter3(X_op(1),X_op(3),fval,'filled');
        h.SizeData = 150;
        legend(h,'Optimum')
        hold off
        
    elseif m == 3
        f_v = f(m);
        x1 = meshgrid(x2_min:d_2:x2_max);
        x2 = (meshgrid(x3_min:d_3:x3_max))';
        
        for i = 1:length(x1)
            for j = 1:length(x2)
                x_1 = x1(i,j);
                x_2 = x2(i,j);
                F(i,j) = feval(f_v{1,1},x_1,x_2);
            end
        end
        figure()
        surf(x1,x2,F)
       
        ylabel(factor_3,'fontsize',20)
        xlabel(factor_2,'fontsize',20)
        zlabel(response,'fontsize',20)
        title(plot_title,'fontsize',20)
        colorbar
        set(gca,'fontsize',20)
        hold on
        h = scatter3(X_op(2),X_op(3),fval,'filled');
        h.SizeData = 150;
        legend(h,'Optimum')
        hold off
        
    end

end


end