function line_ploter_split(time, data, t1, t2, ~)
title_array = ["North position error", "East position error", ...
    "Down position error", "North velocity error", "East velocity error", ...
    "Down velocity error", "Attitude error about North", "Attitude error about East", ...
    "Heading error"];
for j = 1:length(data)
    if j > 9
        break;
    end
    set(gca, 'FontSize', 16)
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
    plot(time(index_start:index_1), data(index_start:index_1, j), 'Color', 'b'...
        , 'LineWidth',2);
    
    hold on
    
    plot(time(index_1+1:index_2), data(index_1+1:index_2, j), 'Color', 'b',...
        'LineStyle', ':', 'LineWidth',2);
    
    plot(time(index_2+1:index_end), data(index_2+1:index_end, j)...
        , 'Color', 'b', 'LineWidth',1);
end
    xlabel('Time(sec)', 'interpreter', 'latex', 'FontSize', 24);
    ylabel('error', 'interpreter', 'latex', 'FontSize', 24);
    set(gca, 'FontSize', 16, 'FontName', 'Times New Roman');
    print(append('../../AI-aided-Transfer-alignment-Manuscript/Figure/AI-results/Slave/'...
        ,title_array(j)), '-depsc', '-tiff', '-r300', '-vector');
    close;
end
