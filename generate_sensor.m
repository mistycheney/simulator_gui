function d = generate_sensor(params, pose, lines, Q)

% lines = true_lines;

fov = params.fov;
np = params.np;
delta = fov/np/180*pi;
nl = length(lines);

x = pose(1);
y = pose(2);
theta = pose(3);

D = zeros(np,nl);
d = zeros(1,np);

phi = zeros(1,np);
s = zeros(3,np);
for i=1:np
    phi(i) = round_angle_pi_pi(theta + delta*(i-np/2));
    a = tan(phi(i));
    s(:,i) = [a; -1; y-a*x];
end

p_touch = zeros(2,np);
% compute intersections

% plot_line_cart(s(:,50),[0 1]);

for j = 1:nl,
    for i = 1:np
        p_homo = cross(lines(j).cart,s(:,i));
        p = p_homo(1:2)/p_homo(3);
                
        D(i,j) = norm(p-[x; y]);
        
        p_on_line = (p(1) - lines(j).e1(1))*(p(1) - lines(j).e2(1)) <= 0;
        p_on_ray = (phi(i)>=-pi/2 && phi(i)<=pi/2 && p(1) >= x) ||...
            ((phi(i)>=pi/2 || phi(i)<=-pi/2) && p(1) <= x);
        if  p_on_line && p_on_ray && (d(i) == 0 || D(i,j) < d(i))            
            d(i) = min(D(i,j), params.max_range);
            p_touch(:,i) = p;
        end
    end
end

var_rho = Q(1,1);

valid = d>0;
d = d + sqrt(var_rho)*randn(1, np);
d = d .* valid;

% assert(all(d>0));

end