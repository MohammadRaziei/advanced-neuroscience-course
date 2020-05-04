function [action, RL] = RL_policy_softmax(env, RL)
% m = RL.m_act; s1 = env.s1; s2 = env.s2; beta = env.beta;
% policy = exp(beta*m(s1,s2,:))./sum(exp(beta*m(s1,s2,:)),3);
% [~,action] = max(policy(:));

m = RL.m_act; s1 = env.s1; s2 = env.s2; beta = RL.beta;
% mask = squeeze(env.mask(s1,s2,:));
% policy = squeeze(exp(beta*m(s1,s2,:))) .*mask;
% policy = policy./sum(policy);
% policy_max = max(policy);
% temp = find(policy == policy_max);
policy = exp(beta*m) .*env.mask;
policy = policy./repmat(sum(policy,3),1,1,4);
policy_at_state = squeeze(policy(s1,s2,:));
policy_max = max(policy_at_state);
temp = find(policy_at_state == policy_max);

action = temp(randi(length(temp))); 
RL.policy = policy;
end