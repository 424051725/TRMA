Matlab code for "Improving tensor regression by optimal model averaging"

DATE:               Jan 2024

Tested on MATLAB 2017a and 2022a
-------------------------------------------------------------------------------

The following MATALB script files are used to estimate the TRMA model on the
datasets studied in the main paper (Section 4, and Supplementary material)

* simulation_demo.m
Demo script, generate 2-D synthetic dataset and estimates the TRMA model. This script will generate 2-D data with a sample size of 1000, then fit the CP tensor regression model of rank 1-5, and calculate the optimal model averaging weight. The code will eventually output the restored image of each candidate model and the restored image of the TRMA method. Finally, the KL loss of each model on the testing data and the RMSE of parameter prediction will be recorded in "2d/1000e=1/1result".

-------------------------------------------------------------------------------
Workflow

simulation_demo.m contains the following parts, and each step corresponds to a section in the code:
Step 1:  2-D simulation   
	Clear the workspace
Step 2:  parameter setting
	Set default parameters, all parameters in this part can be changed to obtain results under a different setting
Step 3:  generate 2-D simulation data
	Generate 2-D data through data_2d.m. If one wants to perform 3-D simulation, then run data_3d.m instead of data_2d.m
Step 4:  calculate optimal model averaging weight
	Calculate the optimal weight through 'trma' function.
Step 5:  calculate model of each rank
	Obtain the results of different candidate models.
Step 6:  calculate weight of other model averaging methods
	Obtain the weights of comparison methods, including AIC, BIC, EQMA, etc.
Step 7:  calculate KL loss on the testing data
	Calculate the KL loss and MSE in the testing dataset 
Step 8:  print recovered image and save results
	Save the results and visualize them
-------------------------------------------------------------------------------
Dependency

TensorReg Toolbox

This toolbox is developed by Hua Zhou, and is avaliable at https://hua-zhou.github.io/TensorReg/. It is a collection of Matlab functions for tensor regressions, including CP and Tucker tensor regression and sparse tensor regression. Please download and install this toolbox before running the demo.

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

n : sample size, 1000 by default. Suggested adjustment ranges: 500~2000

sigma : noise level, 1 by default. Suggested adjustment ranges: 1~5

fold : CV fold number, 5 by default. Suggested adjustment ranges: [5,10]

maxrank : the candidate models include rank-1 to rank-maxrank CP tensor regression model, 5 by default. Suggested adjustment ranges: 3~8

link : 'normal', 'binomial' or 'poisson'

pic_name : used for generating simulation data, and 6 different images are provided. If using other data, please ignore it.

Note:
One can obtain results under different experimental settings by changing various parameters, including 'n', 'sigma', 'fold', 'maxrank', 'link', 'pic' in the 'parameter setting' part of 'simulation_demo.m'. 

-------------------------------------------------------------------------------
Real data example

Since the real data takes up a lot of storage, the raw data is not included and can be download at https://www.isic-archive.com/ and https://fcon_1000.projects.nitrc.org/indi/adhd200/. At the same time, we provide a script to import the real data:

*load_real_data.m
Load the real data into matlab, including skin cancer data and ADHD data. 

Data description for real data after loading by load_real_data.m'
M: main 3-D tensor, e.g., skin cancer image or the brain MRI image
y: 1-D resposnse variable, 1 for benign, 0 for malignant in skin cancer data
   and 1 for ADHD patient, 0 for normal patient
X: covirates, including age, gender, hand and intercept in ADHD data and onlt intercept in skin cancer data.

Since the naming rule for tensors and response variables are the same (‘M’ and ‘y’) in both the simulation experiments and the actual data, one only needs to replace generate 2-D simulation data by ‘load_real_data.m’ to conduct real data experiments.

