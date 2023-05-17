time = in_profile(:, 1);
t1 = 100;
t2 = 300;
t_end = 450;
index_1 = find(time == t1);
index_2 = find(time == t2);
index_end = find(time == t_end);

plot(time(1:index_1), in_profile(1:index_1, 1), 'r', 'LineWidth',2);

hold on 

plot(time(index_1+1:index_2), in_profile(index_1+1:index_2, 1)...
    , 'r--', 'LineWidth',2);

plot(time(index_2+1:index_end), in_profile(index_2+1:index_end, 1)...
    , 'r', 'LineWidth',2);

%% 
time = data(:, 1);
t1 = 100;
t2 = 300;
t_end = 450;
index_1 = find(time == t1);
index_2 = find(time == t2);
index_end = find(time == t_end);


subplot(2, 3, 1) %% (epoch,8:10) attitude

plot(time(1:index_1), data(1:index_1, 8), 'r', 'LineWidth',2);

hold on 

plot(time(index_1+1:index_2), data(index_1+1:index_2, 8)...
    , 'r--', 'LineWidth',2);

plot(time(index_2+1:index_end), data(index_2+1:index_end, 8)...
    , 'r', 'LineWidth',2);

% plot(data(:, 8));
subplot(2, 3, 2) %% (epoch,8:10) attitude
plot(data(:, 9));
subplot(2, 3, 3) %% (epoch,8:10) attitude
plot(data(:, 10));


subplot(2, 3, 4) %% (epoch,5:7)
plot(data(:, 5));
subplot(2, 3, 5) %% (epoch,5:7)
plot(data(:, 6));
subplot(2, 3, 6) %% (epoch,5:7)
plot(data(:, 7));