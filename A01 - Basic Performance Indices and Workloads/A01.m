clear all;

filename = 'barrier.log';
Table = readtable(filename);

% Time array setting first event to 0s
ds = Table.Var6;
ds = strrep(ds, "[_IN_", "");
ds = strrep(ds, "]", "");
ds = strrep(ds, "[_OUT", "");
dsint = str2double(ds);
Time = (Table.Var2-281)*24*60*60 + Table.Var3*60*60 + Table.Var4*60 + Table.Var5 + dsint*0.1;
Time = Time - Time(1,1);

% Total time T
T = Time(2000,1);

% Total Arrivals and completed Jobs
A = 0;
C = 0;
IN = zeros(1000,1);
OUT = zeros(1000,1);
QL = 0;
queue = zeros (2000,1);
for i = 1:size(Table)
    var6 = string(Table{i, 6});
    if (contains(var6, "_IN_"))
        A = A + 1;
        IN(A) = Time(i,1);
        QL = QL + 1;
        queue(i,1) = QL;
    else
        C = C + 1;
        OUT(C) = Time(i,1);
        QL = QL - 1;
        queue(i,1) = QL;
    end
end

% Arrival rate
lambda = A/T;
fprintf("Arrival Rate = %f\n", lambda);

% Throughput
X = C/T;
fprintf("Thoughput = %f\n", X);

% Average inter-arrival time
AA = 1/lambda;
fprintf("Average inter-arrival time = %f\n", AA);

% Busy Time 
Idle = 0;
for i = 1:2000-1
    if queue(i,1) == 0
        Idle = Idle + Time(i+1,1) - Time (i, 1);
    end
end
B = T - Idle;

% Utilization
U = B/T;
fprintf("Utilization = %f\n", U);

% Average Service Time
S = B/C;
fprintf("Average Service Time = %f\n", S);

% Average Number of Jobs in system
W = 0;
for i = 1:2000-1
    W = W + queue(i,1) * (Time(i+1,1)-Time(i,1));
end
N = W/T;
fprintf("Average Number of Jobs = %f\n", N);

% Average Response Time
R = W/C;
fprintf("Average Response Time = %f\n", R);

% Probability of having m parts in the machine (with m = 0, 1, 2)
T1 = 0;
T2 = 0;
for i = 1:2000-1
    if queue(i,1) == 1
        T1 = T1 + Time(i+1,1) - Time (i, 1);
    end
    if queue(i,1) == 2
        T2 = T2 + Time(i+1,1) - Time (i, 1);
    end
end
P0 = Idle/T;
P1 = T1/T;
P2 = T2/T;
fprintf("Probability of having 0 jobs in queue = %f\n", P0);
fprintf("Probability of having 1 jobs in queue = %f\n", P1);
fprintf("Probability of having 2 jobs in queue = %f\n", P2);

% Probability of having a response time less than t, (with t = 30 sec, 3 min)
r_i = zeros(1000,1);
for i = 1:1000
    r_i(i) = OUT(i) - IN(i);
end
R1 = 0;
R2 = 0;
for i = 1:1000
    if r_i(i,1) < 30
        R1 = R1 + 1;
    end
    if r_i(i,1) < 180
        R2 = R2 + 1;
    end
end
PR1 = R1/C;
PR2 = R2/C;
fprintf("Probability of having a response time < 30 sec = %f\n", PR1);
fprintf("Probability of having a response time < 3 min = %f\n", PR2);

% Probability of having an inter-arrival time shorter than 1 min
a_i = zeros(1000,1);
for i = 2:1000
    a_i(i) = IN(i) - IN(i-1);
end
AX = 0;
for i = 1:1000
    if a_i(i,1) < 60
        AX = AX + 1;
    end
end
PA = AX/A;
fprintf("Probability of having an inter-arrival time < 1 min = %f\n", PA);

% Probability of having a service time longer than 1 min
s_i = zeros(1000,1);
s_i(1) = OUT(1) - IN(1);
for i = 2:1000
    if IN(i) > OUT(i-1)
        s_i(i) = OUT(i) - IN(i);
    else
        s_i(i) = OUT(i) - OUT(i-1);
    end
end
SX = 0;
for i = 1:1000
    if s_i(i,1) > 60
        SX = SX + 1;
    end
end
PS = SX/C;
fprintf("Probability of having a service time > 1 min = %f\n", PS);