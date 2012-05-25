function line_g = lines_local2global(line_l, pose)

x = pose(1);
y = pose(2);
theta = pose(3);

% R = [cos(theta) -sin(theta); sin(theta) cos(theta)];

line_g = struct('polar',{},'cart',{},'e1',{},'e2',{});


for i=1:length(line_l)
    
    %     e1_g = R*line_l(i).e1 + pose(1:2);
    %     e2_g = R*line_l(i).e2 + pose(1:2);
    %
    %     cart_g = line_endpoints2cart(e1_g, e2_g);
    %     polar_g = line_cart2polar(cart_g);
    %
    %     r_g = polar_g(1);
    %     assert(r_g >= 0);
    %     psi_g = polar_g(2);
    %     assert(psi_g >= -pi && psi_g <= pi);
    %
    %     line_g(i) = struct('polar',polar_g,'cart',cart_g,'e1',e1_g,'e2',e2_g);
    
    line = line_l(i);
    r = line.polar(1);
    psi = line.polar(2);
    
    if is_intersect_polar_local(line.polar, pose)
        r_g = -r + x*cos(psi+theta-pi) + y*sin(psi+theta-pi);
        psi_g = psi + theta - pi;
    else
        r_g = r + x*cos(psi+theta) + y*sin(psi+theta);
        psi_g = psi + theta;
    end
    
%     if r_g < 0
%         r_g = -r_g;
%         if psi_g > 0
%             psi_g = psi_g - pi;
%         else
%             psi_g = psi_g + pi;
%         end
%     end
    
%     assert(r_g>=0);
%     assert(psi_g>=-pi && psi_g<=pi);
    
    
    
    polar_g = [r_g; psi_g];
        
    cart_g = line_polar2cart(polar_g);
    e1_g = point_local2global(line.e1, pose);
    e2_g = point_local2global(line.e2, pose);
    
    line_g(i) = struct('polar',polar_g,'cart',cart_g, 'e1',e1_g,'e2',e2_g);
    
end

end