function line_ploter_3D(time, x, y, z, t1, t2, color)

for j = 1:length(x(1, :))
    if j == 1
        plot3(x(:, j), y(:, j), z(1:length(x), j), ...
            'Color', color(j, :), 'LineWidth',1);
        hold on
        continue
    end
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

    plot3(x(index_start:index_1, j), y(index_start:index_1, j)...
        ,z(index_start:index_1, j), 'Color', color(j, :)...
        , 'LineWidth',1);
    
    hold on

    
    plot3(x(index_1+1:index_2, j), y(index_1+1:index_2, j)...
        ,z(index_1+1:index_2, j), 'Color', color(j, :),...
        'LineStyle', ':', 'LineWidth',2);
    
    

    plot3(x(index_2+1:index_end, j), y(index_2+1:index_end, j)...
        ,z(index_2+1:index_end, j),...
        'Color', color(j, :), 'LineWidth',1);
end
end
