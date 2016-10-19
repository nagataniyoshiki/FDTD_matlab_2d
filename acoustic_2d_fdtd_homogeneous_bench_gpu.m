% 2-D Acoustic FDTD Simulation Demo for Matlab (rev. Nov. 9th, 2014 / Oct. 19th, 2016)
%    by Yoshiki NAGATANI
%      https://ultrasonics.jp/nagatani/e/
%      https://twitter.com/nagataniyoshiki
%      https://github.com/nagataniyoshiki/
% 
%   This is a truly physical simulation program of the sound wave propagation
%   in a two-dimensional field filled with fluid media surrounded by total
%   reflecting walls.
% 
%   This program solves the equations of the "2D Acoustic FDTD (finite-difference
%   time-domain) method".
%   The field consists of air (332 m/s). The grid resolution is 10 mm/pixel
%   and the time step is 20 us/step (us = micro second = 1/1000000 second). 
%   A single pulse of sinusoidal sound wave at 1 kHz with Hann window is transmitted.
% 
%   For more detailed information about FDTD method (including 3-D elastic simulation),
%   please refer our papers on simulation. ==> https://ultrasonics.jp/nagatani/fdtd/
%   Thank you.

dx = 0.01;						% Spatical Resolution [m]
dt = 20.0e-6;					% Temporal Resolution [s]

rho = 1.3;						% Density [kg/m^3]
kappa = 142.0e3;				% Volume Elasticily (Bulk modulus) [Pa] */

freq = 1.0e3;					% Frequency of Initial Waveform [Hz]

NX = 1000;						% Spatial Size for X direction [pixels]
NY = 2000;						% Spatial Size for Y direction [pixels]

Vx = zeros(NX+1,NY  );			% Particle Velocity for X direction [m/s]
Vy = zeros(NX,  NY+1);			% Particle Velocity for Y direction [m/s]
P  = zeros(NX,  NY  );			% Sound Pressure [Pa]

% Window Preparation
h = figure();
drawnow;
image_intensity = 5000;			% Brightness of Acoustic Field (>0)
image_step = 100;				% Step for Showing Screenshots

% for efficient calculation
dt_over_rho_x_dx = dt / (rho * dx);
kappa_x_dt_over_dx = kappa * dt / dx;

% Transfer Arrays to the GPU
GPU_Vx = gpuArray(Vx);
GPU_Vy = gpuArray(Vy);
GPU_P = gpuArray(P);
GPU_dt_over_rho_x_dx = gpuArray(dt_over_rho_x_dx);
GPU_kappa_x_dt_over_dx = gpuArray(kappa_x_dt_over_dx);

n = 0;
disp('Calculation started.')
tic

% Main Loop %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while true,
	% Update Particle Velocities
	GPU_Vx(2:NX,:) = GPU_Vx(2:NX,:) - GPU_dt_over_rho_x_dx * ( GPU_P(2:NX,:) - GPU_P(1:NX-1,:) );
	GPU_Vy(:,2:NY) = GPU_Vy(:,2:NY) - GPU_dt_over_rho_x_dx * ( GPU_P(:,2:NY) - GPU_P(:,1:NY-1) );

	% Update Sound Pressures
	GPU_P(1:NX,1:NY) = GPU_P(1:NX,1:NY) - GPU_kappa_x_dt_over_dx * ( ( GPU_Vx(2:NX+1,:) - GPU_Vx(1:NX,:) ) + ( GPU_Vy(:,2:NY+1) - GPU_Vy(:,1:NY) ) );

	% Initial Waveform from a Point Source (1 pulse of sinusoidal wave with Hann window)
	if n < (1.0/freq)/dt,
		GPU_P(floor(NX/4+1),floor(NY/3+1)) = GPU_P(floor(NX/4+1),floor(NY/3+1)) + (1.0-cos(2.0*pi*freq*n*dt))/2.0 * sin(2.0*pi*freq*n*dt);
	end
	n = n + 1;

	if mod(n,image_step) == 0
		toc
		image( GPU_P*image_intensity+32 );
		axis equal; axis tight;
		title(['step: ' sprintf('%5d',n) '   (' sprintf('%6.2f',n*dt*1000) ' ms)']);
		drawnow;
		tic
	end

end
