# dumpToVTK

This is a bash script that converts LIGGGHTS dump files to vtk for visualization in Paraview. Useful for large files as it is two times faster than LPP.

- Works only with dump files that contain particle info for one timestep
- Dump info should be written in following order (default in LIGGGHTS tutorials): id type x y z ix iy iz vx vy vz fx fy fz omegax omegay omegaz radius 

Usage:
dumpToVTK.sh dump*
