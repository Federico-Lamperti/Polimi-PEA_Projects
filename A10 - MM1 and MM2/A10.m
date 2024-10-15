clear all;

%%% MM1 %%%
% Poisson process arrival rate [job/s]
lambda = 40;
% Avg Service time, (ms -> seconds)
D = 0.016;

fprintf("---< MM1 >---\n");

% Utilization
U = lambda*D;  % Equal to traffic intensity
fprintf("Utilization = %f\n", U);

% Service Rate
mi = 1/D;

% Probability of having exactly one job in the system
fprintf("P(#J=1) = %f\n", U-U^2);

% Probability of having less than 10 jobs in the system 
ptemp = (1-U)*U^10 + U^11;
fprintf("P(#J<10) = %f\n", 1-ptemp);

% Average queue length (jobs not in service)
fprintf("Average queue length = %f\n", (U^2)/(1-U));

% Average response time
R = D/(1-U);
fprintf("Average response time = %f\n", R);

% Probability that the response time is greater than 0.5 s.
fprintf("P(R>0.5) = %f\n", exp(-(0.5/R)));

% 90 percentile of the response time distribution
fprintf("90 percentile of the response time: %f\n", -log(1-0.9)*R);

%%% MM2 %%%
l2 = 90;

fprintf("---< MM2 >---\n");

% Total Utilization
U2 = l2 * D;
fprintf("Total Utilization = %f\n", U2);

% Average Utilization
Um = U2/2;
fprintf("Average Utilization = %f\n", Um);   % Equal to traffic intensity 2

p0 = (1-Um)/(1+Um);
% Probability of having exactly one job in the system
p1 = 2*p0*Um;
fprintf("P(#J=1) = %f\n", p1);

% Probability of having less than 10 jobs in the system
ptot = p0;
for i = 1:9
    ptot = ptot + 2*p0*Um^i;
end
fprintf("P(#J<10) = %f\n", ptot);

% Average queue length (jobs not in service)
QL = 2*Um/(1-Um^2) - U2;
fprintf("Average queue length = %f\n", QL);

% Average response time
R2 = D/(1-Um^2);
fprintf("Average response time = %f\n", R2);
