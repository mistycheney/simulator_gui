function data2 = remove_zeros(data)
PP = [];
for i=1:size(data,2)
    if all(data(:,i))
        PP = [PP data(:,i)];
    end
end
data2 = PP;

end