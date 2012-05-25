% function [Line_merge, L_merge] = extract_line(P, Q)
% load frame
P = cloud_local';

N = 20;
np = size(P,1);
n = floor(np/N);
remainder = rem(np,N);

color = 'rgkm';

view(P,0);

coeff = zeros(2,n+1);

for i=1:n+1
    if i==n+1
        pp = P((i-1)*N+1:end,:);
    else
        pp = P((i-1)*N+1:i*N,:);
    end
    [coeffi, score, latent] = princomp(pp);
    coeff(:,i) = coeffi(:,1);
    
    k = coeffi(2,1)/coeffi(1,1);
    xmean = mean(pp(:,1));
    ymean = mean(pp(:,2));
    c = ymean - k*xmean;
    e1 = pp(1,:)';
    e2 = pp(end,:)';
    
    p1 = project_to_cart(e1,[k -1 c]);
    p2 = project_to_cart(e2,[k -1 c]);
    x1 = p1(1);
    x2 = p2(1);
    
    plot([x1, x2], k*[x1 x2]+c, 'k');
    pause;
    ratio(i) = latent(1)/sum(latent);
%     i, ratio(i)
%     if ratio(i) < 0.9
        hold on; scatter(pp(:,1), pp(:,2), 1, color(mod(i,4)+1));
        text(pp(1,1), pp(1,2), num2str(i));
%     end
end






% end
