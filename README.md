# dGEMRIC-MRI-Data-Analysis
- Main_T2Calculation.mat generates T2 maps were obtained in-line using a pixel-wise, non-negative, mono-exponential curve fitting with Levenberg-Marquardt nonlinear least squares algorithm (fittype) discarding the first echo. The algorithm is thought to work with MRI images produced using Spin Echo sequence (4 echos). Fitting is performed by the function createFit_T2.mat

- Main_T1Calculation.mat generates Voxel-based T1 maps for dGEMRIC index. The algorithm is thought to work with MRI images produced using a 3D Flash variable flip angle pulse sequence.
