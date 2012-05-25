function [state_new, P_new] = augment_landmark(state, P, polar_new, Cl_new)

% polar_new = polar_g;

r = polar_new(1);
psi = polar_new(2);

x = state(1);
y = state(2);
theta = state(3);

nlines = (length(state)-3)/2;

if is_intersect_polar_local(polar_new, state(1:3))
    polar_g = [-r + x*cos(psi+theta-pi) + y*sin(psi+theta-pi);...
        psi + theta - pi];
    Js = [cos(psi+theta-pi) sin(psi+theta-pi) -x*sin(psi+theta-pi)+ y*cos(psi+theta-pi);
        0 0 1];
    Js = [Js zeros(2,2*nlines)];
    Jnewz = [-1 -x*sin(psi+theta-pi)+y*cos(psi+theta-pi);
        0 1];
else
    polar_g = [r + x*cos(psi+theta) + y*sin(psi+theta);...
        psi + theta];
    Js = [cos(psi+theta) sin(psi+theta) -x*sin(psi+theta)+y*cos(psi+theta);
        0 0 1];
    Js = [Js zeros(2,2*nlines)];
    Jnewz = [1 -x*sin(psi+theta)+y*cos(psi+theta);
        0 1];
end

state_new = [state; polar_g];

% P_new = [P P*Js'; Js*P Js*P*Js'];

P_new = [P P*Js'; Js*P Js*P*Js'+Jnewz*Cl_new*Jnewz'];

% end