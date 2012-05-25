function delta_pose = scan_matching_line(map_l, map, odom)

map_g = lines_local2global(map_l, odom);
[I,J,~] = find_matching_lines(map_g, map);

delta_polar = [map_g(I).polar]-[map(J).polar];

q = [map(J).polar];
delta_pose = [delta_polar(1,:).*cos(q(2,:));
       delta_polar(1,:).*sin(q(2,:));
       delta_polar(2,:)];
   
delta_pose = sum(delta_pose,2)/length(I);
   
end




