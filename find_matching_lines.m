% function [I,J,lines_merge,e1_f,e2_f] = find_matching_lines(map1, map2)
function [c,e1_f,e2_f] = find_matching_lines(map1, map2)

% map1 = map;
n1 = length(map1);

% map2 = map_local_g;
n2 = length(map2);

figure; title('estimated global map'); view_linemap(map1);
figure; title('projected local map'); view_linemap(map2);
%%
Q = zeros(n1,n2);
psi_diff = zeros(n1,n2);
D = zeros(n1,n2);
e1 = cell(n1,n2);
e2 = cell(n1,n2);
% e1_idx = zeros(n1,n2);
% e2_idx = zeros(n1,n2);

lm = cell(n1,n2);

for i=1:n1
    for j=1:n2
        % for i=4:4
        %     for j = 3:3
        line1 = map1(i);
        line2 = map2(j);
        
        d1 = norm(line1.e1-line1.e2);
        d2 = norm(line2.e1-line2.e2);
                
        % [0,pi]
        
        polar1 = half_polar(line1.polar);
        polar2 = half_polar(line2.polar);
        
        psi1 = polar1(2);
        psi2 = polar2(2);
        
        psi_diff(i,j) = angle_diff_quadrant(psi1, psi2);
        
        p1m = (line1.e1+line1.e2)/2;
        p2m = (line2.e1+line2.e2)/2;
        
        ag = (d1*psi1+d2*psi2)/(d1+d2);
        
        pm = (d1*p1m+d2*p2m)/(d1+d2);
        
        a = ag-pi/2;
        lm{i,j} = [tan(a); -1; pm(2)-tan(a)*pm(1)];
        p11 = project_to_cart(line1.e1, lm{i,j});
        p12 = project_to_cart(line1.e2, lm{i,j});
        p21 = project_to_cart(line2.e1, lm{i,j});
        p22 = project_to_cart(line2.e2, lm{i,j});
        p = [p11 p12 p21 p22];
        p_orig = [line1.e1 line1.e2 line2.e1 line2.e2];
        
        D(i,j) = (norm(line1.e1-p11)+norm(line2.e1-p21)+...
            norm(line1.e2-p12)+norm(line2.e2-p22))/4;
        
        [~, idx_e2] = max(p(1,:));
        [~, idx_e1] = min(p(1,:));
        
        e1{i,j} = p_orig(:,idx_e1);
        e2{i,j} = p_orig(:,idx_e2);
        %
        %         e1_idx(i,j) = idx_e1;
        %         e2_idx(i,j) = idx_e2;
        %
        Q(i,j) = (norm(p11-p12)+norm(p21-p22))/norm(p(:,idx_e2)-p(:,idx_e1));
        
    end
end

% Pth: angle difference threshold
% Qth: overlap threshold
% Dth: disparity threshold

Pth = 0.4;
Qth = 0.5;
Dth = 0.1;

[I,J] = find(psi_diff < Pth & Q>Qth & D < Dth);
%%

if ~isempty(J)
    i = 1;
    Ju = unique(J);
    I_new = zeros(length(Ju),1);
    for j = Ju'
        a = find(J==j);
        %         [~, k] = min(psi_diff(I(a), j));
        [~, k] = min(D(I(a), j));
        I_new(i) = I(a(k));
        i = i + 1;
    end
    I = I_new;
    J = Ju;
end

e1_f = zeros(2,n2);
e2_f = zeros(2,n2);

if ~isempty(I)
    
    c = zeros(n2,1);
    c(J) = I;
    
    a = sub2ind(size(e1),I,J);
    e1_f(:,J) = [e1{a}];
    e2_f(:,J) = [e2{a}];
end

if isempty(J)
    Jnew = (1:n2)';
else
    Jnew = find(~c);
end
nNew = length(Jnew);
if nNew > 0
    e1_f(:,Jnew) = [map2(Jnew).e1];
    e2_f(:,Jnew) = [map2(Jnew).e2];
    c(Jnew) = (n1+1:n1+nNew)';
end

