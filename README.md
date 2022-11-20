# SunflowerSat
SunflowerSat is a 2U CubeSat mission designed within the Space Systems course at the University of Naples Federico II.

## Mission Objective
SunflowerSat's mission is a technology demonstration of a compact 2-DOF sun-tracking deployable  mechanism solar array to increase power output for implementation in future CubeSat missions.

## Mission Analysis
Because of the flexible nature of the payload (the 2-DOF solar array drive mechanism), the orbit chosen for the mission is an ISS-like orbit, convinient because it allows a regular deployment from the International Space Station with the NanoRacks deployer. The orbital parameters are reported in the following table.

| Parameter      | Value |
| ----------- | ----------- |
| Altitude      | 410 km       |
| Inclination   | 51.6°       |
| Eccentricity   | 0 (Circular)       |

## What's in the repository
The repository includes files for different phases of mission design and subsystem selection:
- Solar array power output analysis
- Mission lifetime and orbit decay
- Power requirement for 2-DOF solar array mechanism & sizing of the motors

### GMAT
The GMAT script *Sunflower.script* contains the orbital analysis of the CubeSat mission. The outputs are:
- An orbit view
- A ground track
- A report including the time in A1ModJulian (linear) and the altitude in km
- An XY plot of the altitude (in km) over time (in A1ModJulian)
- A report including the time in A1ModJulian (linear) and the X, Y, and Z coordinates of the Spacecraft in the EarthMJ2000 coordinate system
- A report including the time in A1ModJulian (linear) and the X, Y, and Z coordinates of the Sun in the EarthMJ2000 coordinate system
These outputs have then been imported in matlab and saved as the variables `altitude.mat`, `time.mat`, `spacecraft.mat`, and `sun.mat`.

The script has been run two times:
1. Propagating the orbit for 40 days to have an estimation of the orbit decay.
2. Propagating the orbit for 4 days to obtain the coordinates of the spacecraft and sun and estimate the angle between the nadir direction and the Sun direction.

### MATLAB
The MATLAB scripts use the outputs of the GMAT simulation to estimate and visualize some fundamental information for the mission design.
1. `dragarea.m` is a script which uses the spacecraft and Sun X, Y, and Z coordinates to estimate the angle `alpha` between the nadir direction and the Sun direction and uses that information to estimate the mean drag area of the spacecraft to then iteratively input in GMAT though the command `DA = 0.02 + 0.09*abs(cos(alpha))`, where 0.02 is the area of the face of the CubeSat facing the velocity direction and 0.09 is the area of the solar panels to project onto the plane orthogonal to the velocity vector.
2. `decay.m` estimates the decay by using the `altitude.mat` output from the GMAT simulation and calculating the decay per day. This number is then used to calculate an approximated number of days before the spacecraft reaches an altitude of 250 km, which can be seen as the mission lifetime as the CubeSat quickly reenters
the atmosphere from that moment on.
3. `poweroutput.m` uses the same method implemented in `dragarea.m` to calculate `alpha` to estimate the power output of the solar array in both a moving (SunflowerSat's solution) and a fixed (traditional solution) configuration. When estimating the power in the case of a moving configuration, the angle `theta` was introduced as the angle formed by the othogonal to the solar panels and the Sun direction. This angle is zero when the angle alpha between nadir and the Sun direction is less than pi/2 (the mechanism is able to track the Sun and has 90° range of movement), and `alpha - pi/2` otherwise. For the fixed configuration `alpha` was used as long as it was less than pi/2, while for larger values the power output has been imposed as zero since the solar rays would be behind the solar panel.
4. `efficiency.m` is a function that estimates through an iterative process the efficiency of the solar cells taking into account the effect of the temperature.
It's inputs are the two angles `ni` and `alpha`, angles between the nadir direction and the panel and between the panel and the Sun direction respectively, `eta0`, the efficiency at the reference temperature of 28°C, and the panel area.
5. `angularvelocity.mat` calculates the angle of inclination of the solar panels and angular velocity for a single orbit in sunlight conditions to be used as an input for the Working Model 2D model of the mechanism.
6. `wcs.m` has the same function as `angularvelocity.m` but for eclipse conditions. During eclipse, the panel is brought back to resting condition (0°  inclination in respect to Nadir direction) in order to reduce drag. To do so, it has been supposed it follows three phases: first it will accelerate with constant acceleration, then continue with constant velocity, and finally decelerate with a constant deceleration equal in magnitude as the acceleration of the first phase. Two options were investigated: maneuver performed in 2 minutes with 30/60/30 seconds phases; maneuver performed in 5 minutes with 100/100/100 seconds phases.







