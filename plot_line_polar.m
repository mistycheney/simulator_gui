function plot_line_polar(polar, x)

% figure;
if polar(2) == 0
%     plot(x([1,end]),y([1,end]),'k');
    plot(x([1 end]),[-1 1],'k');
else
    theta = line_polar2cart(polar);
    a = theta(1);
    b = theta(2);
    c = theta(3);
    plot(x,(-a*x-c)/b,'k');
end
end