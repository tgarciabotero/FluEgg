# Fluvial Egg Drift Simulator (FluEgg)
A three-dimensional Lagrangian model capable of evaluating the influence of flow velocity, shear dispersion and turbulent diffusion on the transport and dispersal patterns of Asian carp eggs is presented. The model’s variables include not only biological behavior (growth rate, density changes) but also the physical characteristics of the flow field, such as mean velocities and eddy diffusivities.
# Code Structure
The Graphical User Inter Interface (GUI) code for the FluEgg is FluEgg.m and FluEgg.fig. 
The Main function of FluEgg is called FluEgggui, this function uses the Jump function, in this function particles move (jump) every time step following the random walk and random displacement approach
.

# Motivation
The transport of Asian carp eggs and fish in the early stages of development is very important on their life history and recruitment success. A better understanding of the transport and dispersal patterns of Asian carp at early life stages might give insight into the development and implementation of control strategies for Asian carp.

The FluEgg model was developed to evaluate the influence of flow velocity, shear dispersion and turbulent diffusion on the transport and dispersal patterns of Asian carp eggs. FluEgg output includes the three-dimensional location of the eggs at each time
step together with its growth stage. The output results can be used to estimate lateral, longitudinal or vertical egg distribution. In addition, it can be used to generate an egg breakthrough curve (egg concentration as a function of time) at a certain downstream location from the virtual spawning location. Egg breakthrough curves are important for understanding egg dispersion and travel times.
Egg vertical concentration distribution might give insights into egg suspension and settlement. Egg longitudinal concentration distributions can be used to estimate the streamwise and shear velocity, and minimum river length required for successful egg development. 

Egg lateral distributions give information about dead zones, provided the input hydraulic data for the model is sufficiently well
described. The location of suitable spawning grounds can be predicted based on the egg growth stage and on the vertical, lateral
or longitudinal egg concentration distributions.
The FluEgg model has the capability to predict the drifting behavior of eggs based on the physical properties of the eggs and
the environmental and hydrodynamic characteristics of the stream where the eggs are drifting.
A complete description of the FluEgg model was presented by Garcia et al. (2013); users can refer to this paper for detailed information on both the mathematical model and the performance of the model.

#References
Garcia, T., Jackson, P.R.,Murphy, E.A., Valocchi, A.J., Garcia, M.H., 2013. Development of a Fluvial Egg Drift Simulator to evaluate the transport and dispersion of Asian carp eggs in rivers. Ecol. Model. 263, 211–222

# Installation
The FluEgg model iswritten in the MATLAB® programming language (Mathworks, Natick, MA,USA). It requires the statistics and image processing toolboxes.

==============================================================================
FluEgg Release License
==============================================================================
University of Illinois/NCSA Open Source License

Copyright (c) 2011-2014 University of Illinois at Urbana-Champaign
All rights reserved.

Developed by: 		Tatiana Garcia
                    Ven Te Chow Hydrosystems Laboratory, Department of Civil and Environmental Engineering at University of Illinois at Urbana-Champaign
                    http://vtchl.illinois.edu
					
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal with the
Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the 
Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

-Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimers.
-Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimers in the documentation and/or other 
 materials provided with the distribution.
-Neither the names of Tatiana Garcia, Ven Te Chow Hydrosystems Laboratory, Department of Civil and Environmental Engineering at University of Illinois at 
 Urbana-Champaign, nor the names of its contributors may be used to endorse or promote products derived from this Software without specific prior written 
 permission.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A 
PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE CONTRIBUTORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN 
ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS WITH THE SOFTWARE.

==============================================================================
Copyrights and Licenses for Third Party Software Distributed with FluEgg:
==============================================================================
The FluEgg software contains code written by third parties.  Such software will
have its own individual LICENSE.TXT file in the directory in which it appears.
This file will describe the copyrights, license, and restrictions which apply
to that code.

The disclaimer of warranty in the University of Illinois/NCSA Open Source License
applies to all code in the FluEgg Distribution, and nothing in any of the
other licenses gives permission to use the names of Tatiana Garcia, Ven Te Chow Hydrosystems Laboratory, Department of Civil and Environmental Engineering at 
University of Illinois at Urbana-Champaign or the University of Illinois to endorse or promote products derived from this
Software.

The following pieces of software have additional or alternate copyrights,
licenses, and/or restrictions:

Program/Function     Developer      Directory
----------------     ---------      ---------
voxel.m              Suresh Joel    FluEggRepo\voxel.m  
cells.m              Suresh Joel    FluEggRepo\voxel.m  
