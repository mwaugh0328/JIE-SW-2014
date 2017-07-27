%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code runs a gravity regression of the type in Eaton and Kortum (2002) or in Waugh (2010).
% This code is also of use for Simonovska Waugh (2014). It is essentially
% the same code as posted on 
% https://github.com/mwaugh0328/Gravity-Estimation
%
% The code calls stata to run a very simple regression using their
% powerfull tools to incoperate various fixed-effects. It then constructs
% trade costs and simmulates an equillibrium. 
%
% A note on the organization of tradeshare matrix and tradecost matrix.
% This is always setup so that a row is an importer, and a column is an
% exporter.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This calls the stata program ``gravity_run.do''. Note this is callable on
% its own. But make sure to remove the final line ``exit'' in the code to
% see the output in stata. Note will have to change the directory to find
% stata on your computere.

dos('"C:\Program Files (x86)\Stata13\StataSE-64" do gravity_run.do')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This loads some data and the coeffecients from the regression in stata,
% i.e. the coeff.txt.

load('trade_grav_est_30.mat')
beta = load('coeff.txt', '-ascii')';

% Just some house keeping. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N = (length(beta)-7)/2; 

% This is the number of countries. Why? Stata writes the coeffecients with
% the base set to zero. So there are 2*N fixed effects. Then one can look
% and see that country 1's are all set to zero... So subtract off the parts
% for distance and border, divide by two and you have the number of
% countries

home_home = eye(N);
hh = (home_home(:)~=1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ssd_stata = -beta(N+1:end-7); % Note Stata Code has exporter first, the Ss come off the importer effects
asym_est = beta(1:N) - ssd_stata; 
% Then the difference in exporter and importer effects is the assymetric
% component. 

% Now convert this into trade cost levels
asym = exp(asym_est)-1; % The asymetric component...

dist = exp(beta(end-6:end-1,:))-1; % The distance effects

bord = exp(beta(end,:))-1; % The boarder effect

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Then what the next set of code does is that it arranging the assymetric component of the
% matrix with the diagonal part removed (which is set to one). This is
% where one can interpert the assymetric componentn differently....

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Option #1: Interpertation of the asymmetric component on the export side,
% this is as in Waugh (2010)....

asym=(asym(:,:)*ones(1,N));
asym = asym(hh);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Option #2: Interpertation of the asymmetric component on the import side,
% this is as in EK(2002)....

% asym= rot90((asym(:,:)*ones(1,N)),1);
% asym = asym(hh);
% 
% ssd_stata = beta(1:N); 
% % Then in this case the S's are identified off the exporter effects (why,
% % the importer effects are ``tainted'' with the asymetric component).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is just to construct the distance matrix that is used to put
% together the trade frictions

mdist = .6213711*d_mat;
mdist_nz = mdist(hh);

for i = 1:length(d_mat(hh))
    ddd  = mdist_nz(i);
    dmat_nz(i,:) = double([(ddd < 375) (375<=ddd & ddd<750) (750<=ddd& ddd<1500) (1500<=ddd& ddd<3000)...
            (3000<=ddd& ddd<6000) (6000<=ddd)]);
end

border_nz = b_mat(hh);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now reconstruct the trade frictions, tau_stata
tau_stata = zeros(N^2,1);
dist_stata = zeros(N^2,1);

tau_stata(~hh) = 1;
dist_stata(~hh) = 1;

tau_stata(hh) = (1+dmat_nz*dist).*(1+border_nz.*bord).*(1+asym);
tau_stata = reshape(tau_stata,N,N);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% So now what we have are (1) tau_stata (THAT MUST BE SCALED BY THETA TO
% MAKE SENSE) AND (2) SSD which are the ``S'' parameters. 



