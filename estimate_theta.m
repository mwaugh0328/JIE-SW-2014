% This is a program to estimate theta, by Michael Waugh and Ina Simonovska
% for the paper The Elasticity of Trade: Estimates and Evidence. 08/03/12
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 1 Compute Data moments of interest. 
% This is the part which computes the data moments. There are issues with
% sharing the ICP data, so below I will just hardwire in the moment of
% interest. Code for this step may be posted at some point (in particular
% when sutible for the ek estimation.

% clear
% load new_estimation_mat.mat
% straps = 500;
% 
% [mme]=thetaest_est_exact(pmat,tradeshare,istraded);
% 

% obs_char(pmat,tradeshare,distance,b,istraded);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Organize the trade data to run in the regression.
clear

load trade_grav_est_30.mat

home_share = diag(tradeshare);
n_country = length(home_share);
grav_trade = tradeshare./repmat(home_share',n_country,1);

e_code = repmat((1:n_country)',1,n_country);
i_code = repmat((1:n_country),n_country,1);

grav_data_set = [i_code(:), e_code(:), grav_trade(:), d_mat(:)/1.6, b_mat(:)];

csvwrite('grav_data.csv',grav_data_set);

% This is the appropriate format for the STATA code to run and read in the
% data...

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 2 Run the gravity regression on the trade data. This set of code
% closely corresponds with the repository in:
% https://github.com/mwaugh0328/Gravity-Estimation

run stata_to_tau

% The key output from this are (i) the unscaled tau parameters and (ii) the
% S parameters necessary to compute trade flows. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is the main routine that searches for the theta that mathches the
% observed moments to the moments implied by the model. See est_fun_exact
% for the details.

options = optimset('TolFun',10^-5,'TolX',10^-5,'Display','iter');

moments = -5.6286; % Define the moment we are targeting
boot = 0;

tic
[theta_hat, fval] = fminbnd(@(x) est_fun_exact(x,moments,tau_stata,ssd_stata,boot),3,7,options);
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Estimate of Theta')
disp(theta_hat)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%