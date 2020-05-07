function [action, RL] = RL_policy_softmax(env, RL, s1, s2)

m = RL.m_act; beta = RL.beta;

policy = exp(beta*squeeze(m(s1,s2,:))) .*squeeze(env.mask(s1,s2,:));
policy = policy./sum(policy);
RL.policy = policy;

action = do_action_softmax(policy);
end