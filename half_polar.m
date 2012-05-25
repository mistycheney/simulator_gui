function [ polar ] = half_polar( polar )

r = polar(1);
a = polar(2);

if a>=-pi/2 && a<=pi/2
    return
else
    c = cos(a);
    s = sin(a);
    if c>0
        a = asin(s);
    else
        a = -asin(s);
        r = -r;
    end
end

polar = [r a];

end

