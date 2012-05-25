clc; clear; close all;

params.fov = 240;
params.max_range = 10;
params.np = 680;
% params.nt = 200;

data = load('map.mat','map');
true_map = data.map;
% true_lines = extract_line(true_map);

data = load('true_lines.mat');
true_lines = data.true_lines;

true_pose = [0.4;0.5;-1];
pose = true_pose;
% velocity = [0.05; 0.05; 0.1];
velocity = [0; 0; 0.3];

map = build_line();
P = zeros(3);

T = 1;
%%


for t=1:T
    
    var_rho = 0.00001;
    var_rho_theta = 0;
    var_theta = 0;
    Q = [var_rho var_rho_theta;
        var_rho_theta var_theta];
    
    d = generate_sensor(params, true_pose, true_lines, Q);
    cloud_local = rad2cart_robot_centric(d, params.fov)';
    cloud_local = remove_zeros(cloud_local);
    
    
    [map_local, L_merge] = extract_line(cloud_local, Q);
    
    %     map_global = lines_local2global(map_local, pose);
    %
    %     figure; view_linemap(map_global, pose);
    
    %     odometry = scan_matching(map_local, map);
    %     odometry = scan_matching(cloud_local, map);
    %     odometry = scan_matching_point(cloud_local, map);
    %     delta_pose = scan_matching_line(map_local, map, pose);
    delta_pose = velocity;
    
    % motion noise
    var_x = 0.0001;
    var_y = 0.0001;
    var_theta = 0.0001;
    
    R = [var_x 0 0;
        0 var_y 0;
        0 0 var_theta];
    
%     R = zeros(3);
    
    [pose, map, P] = go_EKF(delta_pose, pose, map, P, map_local, R);
    
    %     odom = update_pose(velocity, pose_est);
    
    noisy_velocity = velocity + sqrt(R)*randn(3,1);
    
    true_pose = true_pose + noisy_velocity;
    figure; title('estimated global map'); view_linemap(map, pose);
    
end


