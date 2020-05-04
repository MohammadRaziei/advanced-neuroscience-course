function RL = RL_action_space_softmax(env,RL,action,o1,o2)
m = RL.m_act; epsilon = RL.epsilon; 
s1 = env.s1; s2 = env.s2;

for i = 1:4
    aei =  double(action == i);
    m(s1,s2) = m(s1,s2) + epsilon*(aei-RL.policy(s1,s2,action))*mean(RL.V(o1,o2));
end
RL.m_act = m;
end