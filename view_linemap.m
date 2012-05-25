function view_linemap(lines, pose)

% if not given pose, view local map

% figure; lines = map_global;

% hold(handle,'on'); axis(handle, 'equal');

hold on; axis equal;

if nargin == 1
    pose = [0;0;0];
end

x = pose(1);
y = pose(2);
theta = pose(3);

scatter(0,0, 10, 'k');
scatter(x, y, 50, 'r');

theta_arrow_len = 0.03;
plot([x x+theta_arrow_len*cos(theta)], [y y + theta_arrow_len*sin(theta)], 'r');

for i = 1:length(lines)
    text(lines(i).e1(1),lines(i).e1(2),num2str(i));
    plot_line_cart(lines(i).cart, [lines(i).e1(1) lines(i).e2(1)]);
end

% end