clear all;

for i = 1:4 
    if i == 1
        filename = "HE.txt";   %HyperExp almost identical l1 = 0.016712, l2 = 0.004106, p1 = 0.800100
    end
    if i == 2
        filename = "HH.txt";   %HyperExp almost identical l1 = 0.066928, l2 = 0.016758, p1 = 0.794677
    end
    if i == 3
        filename = "LE.txt";   %Erlang best one k = 12, lambda = 2.497850
    end
    if i == 4
        filename = "LH.txt";   %Erlang best one k = 12, lambda = 7.986706
    end

    data = importdata(filename);
    fprintf("\nReading file %s...\n", filename);
    
    fprintf("Max = %f\n", max(data));

    sorted = sort(data);
    size = 50000;
    if i == 1
        x = linspace(0, 2406, 24060);
    end
    if i == 2
        x = linspace(0, 524, 5240);
    end
    if i == 3
        x = linspace(0, 14, 140);
    end
    if i == 4
        x = linspace(0, 4, 40);
    end
    
    global mean;
    global var;
    
    % Total time
    T = sum(data);
    %fprintf("T = %f\n", T);
    
    % First Moment
    mean = sum(data)/size;   % mean() function has conflict with global variable
    fprintf("Mean = %f\n", mean);
    
    % Second moment
    secm = sum(data.^2)/size;
    fprintf("Second Moment = %f\n", secm);
    
    % Third moment
    thim = sum(data.^3)/size;
    fprintf("Third Moment = %f\n", thim);
    
    % Variance and Sigma
    var = secm - mean^2;
    sigma = sqrt(var);
    %fprintf("Variance = %f\n", var);
    
    % Coefficient of Variation
    cv = sigma/mean;
    %fprintf("Coefficient of Variation = %f\n", cv);
    
    %%% Fitting with direct expressions %%%    
    % Exponential Fitting
    l_exp = 1/mean;
    fprintf("Exp --> lambda = %f\n", l_exp);
    
    % Erlang Fitting
    if cv > 1
        fprintf("Coefficient of Variation > 1, so can't fit using Erlang!\n");
    else
        k_erlang = round(1/cv^2);
        l_erlang = k_erlang / mean;
        fprintf("Erlang --> k = %d, lambda = %f\n", k_erlang, l_erlang);
        erlang_cdf = 0;
        for i = 0:k_erlang-1
            erlang_cdf = erlang_cdf + (1/factorial(i)).*(exp(-l_erlang*x)).*(l_erlang*x).^i;
        end
        erlang_cdf = 1 - erlang_cdf;
    end
    
    %%% Fitting with Method of Moments %%%
    % Weibull Fitting
    options = optimset('Display','off');
    par_weib = fsolve(@Weibull_moments_eq, [0.5, 0.5], options);
    l_weibull = par_weib(1);
    k_weibull = par_weib(2);
    fprintf("Weib --> lambda = %f, k = %f\n", l_weibull, k_weibull);
    
    % Pareto Fitting
    par_pareto = fsolve(@Pareto_moments_eq, [2.1, 0.5], options);
    alpha = double(par_pareto(1));
    m = double(par_pareto(2));
    fprintf("Pareto --> alpha = %f, m = %f\n", alpha, m);
    pareto_cdf = (m./x).^alpha;
    pareto_cdf = 1 - min(pareto_cdf, 1);

    %%% Fitting with Maximum Likelihood Technique %%%
    % 2-stage Hyper Exponential Fitting
    if cv < 1
        fprintf("Coefficient of Variation < 1, so can't fit using Hyper-exponential!\n");
    else
        Hyper_values = mle(data(:,1), 'pdf', @HyperExp_pdf, 'start', [0.1, 0.1, 0.1], 'LowerBound', [0, 0, 0], 'UpperBound', [Inf, Inf, 1]);
        l1_hyper = Hyper_values(1);
        l2_hyper = Hyper_values(2);
        prob = Hyper_values(3);
        fprintf("Hyper_exp --> l1 = %f, l2 = %f, p1 = %f\n", l1_hyper, l2_hyper, prob);
    end
    
    % 2-stage Hypo Exponential Fitting
    if cv > 1
        fprintf("Coefficient of Variation > 1, so can't fit using Hypo-exponential!\n");
    else
        Hypo_values = mle(data(:,1), 'pdf', @HypoExp_pdf, 'start', [1, 0.5], 'LowerBound', [0, 0], 'UpperBound', [Inf, Inf]);
        l1_hypo = Hypo_values(1);
        l2_hypo = Hypo_values(2);
        fprintf("Hypo-exp --> l1 = %f, l2 = %f\n", l1_hypo, l2_hypo);
    end
    
    if cv > 1 % Do not plot Erlang and Hypo Exponential
        figure('Name', filename,'NumberTitle','off')
        plot(sorted, [1:size]/size, '+', x, 1-exp(-l_exp*x), x, wblcdf(x, l_weibull, k_weibull), x, pareto_cdf, x, HyperExp_cdf(x, l1_hyper, l2_hyper, prob), 'LineWidth', 1.5);
        title(filename);
        xlabel('Value');
        ylabel('CDF');
        legend("Trace", "Exponential", "Weibull", "Pareto", "HyperExp");
    elseif cv < 1 % Do not plot Hyper Exponential
        figure('Name', filename,'NumberTitle','off')
        plot(sorted, [1:size]/size, '+', x, 1-exp(-l_exp*x), x, erlang_cdf, x, wblcdf(x, l_weibull, k_weibull), x, pareto_cdf, x, HypoExp_cdf(x, l1_hypo, l2_hypo), 'LineWidth', 1.5);
        title(filename);
        xlabel('Value');
        ylabel('CDF');
        legend("Trace", "Exponential", "Erlang", "Weibull", "Pareto", "HypoExp");
    end
end

%%% Functions %%%
function f = Weibull_moments_eq(x)
    global mean;
    global var;
    lambda = x(1);
    k = x(2);
    f(1) = lambda*gamma(1 + 1/k) - mean;
    f(2) = lambda^2 * (gamma(1 + 2/k) - (gamma(1 + 1/k)^2)) - var;
end

function f = Pareto_moments_eq(x)
    global mean;
    global var;
    alpha = x(1);
    m = x(2);
    f(1) = (alpha*m/(alpha-1)) - mean;
    f(2) = (alpha/(alpha-2))*(m/(alpha-1))^2 - var;
end

function f = HyperExp_pdf(x, l1, l2, p1)
    f = p1*l1*exp(-l1*x) + (1-p1)*l2*exp(-l2*x);
end

function F = HyperExp_cdf(x, l1, l2, p1)
    F = 1-p1*exp(-x*l1) - (1-p1)*exp(-x*l2);
end

function f = HypoExp_pdf(x, l1, l2)
    f = (l1*l2)/(l1-l2)*(exp(-l2*x)-exp(-l1*x));
end

function F = HypoExp_cdf(x, l1, l2)
    F = 1-((l2*exp(-l1*x))/(l2-l1))+((l1*exp(-l2*x))/(l2-l1));
end