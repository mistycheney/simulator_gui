% model = p(:,:,50)';
% data = p(:,:,1)';

function odom = scan_matching_point(model, data)

% data = remove_zeros(data);
% model = remove_zeros(model);

% x_model = randn(1,100);
% model = [x_model; x_model+0.001*randn(1,100)]';
% data = [x_model; 1-x_model]';

[R, T] = icp_per(model, data);
odom = [inv(R) -T];

% newdata = R*data+ repmat(T,1,size(data,2));

% figure; hold on; axis equal;
% scatter(model(1,:), model(2,:), 5)
% scatter(data(1,:), data(2,:), 5)
% scatter(newdata(1,:), newdata(2,:), 5)
% legend('model','data','newdata');

end