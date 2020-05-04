function RL = RL_action_space_softmax(RL,action,o1,o2)
m = RL.m_act; epsilon = RL.epsilon;

for i = 1:4
    aei =  double(action == i);
    m = m + epsilon*(aei-RL.policy(action))*mean(RL.V(o1,o2));
end
RL.m_act = m;
end