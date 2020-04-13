function out = rows_labeling(raw, labels)% cols
% labels = [3    -1;3     1;6    -1;6     1;9    -1;9     1];
out = zeros(size(raw,1),1);
for i = 1:size(raw,1)
    tmp = raw(i,:);
    for lab = 1:length(labels)
        if tmp == labels(lab,:)
            out(i) = lab;
            break
        end
    end
end

