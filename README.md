# JIE-SW-2014

This repository contains key elements of the Code replicate results in...

[1] [**The Elasticity of Trade: Estimates and Evidence**](http://www.waugheconomics.com/uploads/2/2/5/6/22563786/estimate_theta_paper.pdf), with Ina Simonovska.<br>
Journal of International Economics, 92(1): 34-50. January 2014.
2015 Winner of The Bhagwati Award (selected by the JIE Editorial Board as the best article published in the
JIE during 2013 and 2014).

[2] [**Trade models, trade elasticities, and the gains from trade**](http://www.waugheconomics.com/uploads/2/2/5/6/22563786/trade_elasticities.pdf), with Ina Simonovska.<br>
No. w20495. National Bureau of Economic Research, 2014.

NOTE: This is not comprehensive (i.e. all datasets, robustness exercises, etc.)

The main driver file is **estimate_theta.m** It does the following:

First, it loads in the trade data and organizes it in a suitable way for gravity estimation. This later step is

Second, given an moment, the biased estimate from, say, Eaton and Kortum (2002), it then finds the theta such that the biased moment from the model matches the one in the data. This is performed in **est_fun_exact.m** Within this later function, the key piece of code is **sim_trade_pattern_ek.m** which simulates trade and price data as if Eaton and Kortum (2002) were the data generating process.

Finer points: First, the dataset provided is simply the 30 country data set used in [2]. At some point, the data set from Eaton and Kortum (2002) may be posted. Second, the actual price data used in [1] and [2] is not posted here per our user agreement. In **estimate_theta.m** I report the moment seen in the data and that is the target. Third, extensions such as over-identified, bootstrap standard errors, other moments are not posted here. They may be at some point. 




