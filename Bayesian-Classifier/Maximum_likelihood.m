%neglecting number of features because they are equal
function [p] = Maximum_Likelihood(X,Mean,Variance)
l = det(Variance);
M = inv(Variance);
P = (-log(l))/2;
o =(-(double(X) - double(Mean))'* double(M) *(double(X)  -double(Mean)))/2;
p = P + o;
end
