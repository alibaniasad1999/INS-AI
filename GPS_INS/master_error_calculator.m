AI_result_Master = zeros(length(x_train), 10);
for i = 1:length(x_train)

est_L_b_Master = x_train(epoch, 1);
est_lambda_b_Master = x_train(epoch, 2)';
est_h_b_Master = x_train(epoch, 3)';
est_v_eb_n_Master = x_train(epoch, 4:6)';
est_C_b_n_Master = Euler_to_CTM(x_train(epoch, 7:9));

[delta_r_eb_n,delta_v_eb_n,delta_eul_nb_n] = Calculate_errors_NED(...
        est_L_b_Master,est_lambda_b_Master,est_h_b_Master,est_v_eb_n_Master,est_C_b_n_Master,true_L_b,...
        true_lambda_b,true_h_b,true_v_eb_n,true_C_b_n);

AI_result_Master(epoch,2:4) = delta_r_eb_n';
AI_result_Master(epoch,5:7) = delta_v_eb_n';
AI_result_Master(epoch,8:10) = delta_eul_nb_n';
end