function [o1, o2, reward, env] = env_step(env, action)

[o1, o2] = env_next_state(action, env.s1, env.s2);
s = [env.s1, env.s2];
if isequal(s,env.Target) || isequal(s,env.Hole) || isequal(s,env.Target2)
    env.done = true;
end
env.numSteps = env.numSteps + 1;
reward = env.reward(env.s1,env.s2);% - 0.02 * env.numSteps;


end