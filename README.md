# 2-D Acoustic FDTD Simulation Demo for Matlab


## Outline

This is a truly physical simulation program of the sound wave propagation in a two-dimensional field filled with fluid media surrounded by total reflecting walls.  
This program solves the equations of the "2D Acoustic FDTD (finite-difference time-domain) method". This may be one of the simplest but the slowest program of the FDTD method. The field consists of air (332 m/s). The grid resolution is 10 mm/pixel and the time step is 20 us/step (us = micro second = 1/1000000 second). A single pulse of sinusoidal sound wave at 1 kHz with Hann window is transmitted.  
Have fun!!

### acoustic_2d_fdtd_homogeneous_bench.m
A benchmark using normal matrix calculations.

### acoustic_2d_fdtd_homogeneous_bench_for.m
The calculations are written by `for` loop instead of matrix expressions.

### acoustic_2d_fdtd_homogeneous_bench_parfor.m
Parallel version. The calculations are written by `parfor` loop so that the loops will be parallelized. This script requires the Parallel Computing Toolbox.

### acoustic_2d_fdtd_homogeneous_bench_gpu.m
GPU version. The calculations are written for using GPU. This script requires the Parallel Computing Toolbox and a GPU device in your computer.



## Technical Notes
These programs have been tested on Matlab R2016b.  
For more detailed information about FDTD method (including 3-D elastic simulation), please refer our papers on simulation. ==> https://ultrasonics.jp/nagatani/fdtd/  
Thank you.



## License

Contents are licensed under [CC-BY-SA 3.0](http://creativecommons.org/licenses/by-sa/3.0/) (Creative Commons Attribution-ShareAlike 3.0 Unported License).  
The users of this software are asked to state the description **Yoshiki NAGATANI : ultrasonics.jp/nagatani/fdtd/** on their publications.


***


Yoshiki NAGATANI, Kobe City College of Technology  
https://ultrasonics.jp/nagatani/fdtd/  
https://twitter.com/nagataniyoshiki
