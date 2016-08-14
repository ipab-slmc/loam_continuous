function [ O ] = convert_to_associatable_format( I )
%CONVERT_TO_ASSOCIATABLE_FORMAT Converts the matrix I (utime, x, y, z, qw,
%qx, qy, qz, r, p, y) to the one needed for associating the trajectories
%(utime, x, y, z, qx, qy, qz, qw)
    O = [I(:,1), I(:,2), I(:,3), I(:,4), I(:,6), I(:,7), I(:,8), I(:,5)];
end

