function action = do_action_softmax(policy)
p = cumsum(reshape(policy,1,4)); act = rand;
action = sum([0, p(1:end-1)] < act);
end