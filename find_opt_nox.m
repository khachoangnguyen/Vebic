function [x_op,fval,iter] = find_opt_nox(X0,b_1,b_nox,ranges,lim)
f = @(X1,X2,X3) (b_1(1) + b_1(2)*X1 + b_1(3)*X2 + b_1(4)*X3...
      + b_1(5)*X1*X2 + b_1(6)*X1*X3 + b_1(7)*X2*X3...
      + b_1(8)*X1^2 + b_1(9)*X2^2 + b_1(10)*X3^2);
f_op = @(X) f(X(1),X(2),X(3));


% options = optimoptions('fminunc','Algorithm','quasi-newton');
% options.Display = 'iter';
% [x, fval, exitflag, output] = fminunc(f_op,X0,options);

A = [];
b_c = [];
Aeq = [];
beq = [];
lb = ranges(:,1)';
ub = ranges(:,2)';
%nonlcon = @unitdisk;
nonlcon = @(X) nonlincon(X,b_nox,lim);

options = optimoptions(@fmincon,'Algorithm','sqp','MaxIterations',300,'MaxFunctionEvaluations',10000,'ConstraintTolerance',1.0000e-03,'StepTolerance',1.0000e-09);
%sequential quadratic programming
[x,fval,exitflag,output,lambda,grad,hessian] = fmincon(f_op,X0,A,b_c,Aeq,beq,lb,ub,nonlcon,options);
iter = output.iterations;
x_op = x;
end