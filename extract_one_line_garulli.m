function [line, max_d, max_p] = extract_one_line_garulli(p, Q)

% p = [p1, p2];

% p = [0 2; -1 0];

x = p(1,:)';
y = p(2,:)';

[theta, rho] = cart2pol(x,y);

n = length(x);

x_bar = mean(x);
y_bar = mean(y);
Sxy = sum((x-x_bar).*(y-y_bar));
Sx2 = sum((x-x_bar).^2);
Sy2 = sum((y-y_bar).^2);

alpha_star = 1/2*atan2(-2*Sxy,(Sy2-Sx2));
rho_star = x_bar*cos(alpha_star)+y_bar*sin(alpha_star);

Cl = 0;

for i = 1:n
    c = ((y_bar-y(i))*(Sy2-Sx2)+2*Sxy*(x_bar-x(i)))/((Sy2-Sx2)^2+4*Sxy^2);
    d = ((x_bar-x(i))*(Sy2-Sx2)-2*Sxy*(y_bar-y(i)))/((Sy2-Sx2)^2+4*Sxy^2);
    
    a = cos(alpha_star)/n-x_bar*sin(alpha_star)*c+y_bar*cos(alpha_star)*c;
    b = sin(alpha_star)/n-x_bar*sin(alpha_star)*d+y_bar*cos(alpha_star)*d;
    
    Ai = [a b; c d];
    Bi = [cos(theta(i)) -rho(i)*sin(theta(i)); sin(theta(i)) rho(i)*cos(theta(i))];
    Ji = Ai*Bi;

%     sigma_rho = 0;
%     sigma_rho_theta = 0;
%     sigma_theta = 0;
    
%     var_rho = 0.01;
%     var_rho_theta = 0;
%     var_theta = 0;
    
    Cmi = Q;
    
%     Cmi = [var_rho^2 var_rho_theta; var_rho_theta var_theta^2];
    Cl = Cl + Ji*Cmi*Ji';
end

% if rho_star < 0
%     rho_star = -rho_star;
%     if alpha_star > 0
%         alpha_star = alpha_star - pi;
%     else
%         alpha_star = alpha_star + pi;
%     end
% end
% 
% assert(rho_star >= 0);
% assert(alpha_star >= -pi && alpha_star <= pi);

polar = [rho_star; alpha_star];
cart = line_polar2cart(polar);
end1 = project_to_cart(p(:,1), cart);
end2 = project_to_cart(p(:,end), cart);

a = cart(1);
b = cart(2);
c = cart(3);
[max_d, max_p] = max(abs(a*x+b*y+c)/norm([a,b]));

line = struct('polar',polar,'cart',cart,'e1',end1,'e2',end2,'Cl',Cl);

% end