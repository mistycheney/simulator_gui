function plot_line_cart(cart, x)

a = cart(1);
b = cart(2);
c = cart(3);

% if length(x)>1
if cart(2) == 0
    plot(x,-c/a,'k');
else
    plot(x,(-a*x-c)/b,'k');
end
% else
%     plot(x,y,'k');
% end


end