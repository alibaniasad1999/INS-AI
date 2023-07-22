load('all_data.mat', 'AI_result')
data = AI_result;
time = data(:, 1);
t1 = 1045;
t2 = 1800;

colors = [
    0.9290 0.6940 0.1250;  % Dark yellow
    0.3010 0.7450 0.9330;  % Light blue
    0.6350 0.0780 0.1840;  % Dark red
    0.4660 0.6740 0.1880;  % Dark green
    0.8500 0.3250 0.0980;  % Dark orange
    0 0.4470 0.7410;       % Dark blue
    0.9290 0.6940 0.5640;  % Light brown
    0.4940 0.1840 0.5560;  % Dark purple
    0.4660 0.6740 0.1880   % Dark green
];
line_ploter_split(time, data(:, 2:end), t1, t2, colors)

hold off
% line_ploter_3D(time, horzcat(rN(1:end-1), rN2)...
%     , horzcat(rE(1:end-1), rE2), horzcat(states(:, 4), states(:, 4)+1), t1, t2, colors)