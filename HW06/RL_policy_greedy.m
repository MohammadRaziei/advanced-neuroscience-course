function [action, RL] = RL_policy_greedy(env, RL)

s1 = env.s1; s2 = env.s2;
mask = squeeze(env.mask(s1,s2,:));
allowed_actions = find(mask);
Values_NEWS = -inf(1,4);
for a = allowed_actions
    [o1,o2] = env_next_state(a,s1,s2);
    Values_NEWS(a) = RL.V(o1,o2);
end
max_val = max(Values_NEWS);

policy = double(Values_NEWS == max_val);
policy = policy./sum(policy);
[~,action] = max(policy);
temp = find(policy == policy(action));
action = temp(randi(length(temp))); 


end