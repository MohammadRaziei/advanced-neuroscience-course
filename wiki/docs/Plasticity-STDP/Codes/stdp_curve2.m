function out = stdp_curve2(t_post_pre_diff)
A_p = 1.03;
A_n = -.51;
tau_p = 0.014;
tau_n = 0.038;

out = zeros(size(t_post_pre_diff));
ti_p = find(t_post_pre_diff>=0);
ti_n = find(t_post_pre_diff<0);

out(ti_p) = A_p*exp(-t_post_pre_diff(ti_p)/tau_p);
out(ti_n) = A_n*exp(t_post_pre_diff(ti_n)/tau_n);
end