clear all;

T = 8;

% Compute the Infinitesimal Generator Q
q12 = 0.33;
q14 = 0.05;
q21 = 0.6;
q23 = 0.4;
q24 = 0.05;
q32 = 1;
q34 = 0.05;
q41 = 6*0.6;
q42 = 6*0.3;
q43 = 6*0.1;

q11 = -q12-q14;
q22 = -q21-q23-q24;
q33 = -q32-q34;
q44 = -q41-q42-q43;

Q = [q11, q12, 0, q14;
     q21, q22, q23, q24;
     0, q32, q33, q34;
     q41, q42, q43, q44];

% Evolution of the states of the system starting from the MEDIUM state
p0 = [0,1,0,0];
[t0, Sol0] = ode45(@(t,x) Q'*x, [0 T], p0');
figure
plot(t0, Sol0, 'LineWidth', 1.5);
xlabel("Time");
ylabel("Probability");
title("Starting from MEDIUM");
legend("LOW", "MEDIUM", "HIGH", "DOWN");

% Evolution of the states of the system starting from the DOWN state
p1 = [0,0,0,1];
[t1, Sol1] = ode45(@(t,x) Q'*x, [0 T], p1');
figure
plot(t1, Sol1, 'LineWidth', 1.5);
xlabel("Time");
ylabel("Probability");
title("Starting from DOWN");
legend("LOW", "MEDIUM", "HIGH", "DOWN");
