clear all;

%%%MM1K%%%
fprintf("---< MM1K >---\n");
% Max #jobs the system can handle
K = 32;
% Service Time in seconds
D = 0.35;
% Arrival rate jobs/sec
l1 = 2.5;

% Service Rate
mi = 1/D;

% Traffic Intensity 1
rho1 = l1/mi;

% Utilization
U1 = (rho1-rho1^(K+1))/(1-rho1^(K+1));
fprintf("Utilization = %f\n", U1);

% Loss probability
Pl1 = (rho1^K-rho1^(K+1))/(1-rho1^(K+1));
fprintf("Loss probability = %f\n", Pl1);

% Average number of jobs in the system
N1 = (rho1)/(1-rho1)-((K+1)*rho1^(K+1)/(1-rho1^(K+1)));
fprintf("Average number of jobs in the system = %f\n", N1);

% Drop rate
Dr1 = l1 * Pl1;
fprintf("Drop Rate = %f\n", Dr1);

% Average response time
R1 = D * (1-(K+1)*rho1^K+K*rho1^(K+1))/((1-rho1)*(1-rho1^K));
fprintf("Average response time = %f\n", R1);

% Average time spent in queue (waiting for service)
Tq1 = R1-D;
fprintf("Average time spent in queue = %f\n", Tq1);

%%%MM2K%%%
fprintf("---< MM2K >---\n");
% Arrival rate jobs/sec
l2 = 250/60;

% Traffic Intensity 2
rho2 = l2/(mi*2);
% fprintf("Rho2 = %f\n", rho2);

p02 = ((2*rho2)^2/factorial(2)*(1-rho2^31)/(1-rho2) + 1 + 2*rho2)^(-1);
% fprintf("p02 = %f\n", p02);

% Utilization
U2 = pi(1,p02,rho2) + 2*pi(2,p02,rho2);
for i = 3:K
    U2 = U2 + 2 * pi(i, p02, rho2);
end
fprintf("Total utilization = %f\nAverage utilization = %f\n", U2, U2/2);

% Loss probability
Pl2 = (rho2^K-rho2^(K+1))/(1-rho2^(K+1));
fprintf("Loss probability = %f\n", Pl2);

% Average number of jobs in the system
N2 = 0;
for i = 1:K
    N2 = N2 + i * pi(i, p02, rho2);
end
fprintf("Average number of jobs in the system = %f\n", N2);

% Drop rate
Dr2 = l2 * Pl2;
fprintf("Drop Rate = %f\n", Dr2);

% Average response time (Pl2 = Pk2)
R2 = N2/(l2*(1-pi(K, p02, rho2))); 
fprintf("Average response time = %f\n", R2);

% Average time spent in the queue (waiting for service)
Tq2 = R2-D;
fprintf("Average time spent in queue = %f\n", Tq2);

function p = pi(n, p0, rho)
    if n == 0
        p = p0;
        return;
    end
    if n < 2
        p = (p0/factorial(n))*(2*rho)^n;
    else
        p = (p0*4*rho^n)/2;
    end
    
end
