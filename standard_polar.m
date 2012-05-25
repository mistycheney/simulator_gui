function q = standard_polar(polar)

r = polar(1);
a = polar(2);

if r<0
    r = -r;
    a = a+pi;
end

c = cos(a);
s = sin(a);

if c>0
    a = asin(s);
else
    if s>0
        a = pi - asin(s);
    else
        a = -pi - asin(s);
    end
end

assert(r>=0,'r negative. rho:%f, a:%f', r, a);
assert(a>=-pi && a<=pi, 'psi out of range. rho:%f, a:%f', r, a);

q = [r; a];