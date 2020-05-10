function [B,f] = fit_exponential(x,y,B0)
    f = @(b,x) b(1).*exp(b(2).*x)+b(3);                                     % Objective Function
    B = fminsearch(@(b) norm(y - f(b,x)), B0); %[50; 0; 10]
end