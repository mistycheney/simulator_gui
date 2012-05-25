function [Line_merge, L_merge] = extract_line(P, Q)

cluster_distance_thresh = 0.02;
% N: max segment length before merging
N = 20;
split_deviation_thresh = 0.05;
r_merge_thresh = 0.04;
a_merge_thresh = 0.4;

P = remove_zeros(P);

figure; hold on; axis equal;
scatter(P(1,:), P(2,:), 5);

%% cluster
np = size(P,2);

D = P(:,2:end) - P(:,1:end-1);
adjacent_distance = sqrt(D(1,:).^2 + D(2,:).^2);
jump = find(adjacent_distance > cluster_distance_thresh);

size_cluster = [jump np] - [0 jump];
cluster = mat2cell(P, 2, size_cluster);
ncluster = length(cluster);

color = 'rgby';

figure; title('cluster'); hold on; axis equal;
for i = 1:length(cluster)
    scatter(cluster{i}(1,:), cluster{i}(2,:), 5 , color(mod(i,4)+1));
    text(cluster{i}(1,1),cluster{i}(2,1)',num2str(i));
end


%% split

L_split = {};
Line_split = build_line();

for c = 1:ncluster
    
    np = size(cluster{c},2);
    
    nL = floor(np/N);
    n1 = np-nL*N;
    
    L = mat2cell(cluster{c}, 2, [ones(1,nL)*N n1]);
    
    i = 1;
    
    Line = build_line();
    
    while i <= length(L)
        
        nx = size(L{i},2);
        
        if nx <= 1
            Line(i) = build_line(0);
            i = i+1;
            continue;
        end
        
        [line, max_d, max_p] = extract_one_line_garulli(L{i}, Q);
        
        if max_d < split_deviation_thresh || nx == 2
            Line(i) = line;
            i = i+1;
        else
            if max_p == nx || max_p == nx-1
                L = {L{1:i-1} L{i}(:,1:nx-2) L{i}(:,nx-1:end) L{i+1:end}};
            elseif max_p == 1
                L = {L{1:i-1} L{i}(:,1:2) L{i}(:,3:end) L{i+1:end}};
            else
                L = {L{1:i-1} L{i}(:,1:max_p) L{i}(:,max_p+1:end) L{i+1:end}};
            end
            L = L(~cellfun('isempty',L));
        end
        %         L
        %     pause;
    end
    
    L_split = [L_split L];
    Line_split = [Line_split Line];
    
end


figure; title('split'); hold on; axis equal;

try
    for i = 1:length(L_split)
        scatter(L_split{i}(1,:), L_split{i}(2,:), 5, color(mod(i,4)+1));
        plot_line(Line_split(i));
        text(L_split{i}(1,1),L_split{i}(2,1)',num2str(i));
    end
catch err
    i, L_split
end

%%
valid = find(cellfun('length',L_split) > 5);
L_split = L_split(valid);
Line_split = Line_split(valid);


figure; title('split, remove small group'); hold on; axis equal;
for i = 1:length(L_split)
    scatter(L_split{i}(1,:), L_split{i}(2,:), 5, color(mod(i,4)+1));
    plot_line(Line_split(i));
    text(L_split{i}(1,1),L_split{i}(2,1)',num2str(i));
end


%% merge

modified = 1;

while modified
    modified = 0;
    
    ncluster = length(L_split);
    
    j = 1;
    L_merge = L_split(1);
    Line_merge = build_line();
    group = 0;
    
    for i=1:ncluster
        Li_polar = standard_polar(Line_split(i).polar);
        if i < ncluster
            Lj_polar = standard_polar(Line_split(i+1).polar);
        end
        if i < ncluster && ...
                abs(Li_polar(1)-Lj_polar(1)) < r_merge_thresh &&...
                angle_diff_quadrant(Li_polar(2), Lj_polar(2)) < a_merge_thresh
            L_merge{j} = [L_merge{j} L_split{i+1}];
            modified = 1;
            group = 1;
        else
            if group
                [Line_merge(j) ~,~] = extract_one_line_garulli(L_merge{j}, Q);
            else
                Line_merge(j) = Line_split(i);
            end
            group = 0;
            j = j + 1;
            if i < ncluster
                L_merge{j} = L_split{i+1};
            end
        end
    end
    
    L_split = L_merge;
    Line_split = Line_merge;
    %     pause;
end
L_merge = L_split;
Line_merge = Line_split;

%%
figure; title('merge'); hold on; axis equal;
for i = 1:length(L_merge)
    scatter(L_merge{i}(1,:), L_merge{i}(2,:), 5, color(mod(i,4)+1));
    plot_line(Line_merge(i));
    text(L_merge{i}(1,1),L_merge{i}(2,1)',num2str(i));
end


% end
