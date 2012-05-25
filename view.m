function view(p, overlay, limits)

figure;
h = scatter([],[],1,'b');
hold on; scatter(0,0,5,'r');

axis equal;
if nargin == 3
    axis manual; axis(limits);
end

switch overlay
    case 0 % animate with no overlay
        for t=1:size(p,3),
            set(h,'XData',p(:,1,t));
            set(h,'YData',p(:,2,t));            
            drawnow
            title(['iteration:',num2str(t)]);
        end
    case 1 % animate with overlay
        for t=1:size(p,3),
            hold on; scatter(p(:,1,t),p(:,2,t),1);
            title(['iteration:',num2str(t)]);
            pause(0.01);
        end
    case 2 % display at once
        xall = p(:,1,:);
        yall = p(:,2,:);
        scatter(xall(:),yall(:),1);
end


end