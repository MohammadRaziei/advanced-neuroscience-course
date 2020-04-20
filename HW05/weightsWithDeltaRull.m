function w = weightsWithDeltaRull(u,r,ep)
    w = zeros(size(u,1), size(u,2)+1);
    for t = 1:length(u)
        v = w(:,t)' * u(:,t);
        d = r(t) - v;
        w(:,t+1) = w(:,t) + ep*d*u(:,t);
    end
end