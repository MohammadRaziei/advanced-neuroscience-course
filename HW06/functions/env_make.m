function env = env_make()
    %% shape
    dimSize = 10;
    env.dimSize = dimSize;
    env.Target = [3,3];
	env.Target2 = [0 0];
    env.Hole = [5,7];
    env.Start = [9,5];
    
    %% reward
    R = zeros(dimSize);
    R(env.Target(1),env.Target(2)) = 1;
    R(env.Hole(1),env.Hole(2)) = -1;
    env.reward = R;
    %% mask
    mask = ones(dimSize, dimSize, 4); %news % 2413
    mask(:,dimSize,2) = -0; mask(dimSize,:,4) = -0; mask(1,:,1) = -0; mask(:,1,3) = -0;
    env.mask = mask;

    %% map
    env.map = ones(env.dimSize);
    env.map(env.Target(1),env.Target(2)) = 0;
    env.map(env.Hole(1),env.Hole(2)) = 0.45;
    env.color_agent = 0.8;
%     env.map(env.Start(1),env.Start(2)) = env.color_agent;
    
    
    

end