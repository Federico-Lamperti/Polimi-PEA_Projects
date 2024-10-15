clear all;

%%%MG1%%%
fprintf("---< MG1 >---\n");

% Poisson jobs/s
l_p = 10;

% Hyper-Exponential duration jobs/s
l1_hyper = 50;
l2_hyper = 5;
p_hyper = 0.8;

D = p_hyper/l1_hyper + (1-p_hyper)/l2_hyper;

secm = 2*(p_hyper/l1_hyper^2 + (1-p_hyper)/l2_hyper^2);

rho = l_p * D;

% Utilization
U1 = rho;
fprintf("Utilization = %f\n", U1);

% Exact average response time
R1 = D + (l_p*secm)/(2*(1-rho));
fprintf("Average response time = %f\n", R1);

% Exact average number of jobs in the system
N1 = R1 * l_p;
fprintf("Average number of jobs = %f\n", N1);

%%%GG3%%%
fprintf("---< GG3 >---\n");

k_erlang = 5;
l_erlang = 240;

varA = k_erlang/l_erlang^2;
mean_erlang = k_erlang/l_erlang;
ca = sqrt(varA)/mean_erlang;

varV = secm - D^2;
cv = sqrt(varV)/D;

l_3 = 1/mean_erlang;

rho3 = l_3 * D;
rhom = rho3/3;

% Utilization
U3 = rho3;
fprintf("Total utilization = %f\n", U3);
fprintf("Average Utilization = %f\n", U3/3);

% Approximate average response time
theta = (D/(3*(1-rhom))) / (1 + (1-rhom)*(6/(3*rhom)^3) * (1+3*rhom+(3*rhom)^2/2));
R3 = D + (ca^2 + cv^2)/2 * theta;
fprintf("Average response time = %f\n", R3);

% Approximate average number of jobs in the system
N3 = R3 * l_3;
fprintf("Average number of jobs = %f\n", N3);

