function RL = RL_action_space_softmax(RL,s1,s2,o1,o2,policy,action)
m = RL.m_act; epsilon = RL.epsilon; 

for a = 1:4
    aei =  double(action == a);
    m(s1,s2,a) = m(s1,s2,a) + epsilon*(aei-policy(a))*mean(RL.V(o1,o2));
end
RL.m_act = m;
end