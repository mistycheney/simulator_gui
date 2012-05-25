function p_l = point_global2local(p_g, pose)

theta = pose(3);

R = [cos(-theta) -sin(-theta); sin(-theta) cos(-theta)];
p_l = R*(p_g - pose(1:2));

end