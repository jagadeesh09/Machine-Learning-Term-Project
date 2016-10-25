function [p] = Gaussian_Distribution(X,Mean,Var)
l = sqrt(det(Var));
M = inv(Var);
o = exp(-0.5 * ((double(X) - double(Mean))'* M *(double(X)  -double(Mean))));
p = (1/l) * o;
end
