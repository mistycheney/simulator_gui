function a = round_angle_pi_pi(a)

if a > pi
    a = a-2*pi;
elseif a < -pi
    a = a+2*pi;
end

end
