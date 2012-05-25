function [line, max_d, max_p] = extract_one_line(p)

x = p(1,:)';
y = p(2,:)';

nx = length(x);
assert(nx > 1);

if nx >= 2 && length(unique(x))==1
    a = 1;
    b = 0;
    c = -x(1);
else
    X = [x ones(nx,1)];
    q = X'*X\(X'*y);
    a = -q(1);
    b = 1;
    c = -q(2);
end

[max_d, max_p] = max(abs(a*x+b*y+c)/norm([a,b]));

cart = [a; b; c];

end1 = project_to_cart(p(:,1), cart);
end2 = project_to_cart(p(:,end), cart);

polar = line_cart2polar(cart);

line = struct('polar',polar,'cart',cart,'e1',end1,'e2',end2);

end