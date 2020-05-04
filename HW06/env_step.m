function [o1, o2, reward, env] = env_step(env, action)
s1 = env.s1;
s2 = env.s2;
switch action
    case 1 % n
        o1 = s1 - 1; o2 = s2; 
    case 2 % e
        o1 = s1; o2 = s2 + 1;
    case 3 % w
        o1 = s1; o2 = s2 - 1;
    case 4 % s
        o1 = s1 + 1; o2 = s2;
end

o = [o1, o2];
if isequal(o,env.Target) || isequal(o,env.Hole)
    env.done = true;
end
env.numSteps = env.numSteps + 1;
reward = env.reward(o1,o2);% - 0.02 * env.numSteps;

% env.s1 = o1; env.s2 = o2;

end