function a = env_action_space_sample(env)
mask = env.mask(env.s1,env.s2,:);
m = find(mask);
a = m(randi(length(m)));
end