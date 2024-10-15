clear all;

%%% Open Model %%%

% Lambda IN in jobs/s
l_in1 = 3;
l_in2 = 2;
l_0 = l_in1 + l_in2;

L = [l_in1/l_0, l_in2/l_0, 0, 0];

P = [ 0, 0.8, 0, 0;
      0, 0, 0.3, 0.5;
      0, 1, 0, 0;
      0, 1, 0, 0 ];

% Visits
v = L * inv(eye(4) - P);

% Service times in s
S = [ 2, 0.03, 0.1, 0.08 ];

% Demands
D = v.*S;

% Utilization
U = D .* l_0;

% Thoughput of the system
X = l_0;
fprintf("Throughput = %f\n", X);

% Average system response time
Rk = D ./ (1 - U);
Rk(1) = D(1);
R = sum(Rk);
fprintf("Average response time = %f\n", R);

% Average number of jobs in the system
N = l_0 * R;
fprintf("Average number of jobs = %f\n", N);


