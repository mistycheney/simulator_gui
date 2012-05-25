function p = rad2cart_robot_centric(d,fov)
[nt, np] = size(d);
% convert to Cartesian
radianFov = fov/180*pi;
p = zeros(np, 2, nt);
% p = zeros(2,np);
for t = 1:nt
    p(:,1,t) = d(t,:).*cos(linspace(-radianFov/2, radianFov/2, np));
    p(:,2,t) = d(t,:).*sin(linspace(-radianFov/2, radianFov/2, np));
end

% p(1,:) = d.*cos(linspace(-radianFov/2, radianFov/2, np)');
% p(2,:) = d.*sin(linspace(-radianFov/2, radianFov/2, np)');

end