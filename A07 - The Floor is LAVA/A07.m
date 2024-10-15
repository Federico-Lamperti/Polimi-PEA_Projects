clear all;

s = 1;
nexts = 0;
t = 0;
dt = 0;
resetTime = 5;
Tmax = 1000000;

games = 0;
wins = 0;

while t < Tmax
    % Entrance
    if s == 1
        if rand() < 0.7 % Yellow path
            if rand() < 0.8 % OK
                nexts = 2;
                dt = -log(prod(rand(4,1)))/1.5; % aggiorna con erlang k = 4 l = 1.5
            else % KO  
                nexts = 1;
                dt = -log(rand())/0.5; % aggiorna con exp l = 0.5
                games = games + 1;
                t = t + resetTime;
            end
        else % Light-Blue path
            if rand() < 0.3 % OK
                nexts = 3;
                dt = rand()*(6-3) + 3; % aggiorna con uniform a = 3 b = 6
            else % KO  
                nexts = 1;
                dt = -log(rand())/0.25; % aggiorna con exp l = 0.25
                games = games + 1;
                t = t + resetTime;
            end
        end
    end

    %C1
    if s == 2
        if rand() < 0.5 % Yellow path
            if rand() < 0.25 % OK
                nexts = 3;
                dt = -log(prod(rand(3,1)))/2; % aggiorna con erlang k = 3 l = 2
            else % KO
                nexts = 1;
                dt = -log(rand())/0.4; % aggiorna con exp l = 0.4
                games = games + 1;
                t = t + resetTime;
            end
        else % White path
            if rand() < 0.6 % OK
                nexts = 3;
                dt = -log(rand())/0.15; % aggiorna con exp l = 0.15
            else % KO
                nexts = 1;
                dt = -log(rand())/0.2; % aggiorna con exp l = 0.2
                games = games + 1;
                t = t + resetTime;
            end
        end
    end
    
    % C2
    if s == 3
        nexts = 1;
        dt = -log(prod(rand(5,1)))/4; % aggiorna con erlang k = 5 l = 4
        games = games + 1;
        t = t + resetTime;
        if rand() < 0.6 % WIN else KO
            wins = wins + 1;
        end
    end
    s = nexts;
    t = t + dt;
end

% Winning Probability
PW = wins/games;
fprintf("Probability of winning = %f\n", PW);

% Average duration of a game
AvgGD = (t - (resetTime*games))/games; 
fprintf("Average Duration of a game = %f\n", AvgGD);

% Throughput (#games/hour)
X = games*60 / t;
fprintf("Games per hour = %f\n", X);

% #games considered
fprintf("Games simulated = %d\n", games);

