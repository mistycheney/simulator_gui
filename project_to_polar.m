function proj = project_to_polar(endpoint, polar)

cart = line_polar2cart(polar);

a = cart(1);
b = cart(2);
c = cart(3);
x = endpoint(1);
y = endpoint(2);


normal = [b; -a; a*y-b*x];
proj = cross(normal, cart);
proj = proj(1:2)/proj(3);


end