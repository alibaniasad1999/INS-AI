function line_ploter(time, data, t1, t2, color)

for j = 1:length(data)
    if j > 9
        break;
    end
    subplot(3, 3, j);
for i = 1:length(t1)
     
    if i == 1
        index_start = 1;
    else
        index_start = find(time == t2(i-1));
    end

    if i == length(t1)
        index_end = length(time);
    else
        index_end = find(time == t1(i+1));
    end
    index_1 = find(time == t1(i));
    index_2 = find(time == t2(i));
    plot(time(index_start:index_1), data(index_start:index_1, j), 'Color', color(j, :)...
        , 'LineWidth',1);
    
    hold on

    
    plot(time(index_1+1:index_2), data(index_1+1:index_2, j), 'Color', color(j, :),...
        'LineStyle', ':', 'LineWidth',2);
    
    plot(time(index_2+1:index_end), data(index_2+1:index_end, j)...
        , 'Color', color(j, :), 'LineWidth',1);
end
end
