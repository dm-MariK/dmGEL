# INTRO #

This software is a quantitative calculator of an individual protein amount in an electrophoretic gel. The program is a "software densitometer" for scanned gels. It calculates the integral color intensity of a protein band in a gel.

To use it, several comparison samples with precisely known different amounts of reference protein must be present in the gel in parallel with the under-study samples. After staining the proteins in the gel, the integral intensity of each protein band of the comparison samples should be measured and a calibration plot should be constructed by regression analysis. Then, using this graph, determine the amount of protein in the under-study sample by the value of its stain intensity obtained with the help of this program.

In general case, the main problems of the approach described above are: 
1.  Failure in practice to completely wash the gel of an excess of staining dye, which results in a non-zero background intensity value (while the protein content is zero, the intensity is always greater than zero);
2.  Failure in practice to wash the gel uniformly, so that in different areas of the gel the excess of staining dye will be different, and as a consequence the zero amount of protein in different areas of the gel will correspond to different intensity values.
As a result, this leads to a significant decrease in the range of protein concentrations where the regression plot is linear, or even to the absence of the linear range. And this leads to a serious decrease in the accuracy of determination of the amount of protein.

In other words, we have the so-called "background subtraction problem" or "baseline problem".

This software uses a unique and innovative approach to solve this "background subtraction problem". By this approach application, the resulting integral intensity values (`I`) depend linearly on the amount of protein (`C`) over a very large range of concentrations: from practically zero to a slightly protein-overloaded lanes on the gel. Moreover, this linear dependence is almost a direct proportionality: 
```
I = k*C + b
``` 
where `b` is very close to zero. (But still slightly larger, because of the peculiarities of digital image representation. A pixel's intensity value cannot be negative. So even after near-perfect noise filtering and a maximum-quality background subtraction, there is still a small positive value.)

Although the algorithm was originally invented and used for quantitative analysis of SDS-PAGE (sodium dodecyl sulfate - polyacrylamide gel electrophoresis by Ulrich K. Laemmli) stained with Coomassie, there is no reason to believe that it will not also be effective for other staining methods, other separation methods (native electrophoresis, isoelectrofocusing, etc., etc.) as well as for DNA gel electrophoresis. Experts are invited to test!

# INSTALLATION #

## Dependencies ##

This software is a set of MATLAB scripts. It requires the MATLAB environment and __Image Processing Toolbox__.

All development and testing was done in MATLAB __R2022b__, and this is the version I recommend to use.

I tried to make the code as backward compatible as possible, at least ~~up~~ down to MATLAB __R2016b__. However, I didn't have a chance to test it.

As for versions _newer_ than __R2022b__, problems may arise due to the fact that one of the classes in this project (`dmGEL.roiPolygon`) inherits a class from the _undocumented_ part of the Image Processing Toolbox code base (`impoly` class), the logic of which can be changed by MATLAB developers without warning. However, the actual code of the `impoly` class has not been changed since 2018 (as of release __R2022b__).

## Installation steps ##

1.  Download the package somewhere on your system. Say, to 
```
C:\Users\<YOURUSERNAME>\Documents\Matlab_Scripts\  # on MS Windows, or
/home/<YOURUSERNAME>/Matlab_Scripts/               # on GNU/Linux
```
so that you will get the directory
```
C:\Users\<YOURUSERNAME>\Documents\Matlab_Scripts\dmGEL\  # on MS Windows, or
/home/<YOURUSERNAME>/Matlab_Scripts/dmGEL/               # on GNU/Linux
```
with the contents of the package.

__NOTE:__ If you are familiar with git, use `git clone` to download the project's code. Due to the project is still under development, git usage will help you being kept up to date.

2.  Then, update the content of your `startup.m` file. Append to its end the following:
  * on MS Windows: `addpath(genpath('C:\Users\<YOURUSERNAME>\Documents\Matlab_Scripts\dmGEL'));`
  * on GNU/Linux:  `addpath(genpath('/home/<YOURUSERNAME>/Matlab_Scripts/dmGEL'));`
  
__NOTE:__ _Use here the paths from step (1)!_
  
If you do not have `startup.m` file, just create it with the content:
```
function startup
```
and then append the above content depending on your OS.

__NOTE:__ typical `startup.m` file location:
  * on MS Windows: `C:\Users\<YOURUSERNAME>\Documents\MATLAB\startup.m`
  * on GNU/Linux:  `/home/<YOURUSERNAME>/startup.m`
  
3.  Restart the MATLAB environment by closing its main window or typing `exit` on its command prompt.

4.  To start the software toll just print on the MATLAB command prompt (CaSe SENsiTIve !!!):
```
dmGELQUANTtool
```
and press enter.
Now you can use the gel quantification utility.

# USAGE #

## General Information ##

The process of digitizing electrophoretic gels includes the following steps.
1.  __Loading__ the image of the scanned gel. It is possible to load from a file or from MATLAB's Workspace Variable.
2.  __Converting__ the image __to grayscale__ - happens automatically when loading.
3.  If necessary - __inversion__ of the image color: the gel should look like light bands of proteins on a dark background. This should be done manually if required.
4.  __Noise filtering__. This is also done manually. It is possible to sequentially apply several filters to the image. The number of such filters is not limited.
5.  __Background correction__, the highlighted above "background subtraction", or "baseline correction". For this purpose it is necessary to select the largest protein band, or an arbitrary area on the gel, which is of the same width as the widest protein band, and of the same height as the highest one. Then from the context menu of the selection area call "Use to Calc. BG".
6.  Now we have an image of the gel with the background subtracted. To obtain the integral intensity value, simply select the protein band of interest and call "Get Intensity" from the context menu of the selection area.

## Important Notes ##

1.  Use ONLY gel scans obtained with a regular flatbed scanner without automatic post-processing. Or use a specialized gel documentation system.
__Do not use__ gel images obtained with smartphone cameras and similar devices. These cameras use AI elements to "improve" the resulting image. Faded areas are made brighter, and too bright areas are made more faded. All these are non-linear transformations, which are also essentially unpredictable: they depend on the model and manufacturer of the smartphone and its firmware version, and are also a trade secret.
2.  To plot the calibration regression graph, _always_ use __the same__ gel on which you separate the proteins whose amount you need to know. Since in practice it is impossible to perfectly control the degree of washing of the gel from an excess of staining dye, the slope of the regression graph may differ for two different gels. Which will lead to a significant error in the region of high protein amounts if you use a separate gel to construct the calibration graph.
3.  Use at least 5 points with known amounts of protein (not including zero) to construct the regression plot.
4.  Since the staining efficiency of a protein in a gel depends on its nature, e.g., amino acid composition, molecular weight, presence of prosthetic groups, the reference protein used for gel calibration and the protein under study must be identical. Otherwise, the difference between the true and the obtained amount may differ by several times.
5.  If possible, thoroughly wash the gel from an excess of staining dye. No algorithm will "digest" poorly washed gels. Shit in - shit out!

## Detailed textual instruction ##
Coming soon!

## Video manual ##
Coming soon!

# COPYRIGHT #

This software project is Copyright (c) 2025 by Denis I. Markov aka MariK

< dm DOT marik DOT 230185 AT gmail DOT com >
< t DOT me / dm_MariK >

This work is licensed under the Creative Commons Attribution-ShareAlike 4.0 International License.
