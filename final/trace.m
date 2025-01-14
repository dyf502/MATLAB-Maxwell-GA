clc; clear;

% MagneticField([0 0 0;0 0 1;0 0 2] , [1 2;1 2;1 2])
%% 微分线段
a = [];
d = 10;
ys = 20;
n = 13;

n1 = 52;
n2 = 3;
n3 = 3;

zstandard = 21;

PointLocation = 1;

for points = 1:4*n-1

    if points == 1
        x = 540;
        y = ys / 2;
        z = 0;
        condition = 1;
    end

    if points == 2 % x卤浠?0
        x = 0;
        y = y;
        z = 0;
        condition = 2;                
    end

    if mod(points + 2, 4) == 1 && points > 2
        x = 0;
        y = y;
        z = zstandard;
        condition = 1;
    elseif mod(points + 2, 4) == 2 && points > 2
        x = 540;
        y = y; 
        z = zstandard;
        condition = 3;
    elseif mod(points + 2, 4) == 3 && points > 2
        x = 540;
        y = y + d + ys;
        z = 0;
        condition = 1;
    elseif mod(points + 2, 4) == 0 && points > 2
        x = 0;
        y = y;
        z = 0;
        condition = 2;
    end

    if condition == 1 % x变
        initalp = 0;

        for nn = PointLocation:PointLocation + n1 + 1

            if nn == PointLocation + n1 + 1

                if x == 0
                    a(1, nn) = 540;
                    a(2, nn) = y;
                    a(3, nn) = z;
                else
                    a(1, nn) = 0;
                    a(2, nn) = y;
                    a(3, nn) = z;
                end

                break
            end

            if x == 0
                a(1, nn) = 540 / (n1 + 1) * initalp;
                initalp = initalp + 1;
                a(2, nn) = y;
                a(3, nn) = z;
            else
                a(1, nn) = 540 - 540 / (n1 + 1) * initalp;
                initalp = initalp + 1;
                a(2, nn) = y;
                a(3, nn) = z;
            end

        end

        PointLocation = PointLocation + n1 + 1;
    end

    if condition == 2 % z变
        initalp = 0;

        for nn = PointLocation:PointLocation + n2 + 1

            if nn == PointLocation + n2 + 1

                if z == 0
                    a(1, nn) = x;
                    a(2, nn) = y;
                    a(3, nn) = zstandard;
                else
                    a(1, nn) = x;
                    a(2, nn) = y;
                    a(3, nn) = 0;
                end

                break
            end

            if z == 0
                a(1, nn) = x;
                a(2, nn) = y;
                a(3, nn) = zstandard / (n2 + 1) * initalp;
                initalp = initalp + 1;
            else
                a(1, nn) = x;
                a(2, nn) = y;
                a(3, nn) = zstandard - zstandard / (n2 + 1) * initalp;
                initalp = initalp + 1;
            end

        end
    PointLocation = PointLocation + n2 + 1;
    end
	
	if condition == 3
		initalp = 0;
		
		for nn = PointLocation:PointLocation + n3 + 1
			if nn == PointLocation + n3 + 1
				a(1,nn) = x;
				a(2,nn) = y + d + ys;
				a(3,nn) = 0;
				break
			end
			
			a(1,nn) = x;
			a(2,nn) = y + (d+ys)/(n3+1) * initalp;
			a(3,nn) = zstandard - zstandard / (n3 + 1) * initalp;
			initalp = initalp + 1;
		
		end
	PointLocation = PointLocation + n3 + 1;
	end
  
end

