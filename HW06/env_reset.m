function [s1,s2,env] = env_reset(env)
   env.done = false;
   s1 = env.Start(1); s2 = env.Start(2);
   env.s1 = s1; env.s2 = s2;
   env.numSteps = 0;
end