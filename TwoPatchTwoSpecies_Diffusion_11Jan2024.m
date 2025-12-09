% Two patch Two species with diffusion equations

clear all
close all


% Parameters

r1 = 0.08
r2 = 0.01

K1 = 22000
K2 = 4000

d1 = 0.02
d2 = 0.08



for i=1:100;
    N1(i) = 0.01;
    N2(i) = 0.001;
    N1new(i) = 0.0;
    N2new(i) = 0.0;
    distance(i) = i;
end

for i=1:500000
    N1left(i) = 0;
    N1right(i) = 0;
    N2left(i) = 0;
    N2right(i) = 0;
end



for t = 1:500000

    N1left(t) = 0;
    N1right(t) = 0;
    N2left(t) = 0;
    N2right(t) = 0;

    N1new(1) = N1(1) + r1*(1 - (N1(1)+N2(1))/K1)*N1(1) - d1*(N1(1)-N1(2));
    N2new(1) = N2(1) + r1*(1 - (N1(1)+N2(1))/K1)*N2(1) - d2*(N2(1)-N2(2));

    N1new(100) = N1(100) + r2*(1 - (N1(100)+N2(100))/K2)*N1(100) - d1*(N1(100)-N1(99));
    N2new(100) = N2(100) + r2*(1 - (N1(100)+N2(100))/K2)*N2(100) - d2*(N2(100)-N2(99));

    for j = 2:99
        r = r1;
        K = K1;
        if j > 50
            r = r2;
            K = K2;
        end
        N1new(j) = N1(j) + r*(1 - (N1(j)+N2(j))/K)*N1(j) - d1*(2*N1(j)-N1(j-1)-N1(j+1));
        N2new(j) = N2(j) + r*(1 - (N1(j)+N2(j))/K)*N2(j) - d2*(2*N2(j)-N2(j-1)-N2(j+1));

        
    end

    for j=1:100
        N1(j) = N1new(j);
        N2(j) = N2new(j);
    end

    re = rem(t,20000); %This says that currently figures will be made every 
    if re == 0
    t
    figure
    plot(distance,N1)

    figure
    plot(distance,N2)
    end

    time(t) = t; 

for j=1:100
        if j<= 50
        N1left(t) = N1left(t) + N1(j)/50;
        N2left(t) = N2left(t) + N2(j)/50;
        end
        if j > 50
        N1right(t) = N1right(t) + N1(j)/50;
        N2right(t) = N2right(t) + N2(j)/50;
        end
end

end

    figure
    plot(distance,N1)

    figure
    plot(distance,N2)
 
    figure
    plot(time,N1left,time,N1right,'LineWidth',2),xlabel('Time'),ylabel('Slow population')

    figure
    plot(time,N2left,time,N2right,'LineWidth',2),xlabel('Time'),ylabel('Fast population')






