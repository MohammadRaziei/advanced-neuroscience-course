function out = env_calc_optimalPath(env)
    out = sum(abs(env.Target - env.Start));
end