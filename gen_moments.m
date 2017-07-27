function moments = gen_moments(mhat, rec_low_price,err_var,Nsubs,sample,nmoments,boot)
% This code computes the moments from simmulated trade flow and price data

moments = zeros(Nsubs,nmoments);
Ngoods = length(rec_low_price);
rng(072279+boot)

for sub_runs = 1:Nsubs
        
        % Add disturbances to the trade shares, the err_var is the st.dev
        % to the error term in the gravity regression
        %m = trade_add_error(mhat, err_var,007+sub_runs+boot);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Draw the number of goods that we want
            
        keep = randi(Ngoods,sample,1);

        final_price_tilde = (rec_low_price(keep,:))';
            
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Compute the new estimate of theta given this, add to old because we
        % want the sum.
    
%         moments(sub_runs,:) = thetaest_est_mod_exact(final_price_tilde, m);
        moments(sub_runs,:) = thetaest_est_mod_exact(final_price_tilde, mhat);
        % using the .mex provides alot of speed up. I will include the
        % regular file as well.
    
end