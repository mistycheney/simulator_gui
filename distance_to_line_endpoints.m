function d = distance_to_line_endpoints(p, end1, end2)

d = abs(cross(end2-end1, end1-p))/abs(end2-end1);

end