clear all;

%%% Closed Model %%%
fprintf("Analyzing the closed model!\n");

% Number of clients
N = 10;
% Think time in s
Z = 10;
% Service times in s
S_cpu = 20/1000;
S_disk = 10/1000;
S_ram = 3/1000;

% Visits to the stations
L0 = [1, 0, 0, 0];

P0 = [0, 1, 0, 0;
      0, 0, 0.3, 0.6;
      0, 0.85, 0, 0.15;
      0, 0.75, 0.25, 0 ];

visits = L0 * inv(eye(4) - P0);

v_ref = visits(1);
v_cpu = visits(2);
v_disk = visits(3);
v_ram = visits(4);

fprintf("Visits:   Terminals = %d, CPU = %f, DISK = %f, RAM = %f\n", v_ref, v_cpu, v_disk, v_ram);

% Demands of the stations
D_cpu = v_cpu * S_cpu;
D_disk = v_disk * S_disk;
D_ram = v_ram * S_ram;
fprintf("Demands:  Terminals = %d, CPU = %f, DISK = %f, RAM = %f\n", Z, D_cpu, D_disk, D_ram);

%%% Open Model %%%
fprintf("\nAnalyzing the open model!\n");

% Lambda IN in jobs/s
l_0 = 0.3;

L = [1, 0, 0];

P = [ 0, 0.3, 0.6;
      0.8, 0, 0.15;
      0.75, 0.25, 0 ];

% Visits to the stations
v = L * inv(eye(3) - P);
v_cpu2 = v(1);
v_disk2 = v(2);
v_ram2 = v(3);
fprintf("Visits:       CPU = %f, DISK = %f, RAM = %f\n", v_cpu2, v_disk2, v_ram2);

% Demand of the stations
D_cpu2 = v_cpu2 * S_cpu;
D_disk2 = v_disk2 * S_disk;
D_ram2 = v_ram2 * S_ram;
fprintf("Demands:      CPU = %f, DISK = %f, RAM = %f\n", D_cpu2, D_disk2, D_ram2);

% Throughput of the stations
X = l_0;
X_cpu = v_cpu2 * X;
X_disk = v_disk2 * X;
X_ram = v_ram2 * X;
fprintf("Throughputs:  CPU = %f, DISK = %f, RAM = %f\n", X_cpu, X_disk, X_ram);
