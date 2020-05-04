function [action, RL] = RL_policy_softmax(env, RL)
% m = RL.m_act; s1 = env.s1; s2 = env.s2; beta = env.beta;
% policy = exp(beta*m(s1,s2,:))./sum(exp(beta*m(s1,s2,:)),3);
% [~,action] = max(policy(:));

m = RL.m_act; s1 = env.s1; s2 = env.s2; beta = RL.beta;
mask = squeeze(env.mask(s1,s2,:));
policy = squeeze(exp(beta*m(s1,s2,:)))./sum(exp(beta*m(s1,s2,:)),3).*mask;
[~,action] = max(policy);
temp = find(policy == policy(action));
action = temp(randi(length(temp))); 

RL.policy = policy;


end