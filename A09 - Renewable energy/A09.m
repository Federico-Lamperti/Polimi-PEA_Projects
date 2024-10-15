clear all;

% Average durations in hours
Night = 1/12;
Cloud = 1/3;
Sun = 1/6;

% Starting probabilities
NightP = 0.5;
SunP = 0.3333;
CloudP = 0.1667;

% Mean Duty Cicle in hours
Scan = 1/(2/60);
NSleep = 1/(18/60);
SunSleep = 1/(3/60);
CloudSleep = 1/(8/60);

% Average consumptions in Watts
Psleep = 0.1;
Pon = 12;

% Infinitesimal generator Matrix
Q = [ -Scan, Scan, 0, 0, 0, 0;
      NSleep, -(2*Night+NSleep), 0, Night, 0, Night;
      0, 0, -Scan, Scan, 0, 0;
      0, Sun, SunSleep, -(2*Sun+SunSleep), 0, Sun;
      0, 0, 0, 0, -Scan, Scan;
      0, Cloud, 0, Cloud, CloudSleep, -(2*Cloud+CloudSleep);
    ];

p0 = [0, NightP, 0, SunP, 0, CloudP];

[t, Sol] = ode45(@(t,x) Q'*x, [0 24], p0');
figure
plot(t, Sol, 'LineWidth', 1.5);
xlabel("Time");
ylabel("Probability");
legend("NightScan", "Night", "SunScan", "Sun", "CloudScan", "Cloud");

%%% Results %%%
% Infinitesimal generator Matrix
% disp(Q);

% Reward vector for the average power consumption and for the utilization
alphaU = [1, 0, 1, 0, 1, 0];
alphaEnergy = [Pon, Psleep, Pon, Psleep, Pon, Psleep];

% Reward matrix of the throughput
epsilonX = [0,1,0,0,0,0;
            0,0,0,0,0,0;
            0,0,0,1,0,0;
            0,0,0,0,0,0;
            0,0,0,0,0,1;
            0,0,0,0,0,0;
            ];

% Average device consumption
Energy = Sol(end, :) * alphaEnergy';
fprintf("Average energy consumption = %f\n", Energy);

% Average utilization (Time where the system is scanning)
U = Sol(end, :) * alphaU';
fprintf("Utilization = %f\n", U);

% Throughput (#scans per day)
X = 0;
for i=1:length(Sol(end,:))
    multiplier = 0;
    for j=1:length(epsilonX(:,end))
        if j ~= i
            multiplier = multiplier + Q(i,j)*epsilonX(i,j);
        end
    end
    if multiplier ~= 0
        X = X + Sol(end,i)*multiplier;
    end
end
X = X * 24;
fprintf("Throughput: %f\n", X);

