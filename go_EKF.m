function [pose, map, P] = go_EKF(delta_pose, pose, map, P, map_local,R)

% P = zeros(3);
% map = build_line();
% true_pose = [0.4;0.5;1];
% pose = true_pose;

m = [map.polar];
m = m(:);

nmap = length(map);
nz = length(map_local);

state = [pose; m];

z = [map_local.polar];
z = z(:);

map_local_g = lines_local2global(map_local, pose + delta_pose);

%%
[c, e1_f, e2_f] = find_matching_lines(map, map_local_g);
c
%%
Cls = {map_local.Cl};
[state, P] = EKF(state, P, delta_pose, z, Cls, c, R);

%%

pose = state(1:3);

for j=1:nz
    i = c(j);
    polar = state(2*i+2:2*i+3);
    
    if i<=nmap
        e1 = project_to_polar(e1_f(:,j), polar);
        e2 = project_to_polar(e2_f(:,j), polar);
    else
        e1 = project_to_polar(map_local_g(j).e1, polar);
        e2 = project_to_polar(map_local_g(j).e2, polar);
    end
    map(i) = build_line_endpoints(polar, e1, e2);
    
end



% end

