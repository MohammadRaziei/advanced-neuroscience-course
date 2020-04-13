function [test_idx, train_idx] = devide_test_train_indices(m,p_train)
idx = randperm(m);
train_idx = idx(1:round(p_train*m)); 
test_idx = idx(round(p_train*m)+1:end);