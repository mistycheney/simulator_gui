function cart = line_polar2cart(polar)

r = polar(1);
theta = polar(2);

cart = [cos(theta); sin(theta); -r];

end