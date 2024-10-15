clear all;

scenario = 1;
%scenario = 2;

fprintf("Analyzing Scenario %d\n", scenario);

K0 = 100;
K = K0;
deltaK = 50;
maxK = 10000;

M = 1000;

gamma = 0.95;
d_gamma = 1.96;

alpha = 0.04;

iters = K;
A = 0;
C = 0;
sumU = 0;
sumU2 = 0;
sumX = 0;
sumX2 = 0;
sumN = 0;
sumN2 = 0;
sumR = 0;
sumR2 = 0;
sumV = 0;
sumV2 = 0;
while K < maxK
    for i = 1:iters
        if scenario == 1
            arrivals = hyperExpGen(M);
            service = erlangGen(M);
        else
            arrivals = expGen(M);
            service = uniformGen(M);
        end
        A0 = A;
        Rd = zeros(M,1);
        for j = 1:M
            C = max(A, C) + service(j);
			ri = C - A;
			Rd(j,1) = ri;
			A = A + arrivals(j);
        end
        Bi = sum(service);
        Wi = sum(Rd);

		Ti = C - A0;

		Ui = Bi / Ti;
		sumU = sumU + Ui;
		sumU2 = sumU2 + Ui^2;
        
        %Xi = C / Ti; QUALE E CORRETTA? in teoria quella sotto
        Xi = M / Ti;
        sumX = sumX + Xi;
        sumX2 = sumX2 + Xi^2;

        Ni = Wi / Ti;
        sumN = sumN + Ni;
        sumN2 = sumN2 + Ni^2;

        Ri = Wi / M;
		sumR = sumR + Ri;
		sumR2 = sumR2 + Ri^2;
        
        Vi = var(Rd);
        sumV = sumV + Vi;
        sumV2 = sumV2 + Vi^2;
    end
    
	Um = sumU / K;
	Us = sqrt((sumU2 - sumU^2/K)/(K-1));
	CiU = [Um - d_gamma * Us / sqrt(K), Um + d_gamma * Us / sqrt(K)];
	errU = 2 * d_gamma * Us / sqrt(K) / Um;
    
    Xm = sumX / K;
    Xs = sqrt((sumX2 - sumX^2/K)/(K-1));
    CiX = [Xm - d_gamma * Xs / sqrt(K), Xm + d_gamma * Xs / sqrt(K)];
	errX = 2 * d_gamma * Xs / sqrt(K) / Xm;

    Nm = sumN / K;
    Ns = sqrt((sumN2 - sumN^2/K)/(K-1));
    CiN = [Nm - d_gamma * Ns / sqrt(K), Nm + d_gamma * Ns / sqrt(K)];
	errN = 2 * d_gamma * Ns / sqrt(K) / Nm;
    
    Rm = sumR / K;
	Rs = sqrt((sumR2 - sumR^2/K)/(K-1));
	CiR = [Rm - d_gamma * Rs / sqrt(K), Rm + d_gamma * Rs / sqrt(K)];
	errR = 2 * d_gamma * Rs / sqrt(K) / Rm;

    Vm = sumV / K;
    Vs = sqrt((sumV2 - sumV^2/K)/(K-1));
    CiV = [Vm - d_gamma * Vs / sqrt(K), Vm + d_gamma * Vs / sqrt(K)];
    errV = 2 * d_gamma * Vs / sqrt(K) / Vm;

	if errU < alpha && errX < alpha && errN < alpha && errR < alpha && errV < alpha
		break;
	else
		K = K + deltaK;
		iters = deltaK;
	end
end

fprintf("Utilization in [%g, %g], with %g confidence. Relative Error: %g\n", CiU(1,1), CiU(1,2), gamma, errU);
fprintf("Throughput in [%g, %g], with %g confidence. Relative Error: %g\n", CiX(1,1), CiX(1,2), gamma, errX);
fprintf("Average number of jobs in [%g, %g], with %g confidence. Relative Error: %g\n", CiN(1,1), CiN(1,2), gamma, errN);
fprintf("Response Time in [%g, %g], with %g confidence. Relative Error: %g\n", CiR(1,1), CiR(1,2), gamma, errR);
fprintf("Response Time Variance in [%g, %g], with %g confidence. Relative Error: %g\n", CiV(1,1), CiV(1,2), gamma, errV);

% Utilization
fprintf("Utilization Time = %f\n", Um);

% Throughput
fprintf("Throughput = %f\n", Xm);

% Average number of jobs in the system
fprintf("Average number of jobs in the system = %f\n", Nm);

% Average response time
fprintf("Average Response Time = %f\n", Rm);

% Variance of the response time
fprintf("Variance of Response Time = %f\n", Vm);

% Number of batches K required to reach the required accuracy
if errR < alpha && errX < alpha && errN < alpha && errU < alpha && errV < alpha
	fprintf("Maximum Relative Error reached in %d Iterations\n", K);
else
	fprintf("Maximum Relative Error NOT REACHED in %d Iterations\n", K);
end	

%%% Generation functions %%%
%%% Scenario 1 %%%
% Arrival rate with 2 stages hyper-exponential distribution
function F = hyperExpGen(n)
    l1 = 0.02;
    l2 = 0.2;
    p = 0.1;
    hyper = zeros(n, 1);
    for i = 1:n
        if rand() <= p
            hyper(i) = -log(rand())/l1;
        else
            hyper(i) = -log(rand())/l2;
        end
    end
    F = hyper;
end

% Service rate with erlang
function F = erlangGen(n)
    k = 10;
    l = 1.5;
    erlang = zeros(n, 1);
    for i = 1:n
        erlang(i) = -log(prod(rand(k,1)))/l;
    end
    F = erlang;
end

%%% Scenario 2 %%%
% Arrival rate with exponential
function F = expGen(n)
    l = 0.1;
    exponential = -log(rand(n,1))./l;
    F = exponential;
end

% Service rate with uniform
function F = uniformGen(n)
    a = 5;
    b = 10;
    uniform = rand(n,1)*a + (b-a);
    F = uniform;
end