function polar_g = polar_local2global(polar_l, pose)

x = pose(1);
y = pose(2);
theta = pose(3);

r = polar_l(1);
psi = polar_l(2);

if is_intersect_polar_local(polar_l, pose)
    polar_g = [-r + x*cos(psi+theta-pi) + y*sin(psi+theta-pi);...
        psi + theta - pi];
else
    polar_g = [r + x*cos(psi-theta) + y*sin(psi-theta);...
        psi - theta];
end

end