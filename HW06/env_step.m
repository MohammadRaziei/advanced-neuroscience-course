function [o1, o2, reward, env] = env_step(env, action)

[o1, o2] = env_next_state(action, env.s1, env.s2);

o = [o1, o2];
if isequal(o,env.Target) || isequal(o,env.Hole)
    env.done = true;
end
env.numSteps = env.numSteps + 1;
reward = env.reward(o1,o2);% - 0.02 * env.numSteps;

% env.s1 = o1; env.s2 = o2;

end