#Fluvial Egg Drift Simulator (FluEgg)
A three-dimensional Lagrangian model capable of evaluating the influence of flow velocity, shear dispersion and turbulent diffusion on the transport and dispersal patterns of Asian carp eggs is presented. The model’s variables include not only biological behavior (growth rate, density changes) but also the physical characteristics of the flow field, such as mean velocities and eddy diffusivities.

#Code Structure
The Graphical User Inter Interface (GUI) code for the FluEgg is FluEgg.m and FluEgg.fig. The Main function of FluEgg is called FluEgggui.

#Motivation
The transport of Asian carp eggs and fish in the early stages of development is very important on their life history and recruitment success. A better understanding of the transport and dispersal patterns of Asian carp at early life stages might give insight into the development and implementation of control strategies for Asian carp.

The FluEgg model was developed to evaluate the influence of flow velocity, shear dispersion and turbulent diffusion on the transport and dispersal patterns of Asian carp eggs. FluEgg output includes the three-dimensional location of the eggs at each time step together with its growth stage. The output results can be used to estimate lateral, longitudinal or vertical egg distribution. In addition, it can be used to generate an egg breakthrough curve (egg concentration as a function of time) at a certain downstream location from the virtual spawning location. Egg breakthrough curves are important for understanding egg dispersion and travel times. Egg vertical concentration distribution might give insights into egg suspension and settlement. Egg longitudinal concentration distributions can be used to estimate the streamwise and shear velocity, and minimum river length required for successful egg development.

Egg lateral distributions give information about dead zones, provided the input hydraulic data for the model is sufficiently well described. The location of suitable spawning grounds can be predicted based on the egg growth stage and on the vertical, lateral or longitudinal egg concentration distributions. The FluEgg model has the capability to predict the drifting behavior of eggs based on the physical properties of the eggs and the environmental and hydrodynamic characteristics of the stream where the eggs are drifting. A complete description of the FluEgg model was presented by Garcia et al. (2013); users can refer to this paper for detailed information on both the mathematical model and the performance of the model.

#References
Garcia, T., Jackson, P.R.,Murphy, E.A., Valocchi, A.J., Garcia, M.H., 2013. Development of a Fluvial Egg Drift Simulator to evaluate the transport and dispersion of Asian carp eggs in rivers. Ecol. Model. 263, 211–222

#Installation
The FluEgg model iswritten in the MATLAB® programming language (Mathworks, Natick, MA,USA). It requires the statistics and image processing toolboxes.

#FluEgg Release License
Copyright (c) 2016 Tatiana Garcia All rights reserved.

Developed by: Tatiana Garcia Research Hydrologist U.S. Geological Survey

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

Neither the name of the {organization} nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#DISCLAIMER
Unless otherwise noted below, this software is in the public domain because it contains materials that originally came from the United States Geological Survey, an agency of the United States Department of Interior. For more information, see the official USGS copyright policy at:

http://www.usgs.gov/visual-id/credit_usgs.html#copyright

Although this software program has been used by the USGS, no warranty, expressed or implied, is made by the USGS or the U.S. Government as to the accuracy and functioning of the program and related program material nor shall the fact of distribution constitute any such warranty, and no responsibility is assumed by the USGS in connection therewith.

This software is provided "AS IS."

Attributions and Licences: References to or use of non-U.S. Department of the Interior (DOI) products does not constitute an endorsement by the DOI.

This information is preliminary or provisional and is subject to revision. It is being provided to meet the need for timely best science. The information has not received final approval by the USGS and is provided on the condition that neither the USGS nor the U.S. Government shall be held liable for any damages resulting from the authorized or unauthorized use of the information.

Copyrights and Licenses for Third Party Software Distributed with LARVEL:
The FluEgg program contains code written by third parties. Such software will have its own individual LICENSE.TXT file in the directory in which it appears. This file will describe the copyrights, license, and restrictions which apply to that code.

The disclaimer of warranty in thid Open Source License applies to all code in the FluEgg Distribution, and nothing in any of the other licenses gives permission to use the names of Tatiana Garcia, U.S Geological Survey to endorse or promote products derived from this Software.

The following pieces of software have additional or alternate copyrights, licenses, and/or restrictions:

Program/Function Developer Directory

FluEgg 1.3 Tatiana Garcia, University of Illinois FluEgg_Git_Repo\license_FluEgg_1.3.txt voxel.m Suresh Joel FluEgg_Git_Repo\voxel.m
cells.m Suresh Joel FluEgg_Git_Repo\voxel.m
dlmcell Roland Pfister FluEgg_Git_Repo\dlmcell.m
parseArgs.m Aslak Grinsted FluEgg_Git_Repo\parseArgs.m
subaxis.m Aslak Grinsted FluEgg_Git_Repo\subaxis.m