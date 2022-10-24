%% TEST
clear 
close all
clc

% per divertirvi basta cambiare il nome del dataset :)

dataset = 'B-n39-k5.txt';

% extract data from dataset
[vehicles, optimal_value, dimension, capacity, coords, demand] = ...
    extract_dataset(dataset);

%% SWEEP
S_sweep = sweep(vehicles, dimension, capacity, coords, demand);
err_sweep = get_cost_solution(S_sweep, coords) - optimal_value;

% isfeasible(S_sweep, demand, capacity)

% plot_solution(S_sweep, coords)

%% TABU SEARCH

N_max = 20;
alpha_max = 10;
M = 2;
P = 2;
beta_max = 10;
theta_min = 5;
theta_max = 10;

S_tabu = tabu(S_sweep, coords, demand, capacity, N_max, alpha_max, ...
    M, P, beta_max, theta_min, theta_max);
err_tabu = get_cost_solution(S_tabu,coords) - optimal_value;

% isfeasible(S_tabu, demand, capacity)
% plot_solution(S_tabu, coords)
