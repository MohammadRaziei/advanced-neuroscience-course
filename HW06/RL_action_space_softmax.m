function RL = RL_action_space_softmax(env,RL,action,o1,o2)
m = RL.m_act; epsilon = RL.epsilon; 
s1 = env.s1; s2 = env.s2;

for a = 1:4
    aei =  double(action == a);
    m(s1,s2,a) = m(s1,s2,a) + epsilon*(aei-RL.policy(s1,s2,a))*mean(RL.V(o1,o2));
end
RL.m_act = m;
end