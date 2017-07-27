function loss = est_fun_exact(theta,moments,tau,ssd,boot)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% first, scale the tau by the theta.

tau = tau.^(-1/theta);
err_var = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Specifies values for the simmulation. 
% Here sigma plays no real role.
%
% Nruns is the numer of times a new trade matrix is simmulated with the
% associated prices. The trade flows vary little across the simmulations,
% hence the small number. 
%
% For each trade flow price data set, prices are sampled. This is done 100 
% times per simmulation of the trade flows. The number of prices sampled is
% 50, the same as in the EK data set.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sigma = 1.5;
Nruns = 32;
Nsubs = 100;
sample = 62;
nmoments = length(moments);

record = zeros(Nsubs,length(moments),Nruns);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now the simmulatio is performed. Included is the
% .mex and the normal .m file. The .mex runs much faster. 
%
% Given the trade flows, mhat and prices final_price, it passes this to the
% gen moments routine. See this for more details.
%
% Finally, I use the parfor command, this distributes each computation to a
% different core. This obviously speeds things up a lot.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
parfor runs = 1:Nruns
% 
%     [mhat, final_price] = sim_trade_pattern_ek(exp(ssd),tau,1./theta,sigma,runs+boot);

    [mhat, final_price] = sim_trade_pattern_ek(exp(ssd),tau,theta,sigma,runs+boot);
  
    record(:,:,runs)  = gen_moments(mhat, final_price, err_var,Nsubs,sample,nmoments,runs+boot);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Record stuff and then compute the difference between the observed moments
% and the simmulated moments.

record_s = [];
for runs = 1:Nruns
    record_s = [record_s;record(:,:,runs)];
end

s_moments = mean(record_s)';
y_theta = moments - s_moments;

loss = y_theta.^2;