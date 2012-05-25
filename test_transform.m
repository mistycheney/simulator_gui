close all;

r_l = 5*rand(1);
psi_l = -pi + 2*pi*rand(1);

line_l = build_line([r_l; psi_l],[-5 5]);
figure; title('local'); hold on; axis equal; 
view_linemap(line_l);

x = -5 + 10*rand(1);
y = -5 + 10*rand(1);
theta = -pi + 2*pi*rand(1);
pose = [x; y; theta];

line_g = lines_local2global(line_l, pose);

figure; title('global'); hold on; axis equal; 
view_linemap(line_g, pose);

figure; title('local recon.'); hold on; axis equal; 
view_linemap(lines_global2local(line_g, pose))

