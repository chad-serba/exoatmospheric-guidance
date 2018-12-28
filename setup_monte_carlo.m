%% monte_carlo.m
% Sets up and executes a monte carlo guidance simulation

clear all
close all
clc

addpath(genpath('matlab'))

% define the targeted orbit 
target.a = 10000 * 1000; % m 
target.i = 0;
target.e = 0.0001;
target.w = 35;

% define the initial conditions 
initial.pos = [8276; 5612; 5]*1000; % position in meters
initial.vel = [-3.142; 4.672; 0]*1000; % velocity in meters/s
initial.time = 0; % starting time in seconds

% define the initial guidance guess
guid_guess.A = [0 1 0];
guid_guess.B = [0 0 0];
guid_guess.tf = 23;
    
% define the vehicle and its dispersions
vehicle_options = 'setup_draws.m';

% define how many monte carlo iterations to run
num_runs = 2000;

% define output parameters
outputs.folder = 'monte_carlo_outputs';
outputs.prefix = 'project';

% start the monte carlo
tic;
monte_carlo( target, initial, guid_guess, vehicle_options, num_runs, outputs )
total_runtime = toc;
fprintf('\nTotal Run Time was %3.3f seconds.\n', total_runtime)

