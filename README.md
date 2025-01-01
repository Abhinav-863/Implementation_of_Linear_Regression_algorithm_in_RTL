# Implementation-of-Linear-Regression-algorithm-in-RTL

This project implements a linear regression algorithm in RTL. The design includes modules for both parameter estimation and prediction. The project uses Verilog to demonstrate the algorithm's functionality and can be used as an educational resource for learning RTL-based design for machine learning algorithms.

#Overview
Linear regression is a fundamental algorithm used in machine learning for predictive analysis. This project presents a hardware implementation of linear regression in Verilog.

The implementation is divided into two modules:
Parameter Estimation (linear_regression_estimation): Computes the slope (theta1) and intercept (theta0) of the regression line based on input data.
Prediction (linear_regression_prediction): Predicts output values based on estimated parameters.
#
Modules
1. linear_regression_estimation
This module calculates the parameters theta0 (intercept) and theta1 (slope) of the regression line using the input datasets (x_values and z_values).
Key Features:
Handles data accumulation and matrix calculations.
Computes parameters through division sub-modules.
Validates output with control signals.
2. linear_regression_prediction
This module takes the estimated parameters and predicts output values for new inputs.
Key Features:
Computes predictions based on the formula:
Prediction = theta1 * x + theta0
Provides a validation signal when predictions are available.
