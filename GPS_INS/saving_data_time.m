function saving_data_time(data, name)
    now_time = string(datetime('now'));
    str_now_time = now_time{1};
    str_now_time(12) = '-';
    str_now_time(15) = '-';
    str_now_time(18) = '-';
    save(append('../data_created/', str_now_time, '-',...
        'INS_GPS_function_', name), 'data');