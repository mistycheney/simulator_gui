function line = build_line_endpoints(polar, e1, e2)

cart = line_polar2cart(polar);
line = struct('polar',polar,'cart',cart,'e1',e1,'e2',e2,'Cl',[0 0;0 0]);

end