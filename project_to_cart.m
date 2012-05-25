function proj = project_to_cart(endpoint, line)

a = line(1);
b = line(2);
c = line(3);
x = endpoint(1);
y = endpoint(2);


normal = [b; -a; a*y-b*x];
proj = cross(normal, line);
proj = proj(1:2)/proj(3);


end