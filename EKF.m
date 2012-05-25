function [state, P] = EKF(state, P, u, z, Cls, c,R)

% u = delta_pose';

nstate = length(state);
nz = length(z)/2;
nmap = (length(state)-3)/2;

state = state + [u; zeros(2*nmap,1)];

G = eye(nstate) + [eye(3) zeros(3,2*nmap);
                zeros(2*nmap,3) zeros(2*nmap,2*nmap)];

P = G*P*G' + [R zeros(3,2*nmap);
            zeros(2*nmap,3) zeros(2*nmap,2*nmap)];

for j=1:nz
    i = c(j);
    if i <= nmap % found match
        Q = Cls{j}; % measurement noise
        
%         F = sparse([1,2,3,4,5],[1,2,3,2*i+2:2*i+3],ones(5,1),5,nstate);
            
        [hi,Hii] = hH(state([1 2 3 2*i+2:2*i+3]));
%         [h,H] = hH(state);
        
%         Hi = Hii*F;
        
        n_newmap = (length(state)-3)/2;
        Hi = [Hii(:,1:3) zeros(2,2*(i-1)) Hii(:,4:5) zeros(2,2*(n_newmap-i))];
        
        S = Hi*P*Hi' + Q;
        K = P*Hi'/S;
        
%         hi = h(2*i-1:2*i);
        zj = standard_polar(z(2*j-1:2*j));
        his = standard_polar(hi);
        delta = K*(zj-his);
        state = state + delta;
        P = P - K*Hi*P;
        
    else % new landmark
        [state,P] = augment_landmark(state, P, z(2*j-1:2*j), Cls{j});
    end
end



% end