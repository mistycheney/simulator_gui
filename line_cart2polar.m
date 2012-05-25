function polar = line_cart2polar(cart)

a = cart(1);
b = cart(2);
c = cart(3);

if c>=0
    theta = atan2(-b, -a);
    polar = [c/norm([a,b]); theta];
else
    theta = atan2(b, a);
    polar = [-c/norm([a,b]); theta];
end

end