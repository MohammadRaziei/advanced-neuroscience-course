add = @(a,b) [zeros(1,length(b)-length(a)) a] + [zeros(1,length(a)-length(b)) b];
subtract =  @(a,b) [zeros(1,length(b)-length(a)) a] - [zeros(1,length(a)-length(b)) b];


plotts = @(a,dt,c) plot(((1:length(a))-1)*dt, a,c);












