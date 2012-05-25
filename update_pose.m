function [pose_noisy] = update_pose(velocity, current_pose)

x = current_pose(1);
y = current_pose(2);
theta = current_pose(3);

vx = velocity(1);
vy = velocity(2);
vw = velocity(3);

v = norm([vx vy]);
theta_v = roundangle(theta + atan2(vy, vx));
if vw==0
    x2 = x + v*cos(theta_v);
    y2 = y + v*sin(theta_v);
    theta2 = theta;
else
    r = v/abs(vw);
    x2 = x - r*sin(theta_v) + r*sin(theta_v + vw);
    y2 = y + r*cos(theta_v) - r*cos(theta_v + vw);
    theta2 = roundangle(theta + vw);
end

pose = [x2 y2 theta2];

pose_noisy = pose + 0.01*rand(3,1);

end