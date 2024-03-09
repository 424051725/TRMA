Matlab code for "Improving tensor regression by optimal model averaging"

DATE:               Jan 2024

Tested on MATLAB 2017a and 2022a
-------------------------------------------------------------------------------

The following MATALB script files are used to estimate the TRMA model on the
datasets studied in the main paper ( Section 4, and Supplementary material)

* simulation_demo.m
Demo script, generate 2-D synthetic dataset and estimates the TRMA model. This script will generate 2-D data with a sample size of 1000, then fit the CP tensor regression model of rank 1-5, and calculate the optimal model averaging weight. The code will eventually output the restored image of each candidate model and the restored image of the TRMA method. Finally, the KL loss of each model on the testing data and the RMSE of parameter prediction will be recorded in "2d/1000e=1/1result".

-------------------------------------------------------------------------------

Main functions:

* data_2d.m
Generate 2-D simulation data

* data_3d.m
Generate 3-D simulation data

* model.m
Calculate CP tensor regression model from rank-1 to rank-maxrank

*trma.m
Calculate optimal model averaging weight

*test.simulation.m
Calculate KL loss on the testing data
-------------------------------------------------------------------------------

Data format:

M_train, M_test: p_1*p_2*...*p_D*n tensor. In simulation_demo.m, M_train is a p_1*p_2*n tensor.

X_train, X_test: n*p coefficients besides tensor coefficients. If there is no other coefficients, just set X_train and X_test to be n*1 zero vector.

y_train, y_test: n*1 response vector.

n : sample size, 1000 by default.

sigma : noise level, 1 by default.

fold : CV fold number, 5 by default.

maxrank : the candidate models include rank-1 to rank-maxrank CP tensor regression model, 5 by default.

link : 'normal', 'binomial' or 'poisson'

pic_name : used for generating simulation data, and 6 different images are provided. If using other data, please ignore it.