function [s1,s2,env] = env_reset(env)
   env.done = false;
   while true
       start = randi(env.dimSize,1,2);
       if isequal(start,env.Target) || isequal(start,env.Hole) || isequal(start,env.Target2)
           continue;
       else
           break;
       end
   end
   env.Start = start;
   s1 = env.Start(1); s2 = env.Start(2);
   env.s1 = s1; env.s2 = s2;
   env.numSteps = 0;
end