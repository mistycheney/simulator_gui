function line_l = lines_global2local(line_g, pose)

line_l = struct('polar',{},'cart',{},'e1',{},'e2',{});
x = pose(1);
y = pose(2);
theta = pose(3);


for i=1:length(line_g)
    
    %     e1_l = point_global2local(line_g(i).e1, pose);
    %     e2_l = point_global2local(line_g(i).e2, pose);
    %
    %     cart_l = line_endpoints2cart(e1_l, e2_l);
    %     polar_l = line_cart2polar(cart_l);
    %
    %     r_l = polar_l(1);
    %     assert(r_l >= 0);
    %     psi_l = polar_l(2);
    %     assert(psi_l >= -pi && psi_l <= pi);
    %
    %     line_l(i) = struct('polar',polar_l,'cart',cart_l, 'e1',e1_l,'e2',e2_l);
    
    line = line_g(i);
    r = line.polar(1);
    psi = line.polar(2);
    
    if is_intersect_lines(line, pose)
        polar_l = [-r + x*cos(psi) + y*sin(psi); psi - theta + pi];
    else
        polar_l = [r - x*cos(psi) - y*sin(psi); psi - theta];
    end
    cart_l = line_polar2cart(polar_l);
    e1_l = point_global2local(line.e1);
    e2_l = point_global2local(line.e2);
    
    line_l(i) = struct('polar',polar_l,'cart',cart_l, 'e1',e1_l,'e2',e2_l);
    
end

end