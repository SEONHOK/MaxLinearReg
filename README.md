# Introduction

This folder contains the code necessary to replicate the numerical results presented in the paper "Max-Linear Regression by Convex Programming" ([IEEE Xplore](https://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=10381831)).

# Running the codes

Run the main script "main_tit.m". 

1. To reproduce the results in Figure 3, set 

  noisy=noisy_list{1};
  cases=cases_list{1};

2. To reproduce the results in Figure 4, set 

  noisy=noisy_list{2};
  cases=cases_list{1};

3. To reproduce the results in Figure 5, set 

  noisy=noisy_list{1};
  cases=cases_list{2};

Here are brief explanations for the files of algorithms used in the experiments:

1. Iterative_AR_maxlinear_constraint.m: Contains the code for iterative Anchored regression as described in Algorithm 1. To run the anchored regression, set MaxIter = 1.

2. AMalgorithm_linear.m: Contains the code for alternating minimization for max-linear regression by Ghosh et al. ([IEEE Xplore](https://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=9627154)).

3. AMalgorithm_LAD.m: Contains the code for alternating minimization for the LAD formulation.


# Contact Information 

If you have issues or questions to run the codes, please contact me at kim.7604@osu.edu






