function out = env_calc_optimalPath(env)
    out1 = sum(abs(env.Target - env.Start));
	out2 = inf;
	if not(isequal(env.Target2,[0 0]))
		out2 = sum(abs(env.Target2 - env.Start));
	end
	out = min(out1,out2);
end