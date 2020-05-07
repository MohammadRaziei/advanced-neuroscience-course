function [o1,o2] = env_next_state(action, s1,s2)
switch action
    case 1 % n
        o1 = s1 - 1; o2 = s2; 
    case 2 % e
        o1 = s1; o2 = s2 + 1;
    case 3 % w
        o1 = s1; o2 = s2 - 1;
    case 4 % s
        o1 = s1 + 1; o2 = s2;
end