clear all;

% Filename must be changed to see different Traces
filename = "Trace1.csv";
%filename = "Trace2.csv";
%filename = "Trace3.csv";
fprintf("Analyzing file %s ...\n", filename);
data = readtable(filename);

size = 25000;

% Mean 
mean = sum(data{:,1})/size;
fprintf("Mean = %f\n", mean);

% Second moment
secm = sum(data{:,1}.^2)/size;
fprintf("Second Moment = %f\n", secm);

% Third moment
thim = sum(data{:,1}.^3)/size;
fprintf("Third Moment = %f\n", thim);

% Fourth moment
form = sum(data{:,1}.^4)/size;
fprintf("Fourth Moment = %f\n", form);

% Variance
var = secm - mean^2;
fprintf("Variance = %f\n", var);
sigma = sqrt(var);

% Third centered moment
tcm = sum((data{:,1} - mean).^3)/size;
fprintf("Third Centered Moment = %f\n", tcm);

% Fourth centered moment
fcm = sum((data{:,1} - mean).^4)/size;
fprintf("Fourth Centered Moment = %f\n", fcm);

% Skewness
skew = skewness(data{:,1});
fprintf("Skewness = %f\n", skew);

% Fourth standardized moment
fsm = fcm/var^2;
fprintf("Fourth Standardized Moment = %f\n", fsm);

% Standard Deviation
% sigma already computed above
fprintf("Standard Deviation = %f\n", sigma);

% Coefficient of Variation
cv = sigma/mean;
fprintf("Coefficient of Variation = %f\n", cv);

% Excess Kurtosis
exku = fsm - 3;
fprintf("Excess Kurtosis = %f\n", exku);

% Median
median = median(data{:,1});
fprintf("Median = %f\n", median);

% First quartile
fiq = quantile(data{:,1}, 0.25);
fprintf("First Quartile = %f\n", fiq);

% Third quartile
tiq = quantile(data{:,1}, 0.75);
fprintf("Third Quartile = %f\n", tiq);

% Draw figure with the Pearson Correlation Coefficient for lags m=1 to m=100
standard = data{:,1} - mean; 
lagm = zeros(100,1);
for m = 1:100
    sm = sum((standard(1:end-m, :)).*(standard(m+1:end,:)))/(size-m);
    lagm(m) = sm / var;
end
figure
plot(lagm, 'LineWidth', 2);
title(filename);
xlabel('Lags');
ylabel('Pearson Correlation Coefficient');
grid on;

% Draw the approximated CDF of the corresponding distribution
sorted = sort(data{:,1});
[cdf, x] = ecdf(sorted);
figure
plot(x, cdf, 'LineWidth', 2);
title(filename);
xlabel('Value');
ylabel('Probability');
ylim([0,1]);
grid on;

