clear all;

% Filename must be changed to see different Traces
filename = "Trace1.csv";
%filename = "Trace2.csv";
%filename = "Trace3.csv";
Table = readtable(filename);

fprintf("Analyzing %s file.\n", filename)

T = 0;
B = 0;
for i = 1:25000
    T = T + Table{i,1};
    B = B + Table{i,2};
end

A = zeros(25000,1);
C = zeros(25000,1);
A(1) = Table{1,1};
for i = 2:25000
    A(i) = A(i-1) + Table{i,1};
end
C(1) = A(1) + Table{1,2};
for i = 2:25000
    C(i) = Table{i,2} + max(A(i), C(i-1)); 
end

% Utilization
U = B/T;
fprintf("Utilization = %f\n", U);

% Average Response Time
nC = 25000;
W = C - A;
R = sum(W)/nC;
fprintf("Average Response Time = %f\n", R);

% Frequency at which the system returns idle
NI = 0;
for i = 1:24999
    if A(i+1) > C(i)
        NI = NI + 1;
    end
end
F = NI/T;
fprintf("Idle Frequency = %f\n", F);

% Average Idle Time
I = (T-B)/NI;
fprintf("Average Idle Time = %f\n", I);