z_high = 316;
for points = 1:4*n-1

    if points == 1
        x = 540;
        y = y;
        z = z_high;
        condition = 1;
    end

    if points == 2 % x卤浠?0
        x = 0;
        y = y;
        z = z_high;
        condition = 2;                
    end

    if mod(points + 2, 4) == 1 && points > 2
        x = 0;
        y = y;
        z = z_high + zstandard;
        condition = 1;
    elseif mod(points + 2, 4) == 2 && points > 2
        x = 540;
        y = y; 
        z = z_high + zstandard;
        condition = 3;
    elseif mod(points + 2, 4) == 3 && points > 2
        x = 540;
        y = y - d - ys;
        z = z_high;
        condition = 1;
    elseif mod(points + 2, 4) == 0 && points > 2
        x = 0;
        y = y;
        z = z_high;
        condition = 2;
    end

    if condition == 1 % x变
        initalp = 0;

        for nn = PointLocation:PointLocation + n1 + 1

            if nn == PointLocation + n1 + 1

                if x == 0
                    a(1, nn) = 540;
                    a(2, nn) = y;
                    a(3, nn) = z;
                else
                    a(1, nn) = 0;
                    a(2, nn) = y;
                    a(3, nn) = z;
                end

                break
            end

            if x == 0
                a(1, nn) = 540 / (n1 + 1) * initalp;
                initalp = initalp + 1;
                a(2, nn) = y;
                a(3, nn) = z;
            else
                a(1, nn) = 540 - 540 / (n1 + 1) * initalp;
                initalp = initalp + 1;
                a(2, nn) = y;
                a(3, nn) = z;
            end

        end

        PointLocation = PointLocation + n1 + 1;
    end

    if condition == 2 % z变
        initalp = 0;

        for nn = PointLocation:PointLocation + n2 + 1

            if nn == PointLocation + n2 + 1

                if z == z_high
                    a(1, nn) = x;
                    a(2, nn) = y;
                    a(3, nn) = z_high + zstandard;
                else
                    a(1, nn) = x;
                    a(2, nn) = y;
                    a(3, nn) = z_high;
                end

                break
            end

            if z == z_high
                a(1, nn) = x;
                a(2, nn) = y;
                a(3, nn) = z_high + zstandard / (n2 + 1) * initalp;
                initalp = initalp + 1;
            else
                a(1, nn) = x;
                a(2, nn) = y;
                a(3, nn) = z_high + zstandard - zstandard / (n2 + 1) * initalp;
                initalp = initalp + 1;
            end

        end
    PointLocation = PointLocation + n2 + 1;
    end
	
	if condition == 3
		initalp = 0;
		
		for nn = PointLocation:PointLocation + n3 + 1
			if nn == PointLocation + n3 + 1
				a(1,nn) = x;
				a(2,nn) = y - d - ys;
				a(3,nn) = z_high;
				break
			end
			
			a(1,nn) = x;
			a(2,nn) = y - (d+ys)/(n3+1) * initalp;
			a(3,nn) = z_high + zstandard - zstandard / (n3 + 1) * initalp;
			initalp = initalp + 1;
		
		end
	PointLocation = PointLocation + n3 + 1;
	end
  
end
%% 取观测点
%O.= [270;195;169]
mun = 180 * 19 + 2;
star_1 = 0;
star_2 = 0;
z_o = 169;
location = zeros(3,mun);
for h = -90:10:90
    location(3,star_1+1:star_1+180) = z_o + h;
    r = ((100)^2 - (abs(h))^2)^(1/2);
    for i = 0 : 1 : 179
        star_2 = star_2+1;
        location(1,star_2) = 270+r*cosd(i*2);
        location(2,star_2) = 195+r*sind(i*2);
    end
    star_1 = star_1 + 180;
end
location(1,mun-1) = 270;
location(2,mun-1) = 195;
location(3,mun-1) = 169;
location(1,mun) = 270;  
location(2,mun) = 195;  
location(3,mun) = 69;



%% 取不均匀度
e = 1;
MagData = MagneticField(a , location);
data_need(e,1) = max(max(MagData(2,:)));
data_need(e,2) = min(min(MagData(2,:)));
Nonun = (data_need(e, 1) - data_need(e, 2)) / ((data_need(e, 1) + data_need(e, 2)) / 2);