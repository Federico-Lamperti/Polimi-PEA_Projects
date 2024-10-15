clear all;

% Number of users
N = 80;

% Service times (S(1) = Z) in s
S = [ 40, 0.05, 0.002, 0.08, 0.08, 0.12 ];

% Probabilities
P = [ 0, 1, 0, 0, 0, 0;
      0.1, 0, 0.4, 0.5, 0, 0;
      0, 0, 0, 0, 0.6, 0.4;
      0, 1, 0, 0, 0, 0;
      0, 1, 0, 0, 0, 0;
      0, 1, 0, 0, 0, 0;
    ];
P(:,1) = 0;

L = [1, 0, 0, 0, 0, 0];

% Visits
v = L * inv(eye(6) - P);

% Demands
D = v .* S;

% Considering the system to be separable, compute with MVA

Q = zeros(N, 6);
Rk = zeros(N, 6);
X = zeros(N, 1);

for i = 1:N
    if i == 1
        Rk(i,:) = D;
    else
        for k = 1:6
            if k == 1
                Rk(i,k) = D(1);
            else
                Rk(i,k) = D(k) * (1+Q(i-1, k));
            end
        end
    end
    X(i) = i / sum(Rk(i, :));
    Q(i,:) = Rk(i,:)*X(i);
end

% Throughput of the system
Xa = 1/sum(D);
fprintf("Throughput = %f\n", X(N));

% Average system response time
R = sum(Rk(N,:)) - S(1);
fprintf("Average response time = %f\n", R);

% Utilization of the [2] Application Server, [4] DBMS, [5] Disk 1, and [6] Disk 2
U = X(N) * D;
fprintf("Utilization of:\n\t- Application Server = %f,\n\t- DBMS = %f,\n\t- Disk 1 = %f,\n\t- Disk 2 = %f.\n", U(2), U(4), U(5), U(6));

