function output = tranMatrix2xyzrpy(T)
    xyz = T(1:3, 4);
    R = T(1:3, 1:3);
    rpy(1) = atan2(R(3,2), R(3,3));
    rpy(2) = -asin(R(3,1));
    rpy(3) = atan2(R(2,1), R(1,1));
    output = [xyz(1),xyz(2),xyz(3),rpy(1),rpy(2),rpy(3) ];
end
