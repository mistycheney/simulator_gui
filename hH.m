function [h, H] = hH(statei)

% nstate = length(state);
x = statei(1);
y = statei(2);
theta = statei(3);
% nlines = (nstate-3)/2;

% polar = state(2*i+2:2*i+3);
% r = polar(1);
% psi = polar(2);

% h = zeros(2*nlines, 1);
% H = zeros(2*nlines, nstate);
%
% for i = 1:nlines
%     polar = state(2*i+2:2*i+3);
%     r = polar(1);
%     psi = polar(2);
%
%     if is_intersect_polar_global(polar, state(1:3))
%         h(2*i-1:2*i) = [-r + x*cos(psi) + y*sin(psi); psi - theta + pi];
%         H(2*i-1, 1) = cos(psi);
%         H(2*i-1, 2) = sin(psi);
%         H(2*i-1, 2*i+2:2*i+3) = [-1 -x*sin(psi)+y*cos(psi)];
%         H(2*i, 3) = -1;
%         H(2*i, 2*i+3) = 1;
%     else
%         h(2*i-1:2*i) = [r - x*cos(psi) - y*sin(psi); psi - theta];
%         H(2*i-1, 1) = -cos(psi);
%         H(2*i-1, 2) = -sin(psi);
%         H(2*i-1, 2*i+2:2*i+3) = [1 x*sin(psi)-y*cos(psi)];
%         H(2*i, 3) = -1;
%         H(2*i, 2*i+3) = 1;
%     end
%
% end

polar = statei(4:5);

polar = standard_polar(polar);

r = polar(1);
psi = polar(2);



if is_intersect_polar_global(polar, statei(1:3))
    h = [-r + x*cos(psi) + y*sin(psi); psi - theta + pi];
    H(1, 1) = cos(psi);
    H(1, 2) = sin(psi);
    H(1, 4:5) = [-1 -x*sin(psi)+y*cos(psi)];
    H(2, 3) = -1;
    H(2, 5) = 1;
else
    h = [r - x*cos(psi) - y*sin(psi); psi - theta];
    H(1, 1) = -cos(psi);
    H(1, 2) = -sin(psi);
    H(1, 4:5) = [1 x*sin(psi)-y*cos(psi)];
    H(2, 3) = -1;
    H(2, 5) = 1;
end

end