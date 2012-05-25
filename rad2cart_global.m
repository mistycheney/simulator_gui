function p = rad2cart_global(d,pose,fov)
[np, nt] = size(d);
x = pose(:,1);
y = pose(:,2);
theta = pose(:,3);
% convert to Cartesian
radianFov = fov/180*pi;
p = zeros(np, 2, nt);
for t = 1:nt
    p(:,1,t) = x(t) + d(:,t).*cos(theta(t) + linspace(-radianFov/2, radianFov/2, np)');
    p(:,2,t) = y(t) + d(:,t).*sin(theta(t) + linspace(-radianFov/2, radianFov/2, np)');
end

end