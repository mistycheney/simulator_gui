function d = angle_diff_quadrant(a1, a2)

d = acos(abs(cos(a1-a2)));

% d = abs(a1 - a2);
% 
% if d > pi/2 && d < pi
%     d = pi-d;
% elseif d >= pi
%     d = 2*pi-d;
% end

assert(d>=0 && d<= pi/2)

end