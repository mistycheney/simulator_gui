function line = line_endpoints2cart(p1, p2)

line = cross([p1; 1], [p2; 1]);


end