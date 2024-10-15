clear all;

x = [0:25];

%%% Linear Congruent Generator - Uniform Distribution %%%
NU = 10000;
m_uniform = 2^32;
a_uniform = 1664525;
c_uniform = 1013904223;
seed_uniform = 521191478;
uniform = zeros(NU, 1);
uniform(1) = seed_uniform;
for i = 2:NU
    uniform(i) = mod(a_uniform*uniform(i-1) + c_uniform, m_uniform);
end
uniform = uniform ./ m_uniform; 
fprintf("First sample = %f\nSecond sample = %f\nThird sample = %f\n", uniform(1), uniform(2), uniform(3));

%%% Generate with samples obtained above %%%
% Exponential Distribution
l_exp = 0.1;
N_exp = 10000;
exponential = -log(uniform)./l_exp;
% Cost calculation
exp_cost = 0;
for i = 1:N_exp
    if exponential(i) < 10.0
        exp_cost = exp_cost + 0.01*exponential(i);
    else
        exp_cost = exp_cost + 0.02*exponential(i);
    end
end
fprintf("Exp --> cost = %f\n", exp_cost);
figure
plot(sort(exponential), [1:N_exp]/N_exp, x, 1-exp(-l_exp*x), 'LineWidth', 1.5);
title("Exponential");
xlabel("Value");
ylabel("CDF");
legend("Generated", "Real Formula");

% Pareto distribution with parameters a = 1.5, m = 5
N_pareto = 10000;
alpha = 1.5;
m = 5;
pareto = m ./ (uniform.^(1/alpha));
% CDF creation
pareto_cdf = (m./x).^alpha;
for i = 1:26
    pareto_cdf(i) = 1 - min(pareto_cdf(i), 1);
end
% Cost calculation
pareto_cost = 0;
for i = 1:N_pareto
    if pareto(i) < 10.0
        pareto_cost = pareto_cost + 0.01*pareto(i);
    else
        pareto_cost = pareto_cost + 0.02*pareto(i);
    end
end
fprintf("Pareto --> cost = %f\n", pareto_cost);
figure
plot(sort(pareto), [1:N_pareto]/N_pareto, x, pareto_cdf, 'LineWidth', 1.5);
title("Pareto");
xlabel("Value");
ylabel("CDF");
legend("Generated", "Real Formula");

% Erlang distribution
N_erlang = 2500;
k = 4;
l_erlang = 0.4;
erlang = zeros(N_erlang, 1);
for i = 1:N_erlang
    erlang(i) = -log(uniform(i*4-3) * uniform(i*4-2) * uniform(i*4-1) * uniform(i*4))/l_erlang;
end
% CDF creation
erlang_cdf = 0;
for i = 0:k-1
    erlang_cdf = erlang_cdf + (1/factorial(i)).*(exp(-l_erlang*x)).*(l_erlang*x).^i;
end
erlang_cdf = 1 - erlang_cdf;
% Cost calculation
erlang_cost = 0;
for i = 1:N_erlang
    if erlang(i) < 10.0
        erlang_cost = erlang_cost + 0.01*erlang(i);
    else
        erlang_cost = erlang_cost + 0.02*erlang(i);
    end
end
fprintf("Erlang --> cost = %f\n", erlang_cost);
figure
plot(sort(erlang), (1:N_erlang)/N_erlang, x, erlang_cdf, 'LineWidth', 1.5);
title("Erlang");
xlabel("Value");
ylabel("CDF");
legend("Generated", "Real Formula");

% Hypo-Exponential distribution
N_hypo = 5000;
l1_hypo = 0.5;
l2_hypo = 0.125;
hypo = zeros(N_hypo, 1);
for i = 1:N_hypo
    hypo(i) = -(log(uniform(2*i-1))./l1_hypo) -(log(uniform(2*i))./l2_hypo);
end
% Cost calculation
HypoExp_cost = 0;
for i = 1:N_hypo
    if hypo(i) < 10.0
        HypoExp_cost = HypoExp_cost + 0.01*hypo(i);
    else
        HypoExp_cost = HypoExp_cost + 0.02*hypo(i);
    end
end
fprintf("Hypo-Exp --> cost = %f\n", HypoExp_cost);
figure
plot(sort(hypo), [1:N_hypo]/N_hypo, x, HypoExp_cdf(x, l1_hypo, l2_hypo), 'LineWidth', 1.5);
title("Hypo-Exponential");
xlabel("Value");
ylabel("CDF");
legend("Generated", "Real Formula");

% Hyper-Exponential distribution
N_hyper = 5000;
l1_hyper = 0.5;
l2_hyper = 0.05;
p1 = 0.55;
hyper = zeros(N_hyper, 1);
for i = 1:N_hyper
    if uniform(i*2-1) <= p1
        hyper(i) = -log(uniform(2*i))/l1_hyper;
    else
        hyper(i) = -log(uniform(2*i))/l2_hyper;
    end
end
% Cost calculation
HyperExp_cost = 0;
for i = 1:N_hyper
    if hyper(i) < 10.0
        HyperExp_cost = HyperExp_cost + 0.01*hyper(i);
    else
        HyperExp_cost = HyperExp_cost + 0.02*hyper(i);
    end
end
fprintf("Hyper-Exp --> cost = %f\n", HyperExp_cost);
figure
plot(sort(hyper), [1:N_hyper]/N_hyper, x, HyperExp_cdf(x, l1_hyper, l2_hyper, p1), 'LineWidth', 1.5);
title("Hyper-Exponential");
xlabel("Value");
ylabel("CDF");
legend("Generated", "Real Formula");


function F = Uniform_cdf(x, p)
	a = p(1);
	b = p(2);
	F = max(0, min(1, (x>a) .* (x<b) .* (x - a) / (b - a) + (x >= b)));
end

function F = HypoExp_cdf(x, l1, l2)
    F = 1-((l2*exp(-l1*x))/(l2-l1))+((l1*exp(-l2*x))/(l2-l1));
end

function F = HyperExp_cdf(x, l1, l2, p1)
    F = 1-p1*exp(-x*l1) - (1-p1)*exp(-x*l2);
end