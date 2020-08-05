clc; clear all; close all;
addpath('Codes'); addpath('utils');
rng(10);
%% 
mu = [0 0];
sigma = [1 -0.8; -0.8 1];
% % rng('default')  % For reproducibility
nTrials = 1000;
u = mvnrnd(mu,sigma,nTrials);
% % Plot the random numbers.


figure_position([0.2 0.2 0.3 0.5]);
plot(u(:,1),u(:,2),'.', 0,0,'*r')
ylabel('u2'); xlabel('u1')
title({['\mu = (' char(strjoin(string(mu),',')) ')' ], ['\sigma = (' num2str(sigma(1)) ',' num2str(sigma(2)) ';' num2str(sigma(3)) ',' num2str(sigma(4)) ')' ]})
save_figure(gcf,'results/partC_1-Hebb-u1u2.png')
%%

w = 1e-12*randn(2,1);
dt = 1e-3;
tau_m = 4;
T = dt*nTrials;
for i = 1:size(u,1)
    ui = u(i,:);
%     v = ui*w;
    Q = u'*u/nTrials;
    ep = 0.5*T/tau_m;
    w = w + ep * Q *w;
end

%     ui = u(i,:);
% w = w + nTrials*dt /tau_m * corrcoef(u)*w;
% v = u*w;



figure_position([0.2 0.2 0.3 0.5]);
w = 2.5 * w/max(abs(w));
plot(u(:,1),u(:,2),'.', [-w(1) w(1)] ,[-w(2) w(2)],'r')
xlabel('u1, w1'); ylabel('u2, w2');
title({'Hebb Rule', ['\mu = (' char(strjoin(string(mu),',')) ')' ]})
save_figure(gcf,'results/partC_2-Hebb-w1.png')

%%

[coeff,score,latent] = pca(u,'NumComponents',1);
w = coeff;
figure_position([0.2 0.2 0.3 0.5]);
w = 2.5* w/max(w);
plot(u(:,1),u(:,2),'.', [-w(1) w(1)]+mu(1) ,[-w(2) w(2)]+mu(2),'r')
xlabel('u1, w1'); ylabel('u2, w2');
title({'First PC direction', ['\mu = (' char(strjoin(string(mu),',')) ')' ]})
save_figure(gcf,'results/partC_3-Hebb-pca.png')
%% 
mu = [2 2];
sigma = [1 -0.8; -0.8 1];
nTrials = 1000;
u = mvnrnd(mu,sigma,nTrials);

w = 1e-12*randn(2,1);
dt = 1e-3;
tau_m = 4;
T = dt*nTrials;
for i = 1:size(u,1)
    ui = u(i,:);
%     v = ui*w;
    Q = u'*u/nTrials;
    ep = 0.5*T/tau_m;
    w = w + ep * Q *w;
end



figure_position([0.2 0.2 0.3 0.5]);
w = 2.5 * w/max(abs(w));
plot(u(:,1),u(:,2),'.', [-w(1) w(1)]+mu(1) ,[-w(2) w(2)]+mu(2),'r')
xlabel('u1, w1'); ylabel('u2, w2');
title({'Hebb Rule', ['\mu = (' char(strjoin(string(mu),',')) ')' ]})
save_figure(gcf,'results/partC_4-Hebb-w2.png')

%%
mu = [0 0];
sigma = [1 -0.8; -0.8 1];
nTrials = 1000;
u = mvnrnd(mu,sigma,nTrials);

w = 1e-12*randn(2,1);
dt = 1e-3;
tau_m = 4;
T = dt*nTrials;
for i = 1:size(u,1)
    ui = u(i,:);
%     v = ui*w;
    Q = cov(u);
    ep = 0.5*T/tau_m;
    w = w + ep * Q *w;
end

figure_position([0.2 0.2 0.3 0.5]);
w = 2.5 * w/max(abs(w));
plot(u(:,1),u(:,2),'.', [-w(1) w(1)]+mu(1) ,[-w(2) w(2)]+mu(2),'r')
ylabel('u2'); xlabel('u1')
title({'Cov Rule', ['\mu = (' char(strjoin(string(mu),',')) ')' ]})
save_figure(gcf,'results/partC_5-Cov-w1.png')
%%
mu = [2 2];
sigma = [1 -0.8; -0.8 1];
nTrials = 1000;
u = mvnrnd(mu,sigma,nTrials);

w = 1e-12*randn(2,1);
dt = 1e-3;
tau_m = 4;
T = dt*nTrials;
for i = 1:size(u,1)
    ui = u(i,:);
%     v = ui*w;
    Q = cov(u);
    ep = 0.5*T/tau_m;
    w = w + ep * Q *w;
end

figure_position([0.2 0.2 0.3 0.5]);
w = 2.5 * w/max(abs(w));
plot(u(:,1),u(:,2),'.', [-w(1) w(1)]+mu(1) ,[-w(2) w(2)]+mu(2),'r')
xlabel('u1, w1'); ylabel('u2, w2');
title({'Cov Rule', ['\mu = (' char(strjoin(string(mu),',')) ')' ]})
save_figure(gcf,'results/partC_6-Cov-w2.png')

%%
mu = [0 0];
sigma = [1 -0.8; -0.8 1];
nTrials = 1000;
u = mvnrnd(mu,sigma,nTrials);

tau_theta = 0.001;

dt = 1e-3;
tau_m = 4;
% T = dt*nTrials;
theta = 1e-12*randn;
w = 1e-12*randn(2,1);

for i = 1:size(u,1)
    ui = u(i,:);
    v = ui*w;
    theta = theta + tau_theta/dt *(v.^2-theta);
%     if(isnan(v)) i, break; end
    ep = dt/tau_m;
    w = w + ep * v * ui' * (v - theta) ;
end

figure_position([0.2 0.2 0.3 0.5]);
w = 2.5 * w/max(abs(w));
plot(u(:,1),u(:,2),'.', [-w(1) w(1)]+mu(1) ,[-w(2) w(2)]+mu(2),'r')
ylabel('u2'); xlabel('u1')
title({'BCM Rule', ['\mu = (' char(strjoin(string(mu),',')) ')' ]})
save_figure(gcf,'results/partC_7-BCM-w1.png')

%%
mu = [2 2];
sigma = [1 -0.8; -0.8 1];
nTrials = 1000;
u = mvnrnd(mu,sigma,nTrials);

tau_theta = 0.001;

dt = 1e-3;
tau_m = 4;
T = dt*nTrials;
theta = 1e-12*randn;
w = 1e-12*randn(2,1);

for i = 1:size(u,1)
    ui = u(i,:);
    v = ui*w;
    theta = theta + tau_theta/dt *(v.^2-theta);
%     if(isnan(v)) i, break; end
    ep = dt/tau_m;
    w = w + ep * v * ui' * (v - theta) ;
end

figure_position([0.2 0.2 0.3 0.5]);
w = 2.5 * w/max(abs(w));
plot(u(:,1),u(:,2),'.', [-w(1) w(1)]+mu(1) ,[-w(2) w(2)]+mu(2),'r')
xlabel('u1, w1'); ylabel('u2, w2');
title({'BCM Rule', ['\mu = (' char(strjoin(string(mu),',')) ')' ]})
save_figure(gcf,'results/partC_8-BCM-w2.png')