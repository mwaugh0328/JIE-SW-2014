function [mme] = thetaest_est_mod_exact(pricemat,trade_mat) %#codegen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is the code to compute the estimate of theta

% Size some stuff up
[r,c]=size(pricemat);
cntry = r;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

log_p = log(pricemat);
dni = zeros(cntry,cntry);
dni2 = zeros(cntry,cntry);
% dni3 = zeros(cntry,cntry); dni4 = zeros(cntry,cntry);
% Now we are going to go through by country pair, compute the price
% differences, take max, second max, etc.
for importer = 1:cntry
    for exporter = 1:cntry
        
        % Compute the price difference
        pdiff = (log_p(importer,:)) - (log_p(exporter,:));
        
        % Sort them, the vector is small, so this is effecient.
        [g h] = sort(pdiff);
        
        % Now take the max and the 2nd max
        num = pdiff(h(end));        
        num2 = pdiff(h(end-1));

        % Compute the mean price difference
        den = mean((pdiff));
        % This is the proxy for the difference in the aggregate price of tradables, i.e. the
        % mean across all prices 
                
        dni(exporter,importer) = num - (den);
        dni2(exporter,importer) = num2 - (den);
    end
end

% Set up the normalized trade matrix trdx
trdx = trade_mat./repmat(diag(trade_mat),1,length(trade_mat));

% Don't include diagonal entries or (possible) zeros.
vvv = (trdx(:) == 0 | trdx(:) == 1);

% Compute the relative means.
top = mean(log(trdx(~vvv)));
mme1 = top./mean((dni(~vvv)));
% mme2 = top./mean((dni2(~vvv)));


%Output
mme = [mme1];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%









