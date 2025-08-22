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
```matlab
function startup
```
and then append the above content depending on your OS.

__NOTE:__ typical `startup.m` file location:
  * on MS Windows: `C:\Users\<YOURUSERNAME>\Documents\MATLAB\startup.m`
  * on GNU/Linux:  `/home/<YOURUSERNAME>/startup.m`
  
3.  Restart the MATLAB environment by closing its main window or typing `exit` on its command prompt.

4.  To start the software toll just print on the MATLAB command prompt (CaSe SENsiTIve !!!):
```matlab
dmGELQUANTtool
```
and press enter.
Now you can use the gel quantification utility.

# USAGE #

## Important Notes ##

1.  Use ONLY gel scans obtained with a regular flatbed scanner without automatic post-processing. Or use a specialized gel documentation system.
__Do not use__ gel images obtained with smartphone cameras and similar devices. These cameras use AI elements to "improve" the resulting image. Faded areas are made brighter, and too bright areas are made more faded. All these are non-linear transformations, which are also essentially unpredictable: they depend on the model and manufacturer of the smartphone and its firmware version, and are also a trade secret.
2.  To plot the calibration regression graph, _always_ use __the same__ gel on which you separate the proteins whose amount you need to know. Since in practice it is impossible to perfectly control the degree of washing of the gel from an excess of staining dye, the slope of the regression graph may differ for two different gels. Which will lead to a significant error in the region of high protein amounts if you use a separate gel to construct the calibration graph.
3.  Use at least 5 points with known amounts of protein (not including zero) to construct the regression plot.
4.  Since the staining efficiency of a protein in a gel depends on its nature, e.g., amino acid composition, molecular weight, presence of prosthetic groups, the reference protein used for gel calibration and the protein under study must be identical. Otherwise, the difference between the true and the obtained amount may differ by several times.
5.  If possible, thoroughly wash the gel from an excess of staining dye. No algorithm will "digest" poorly washed gels. Shit in - shit out!

## General Information ##

The process of digitizing electrophoretic gels includes the following steps.
1.  __Loading__ the image of the scanned gel. It is possible to load from a file or from MATLAB's Workspace Variable.
2.  __Converting__ the image __to grayscale__ - happens automatically when loading.
3.  If necessary - __inversion__ of the image color: the gel should look like light bands of proteins on a dark background. This should be done manually if required.
4.  __Noise filtering__. This is also done manually. It is possible to sequentially apply several filters to the image. The number of such filters is not limited.
5.  __Background correction__, the highlighted above "background subtraction", or "baseline correction". For this purpose it is necessary to select the largest protein band, or an arbitrary area on the gel, which is of the same width as the widest protein band, and of the same height as the highest one. Then from the context menu of the selection area call "Use to Calc. BG".
6.  Now we have an image of the gel with the background subtracted. To obtain the integral intensity value, simply select the protein band of interest and call "Get Intensity" from the context menu of the selection area.

## Video manual ##

1.  [Start the app, import an image, filter noise and subtract background.](https://youtu.be/qlfJDAY_WXg)
2.  [Select bands. Work with selections and scale.](https://youtu.be/NO0OGnvodNM)
3.  [Acquire intensity values for bands. Image Intensity Profiles charts.](https://youtu.be/BJMrR1VZjQQ)
4.  [Automatic collection of intensity values to a file.](https://youtu.be/jEtwZPVGz4o)
5.  [Review of all main menus of the program's main window.](https://youtu.be/fuhIV-UJruU)

[All the videos in one playlist](https://www.youtube.com/playlist?list=PLCxqIo67mH3mG5xgmzamDVwWHOF4hnceS)


## Detailed textual instruction ##

### Starting the program, importing an image ###

To start the software, print on the MATLAB command prompt (CaSe SENsiTIve !!!): 
```matlab
dmGELQUANTtool
``` 
and then press enter.
The main window of the program appears. It is recommended to expand the window.

To import an image, go to `File` main menu, then to `Import Image` sub-menu. The last contains two items that correspond to 2 options to import a gel image to the program:
1.  From file;
2.  From MATLAB Workspace variable.

The first choice is 'trivial'. It should be used if a scanned gel image is saved to a file. By choosing this option, the 'File Selection' Dialog Window appears. Just navigate to the image file, select it and press `Open`.

The second one is useful if an image has been partially pre-processed by some other MATLAB tools outside of this program and now is stored in some workspace variable. Choosing the second option opens the dialog window where all current workspace variables are listed. Select one of them and confirm the choice.

Anyway, selected gel image appears at the program's main panel. It is now imported to the program and already converted to gray-scale.

As it was mentioned earlier, the image processing includes a few steps. At each step the result is preserved and could be displayed at the program's main panel. A "special kind" of image corresponds to each step. There are the following "kinds" of image to be displayed:
*  `Original Image` — the original image as it exists in the source file (or workspace variable);
*  `GrayScaled Image` — the gray-scale image after applying corresponding conversion;
*  `Filtered Image` — the image after the Noise filtering;
*  `Calculated BackGround` is the image background to be subtracted;
*  `BGCorrected Image` — the background-corrected image, result of background subtraction from the `Filtered` image.

To select what "kind" of image to display, go to `View` main menu and set a check-mark next to the desired "kind".

At this stage `GrayScaled Image` and `Original Image` are only available to be selected. And `GrayScaled Image` is selected to be shown.
While `Filtered Image`, `Calculated BackGround` and `BGCorrected Image` items are inactive. It is due to the corresponding steps of the image processing have not yet been passed at this stage.


### Color inversion ###

According to instruction the gel should look like light proteins' bands on a dark background.
If now the gel image looks like dark proteins' bands on a light background, you must do the color inversion.
To do that, go to `Image` main menu and select `Invert Colors` item. The color inversion is applied to `GrayScaled Image` and the result will be immediately displayed. Now the gel image is ready to further steps.


### Filtering the noise ###

Go to `Image` main menu and select `Filter Noise` item. 'Filter Noise' Dialog Window appears. There are several options available. 
The idea is that you can apply as many filters as you want. One above the other, i.e. filter the result of a previous filtration.
Also here you can discard the result of previous filtration\[s\]; rewrite it by applying a filter to "original" (`GrayScaled`) image.
Also there is an option to delete or preserve the calculated image background (If it has been already calculated.).

At this step, it is the first image noise filtration and the background is not calculated yet. Thus, it means nothing which set of the options to choose or just to leave them as is. Press `Apply` to finally apply noise filtration.

Now the `Filtered Image` is automatically selected to be shown. And the corresponding `View` main menu item becomes active.


### Background correction ###

To calculate and subtract Background you should select the largest protein band. If there is no such a band, select any arbitrary area on the gel, which is of the same width as the widest protein band, and of the same height as the highest one.

To select a band (or any other arbitrary area on the gel image) go to `New Selection` main menu and click `New Selection` item. You can also achieve this by pressing `Alt + S` combination followed by the same `Alt + S` one more time. Mouse cursor will change it form. Use left mouse clicks to add vertices of polygonal selection. Use double left mouse click or press `Enter` to finish making selection.

Call the context menu of the selected area by right mouse click on it, and select `Use to Calc. BG` item from that context menu. Background correction is being applied.

Now the `BGCorrected Image` is automatically selected to be shown. And the last 2 `View` main menu items becomes active.


### Working with Selections ###

Each Selection (or Selected Area) is represented as closed polygon with arbitrary number of vertices. Selection as a whole and each of its vertices, — all have got their own context menus, that could be evoked by right mouse click on the corresponding object. You can simultaneously keep as much Selections as you want.

To create a new Selection just press `Alt + S` combination followed by the same `Alt + S` one more time. Or you also can achieve this by going to `New Selection` main menu and then clicking `New Selection` item. Then select the area. Use left mouse clicks to add vertices of polygonal selection. Use double left mouse click or press `Enter` to finish.

To adjust a Selection, position the mouse cursor to a Selection's vertex, hold left mouse button and move it. 

You can even remove some extended vertices by selecting `Delete Vertex` menu item from Vertex context menu. Just position your mouse cursor to the vertex you want to delete, and then call that menu by right mouse click. But unfortunately, you cannot add any new vertices if you delete too much of them. So the simple way to fix that issue is to delete all the Selection from its own context menu and then create new selection instead.

To adjust scale and position of a visible part of the gel image, use the special menu located at the image's top right corner. The default scale is automatically selected so that all the image would be visible and consume all the available space at the program's main panel.

The mentioned menu contains 4 tools:
*  `Zoom In` — to select and enlarge some area;
*  `Zoom Out` tool to reduce the scale;
*  `Home` (`Restore View`) — to restore the original (default) scale; 
*  `Pan` tool is to move the visible part of the image.

To activate a tool, click on it. The tool becomes selected and highlighted with blue. This indicates that now the tool is active. You can use it. To disable an active tool, just click on it one more time. Now mouse behaves in it standard mode. 

The only exception is `Restore View` tool. It could not be 'activated'; it just restores default image scale, being pressed.

__NOTE:__ The more accurate Selections are, the more precise results you will finally get 
when obtain the intensity values and construct a regression plot.


### Acquiring intensity values ###

The intensity of a band is the sum of the intensity values of all pixels located inside the Selection's polygon. That is why a gel image should look like light color bands on a dark background. In digital color representation, pure black has intensity equal to zero, while white (in the gray scale) is of the maximal positive in a given bit-rate (255 for 8 bit gray scale images).

Calculated intensity values will appear at the program's bottom panel, in the field next to the `Value:` label. You can see that label at the bottom left corner. To obtain the intensity value, position the mouse cursor to the Selection and select `Get intensity` item from the context menu (that is evoked by right mouse click). The Selection whose intensity has been just calculated and displayed, changes its edges' color to orange. Such color change is introduced for a sake of simplicity to help user recognize whose (that Selection's) intensity value is currently being displayed.

### Selection Details: Image Intensity Profiles ###

Obtaining an intensity value is accompanied by the opening of an additional auxiliary window with calculation details. This separate auxiliary window will be noted further as _'Selection Details: Image Intensity Profiles'_ window or simply _'Selection Details'_ window. The window contains 6 tiles to represent the info; 2 rows by 3 columns.

Two right tiles (1-st column) represent the gel image as a whole and the Selection's area on the gel image. The top tile displays the background-corrected gel image as is. The bottom one represents the Selection's area using contrasting colors, as follows. The unselected part, i.e. the area outside of the Selections' edges, is in light orange and "blind". While the selected part is in light blue and contains original image's details.

Both tiles also contain 4 light green lines on each. These lines represent 4 cross sections; one horizontal and 3 vertical. There are 2 cross sections through the Selection's center: vertical-central and horizontal-central, and 2 other vertical ones: through the Selection's left part and its right part.

The other 4 tiles on this auxiliary window display plots of _Image Intensity Profiles_ (_IIPs_) along these cross sections. The title on each tile's header indicates which cross-section a particular set of _IIPs_ belongs to. 

Each plot contains 4 _IIPs_ for a given cross-section:
*  thin green line for `GrayScaled Image` (denoted in the legend as `Original`);
*  blue line for `Filtered Image` (denoted as `Filtered`);
*  dotted cyan line for the `Calculated BackGround` (denoted as `BackGrnd`);
*  red line for Background-corrected image (`BGCorrected`, denoted as `BG-crted` in the legend).

The Selection area cut-off is represented by a black rectangle on each plot.

These plots are specially introduced for user to be sure that the background correction is performed correctly. The _IIP_ of `Background-corrected` image __should be close to zero__, especially in the area around the selected band. Also, these plots are a good illustration of how non-uniform the Background intensity level along the gel in both dimensions could be. 

#### Charts auto-update ####

All the content, plots and gel images, on the _'Selection Details'_ window are automatically reconstructed on each `Get Intensity` call to correspond to current "orange" Selection. It is possible, however, to prevent such a behaviour of a given _'Selection Details'_ window. This could be useful, for example, if you wish to compare _intensity profiles_ (_IIPs_) of 2 or more different Selections. 

For this propose, _'Selection Details'_ window is equipped with a special main menu 
`-> ! Preserve me ! <-` 
with red colored text label. 
It contains only one menu item (`Prevent Charts auto-update on a new band selection`).
By clicking on this menu item, user "disconnects" the given _'Selection Details'_ window from the main window of the _GelQuantTool_ program.
After that the mentioned main menu becomes inactive and changes its text label to `| PRESERVED |`. (To mark this given _'Selection Details'_ window as being _preserved_). Now the content of this _'Selection Details'_ window is preserved from further auto-updates on any new `Get Intensity` call. Instead, a new _'Selection Details'_ window will be constructed on the next `Get Intensity` call. Now this new _'Selection Details'_ window will undergo automatic content updates on each `Get Intensity` call.

#### Disable displaying of Selection Details ####

If user closes all _'Selection Details'_ windows, a new _'Selection Details'_ window will be constructed on the next `Get Intensity` call of any given Selection. However, if you, for some reason, don't want to see selection details and _Image Intensity Profiles_, you can disable _'Selection Details'_ window to be constructed ever.

To achieve that, go to `View` main menu and remove the check-mark next to `Display Calculation Details` item. Now, if you close this auxiliary window it will never appear on the next `Get Intensity` call.

#### `DATA` main menu of _'Selection Details'_ windows ###

_'Selection Details'_ window inherits its menu panel from the standard MATLAB `figure`. Thus, it has got all the main menus with all their sub-menus and items as standard MATLAB `figure` has. In addition to that, 2 main menus are added. One of them is red-colored `-> ! Preserve me ! <-` and it was discussed above. The other is `DATA` main menu.

This menu contains 2 items, as follows.

*  `Rebuild Charts` is to redraw / re-plot / renew all the charts on the given window; to return them to the state as they were at the moment of the window construction. It is achieved by the fact that each _'Selection Details'_ window is interconnected with the object of a special class (`dmGEL.improfPlotUI`). That object contains all the data, required to build all the charts on the related _'Selection Details'_ windows. (Actually, this object is updated on each new `Get Intensity` call, and then `Rebuild Charts` logic is executed.) This item is very useful in a such a common case, when you call / execute `plot(<... something ... >)` on the MATLAB command prompt, while forgetting to execute `figure` before that. And by this mistake, have destroyed one of the charts on the current _'Selection Details'_ window. True MATLAB users will understand `;-)`

*  `Export Intensity Profiles` is to export _IIPs_ to some file in the `*.csv` format. Useful if you want to attach such plots to your paper.


### Automatic collection of intensity values to a file ###

There is a feature that allows you to collect intensity values to a file automatically. This means you don’t need to copy-paste the value each time you call `Get intensity` on any new Selection.

To enable this feature, go to `File` main menu (of the main window of the _GelQuantTool_ program) and select the `Collect data to file...` item. File selection dialog window appears, where you should select a file to collect data to. You can choose any extension you want (such as `.dat`, `.csv` or `.txt` or any other) or even use file without extension. Regardless of an extension chosen, the file will be of __a single column `.csv` format__.

If you select here a new file, that does not exist yet, it will be created at the next `Get Intensity` call. If you select an already existing file, the file __will never be over-written__: the collected _data_ always will _be appended_ to its end.

Press `Save` in that file selection dialog to finally enable the feature. Now, if you go to the `File` main menu, there will be the check-mark next to `Collect data to file...` item. This means that intensity values are now automatically being appended to the file on each `Get Intensity` call.

__NOTE__ that enabling of this feature does _NOT_ disable displaying intensity values at the bottom panel of the main window next to the `Value:` label.

To stop writing data to the file just uncheck the corresponding `File` main menu item. If the check-mark next to `Collect data to file...` item is absent, the data is not longer being collected to any file.


## Review of _GelQuantTool_ main menus ##

### `File` main menu ###

* `Import Image` sub-menu is to import an image to the program; contains to items:
    * `From file` is to import image file;
    * `From Workspace` is to import MATLAB workspace variable. (See above for both.)

* `Save Session` is to save current gel quantification session to a file. Relevant session objects are converted to specially formatted MATLAB `structures` and then these `structures` are saved to MATLAB `*.mat` file. Thus, a special "subset" of `*.mat` format is used to save a session. While saving to a file, you can choose `.mat` or `.dmgelmat` extension. In both cases the internal format will be the same. The last extension type is introduced only to distinguish saved gel quantification session files from other `*.mat` files.

* `Load Session` is to load previously saved session from a file. If _GelQuantTool_ contains non-saved session, you will be asked to save this session to some file first, before continue loading the other one.

* `Clear Session` is to clear current session. It opens a dialog window where user should select what to clear. There are 2 mutually exclusive choices realized as radiobuttons:
    * __Select what to Clear__ Here, it is possible to choose what to preserve and what to remove. It is possible to remove gel images only, or band selections (polygonal Selections) only, or clear both of them. But anyway, selection of this radiobutton preserves some session customizations and variables, like noise filter and background calculator settings (and some other data).
    * __Clear all__ This choice vanishes all the session data and settings.

* `New Session Window` opens another new separate _GelQuantTool_ main window with a new empty session. You can simultaneously run any number of _gel quantification tool_ sessions, each of them completely isolated from others, with its own set of the options.

* `Collect data to file ...` is a checkable menu item to enable / disable automatic collection of intensity values to a file. See above.

* `Exit` is to exit from a current session; exactly the same as closing the main window does.


### `View` main menu ###

The top part of this main menu contains 5 mutually exclusive checkable items (`Original Image` — `BGCorrected Image`). They are used to select what "kind" of image to display. See above. 

Two other items are:

* `Show Original Image Location` item is to show full path of the original image file that was imported. If this item is clicked, the path will be displayed in the same field on the window's bottom as used to display intensity values. The label next to the field, herewith, will be changed from `Value:` to `Original Image`. This label will be switched back to `Value:` automatically on a next `Get intensity` call.

* `Display Calculation Details` checkable item determines whether to display _'Selection Details'_ window with _IIPs_ on `Get intensity` call. See above.


### `Image` main menu ###

It contains 3 items.

* `Filter Noise` is to to apply a noise filter. See above.

* `Invert Colors` is to make the color inversion of the `GrayScaled Image`. See above.

* `Clear BackGround Calculation` item, being clicked, removes the calculated image background an the result of it subtraction.
This brings us back to the step of the image processing where background is not yet calculated and `Filtered Image`, `GrayScaled Image` and `Original Image` are only available to be selected in `View` main menu; while `Calculated BackGround` and `BGCorrected Image` (background-corrected image) are disabled.


### `Settings` main menu ###

There are 2 items here:

* `Noise Filter`;
* `BackGround Calculator`.

They should be used to adjust noise filter options and background calculator options, respectively.

Both menu items open a dialog window there you can do that adjustments. For both items, these dialog boxes are structured the same way. There are 2 mutually exclusive choices realized as radiobuttons. You can select what kind of function to use:
* __The default function.__ This choice only allows user to adjust values of built-in additional arguments of that function.
* __Any custom relevant function.__ By choosing this, the user may provide his own function and all its additional arguments. See below how to do that.

Dialog windows for both `Settings` menu items contain a lot of textual comments to describe peculiarities of the options and how to set them up.


### `New Selection` main menu ###

It contains only one item, `New Selection`, that is to create a New Selection. It was discussed above many times.


### `Alt + ...` keyboard shortcuts for main menus and their items ###

You can reach any item in any menu using a sequence of `Alt + ...` keyboard shortcuts. To select a menu or an item hold down the `Alt` key and type the corresponding `mnemonic`, i.e. the character shown <ins>underlined</ins> in the name of the menu or item. For example, to go through

__<ins>F</ins>ile → <ins>I</ins>mport Image → From <ins>W</ins>orkspace__

press `Alt + F`, then `Alt + I`, and then `Alt + W`.

The other example, that was mentioned in this manual earlier, is `Alt + S`, and then `Alt + S` one more time for:

__New <ins>S</ins>election → New <ins>S</ins>election__


## Noise Filtering Function ##

The default noise filtering function is 
```matlab
J = medfilt2(I,[Y X])
``` 
from MATLAB Image Processing Toolbox.
It performs median filtering of the input image `I` in two dimensions. Each pixel of output `J` contains the median value in the Y-by-X neighborhood around the corresponding pixel in the input image `I`. 

The values of neighborhood's __Width__ (`X`) and __Height__ (`Y`) are the only adjustables in the corresponding dialog window if user selects the __Default Noise Filtering function__. The default values for both `X` and `Y` are equal to `10` pixels.

User can also specify their own custom function that performs the noise filtration. The function must be specified either as a string (character vector) without quotes, that represents the function's name, or as an anonymous function (starting with `@` sign), according to MATLAB syntax. 

An input to the field, where the custom function is specified, will then be processed by the `str2func` MATLAB function to construct a function handle, ready to be executed. The function should return a filtered image and only it.

The 1-st input of the function (`Arg1`) must be an image to be filtered.

All other (additional) arguments to the user's custom function must be specified in the special field in the format of a cell array in the order they should appear in the function's call, as follows: `{Arg2, Arg3, Arg4}` and so on. Each `ArgN` by itself could be of any possible (allowed) format. 
An input to this field will then be processed by the `eval` MATLAB function and the result of its call is expected to be a single correct cell array. 

Here is an example of the correct format: 
```matlab
{'StrParam', 'StrVal', 7, [1, 2; 3, 4]}
```
Specify your cell array here, in that field, just the same way you do it in the MATLAB command line, i.e. without leading and trailing quotation marks. If no additional arguments are required, just leave this field empty.


## Background Calculator Function ##

The default background calculator function `dmGEL.bgRectImopen` ships with _GelQuantTool_ software (inside the `+dmGEL` package) and it is the author's original invention. It is based upon _morphological image opening_ algorithm. 

For this algorithm to work, the rectangle sub-piece of a gel image is required. This sub-piece must simultaneously be `xMult`-times wider than the widest band on the gel AND `yMult`-times higher than the highest band. Typically, the biggest band is the widest and the highest one simultaneously. So select it to calculate and subtract the image Background. If the widest one and the highest one are different bands, simply select any arbitrary area on the image such a way that this area would be of the same width as the widest band and of the same height as the highest band. And then use this selection to proceed with Background calculation. See above how to do that in practice.

The values of `xMult` and `yMult` could be adjusted in the corresponding dialog window if user selects the __Default Background Calculator function__.
Commonly, best results are achieved with both of them being set to `1.7`. Therefore this value is preset default for both. But in some cases the other values could be more reliable. Typically but not always, both `xMult` and `yMult` are expected to be somewhere between `1.3` and `2.5`.
    
User can also specify their own custom function that calculates the image Background. The function must be specified either as a string (character vector) without quotes, that represents the function's name, or as an anonymous function (starting with `@` sign), according to MATLAB syntax. 

An input to the field, where the custom function is specified, will then be processed by the `str2func` MATLAB function to construct a function handle, ready to be executed. The function should return a calculated image Background and only it. The subtraction of the calculated Background is performed by the _GelQuantTool_ software outside of a Background Calculator function.

The 1-st input of the function (`Arg1`) must be an image whose Background is about to be calculated. 

The 2-nd input (`Arg2`) must describe the polygon that is used to select an area on a gel image. The polygon should be represented by pixel positions of
its vertices in a form of a matrix `[x1, y1; x2, y2; ...]`. Here `xi` and `yi` are `X` (horizontal) and `Y` (vertical) coordinates of the `i-th` vertex.
```matlab
% if poly_vertices = [x1, y1; x2, y2; ...] then
X_vals = poly_vertices(:,1); %  X_vals = [x1; x2; ...]
Y_vals = poly_vertices(:,2); %  Y_vals = [y1; y2; ...]
```

All other (additional) arguments to the user's custom function must be specified in the special field in the format of a cell array in the order they should appear in the function's call, as follows: `{Arg3, Arg4, Arg5}` and so on. Each `ArgN` by itself could be of any possible (allowed) format. 
An input to this field will then be processed by the `eval` MATLAB function and the result of its call is expected to be a single correct cell array. 

Here is an example of the correct format: 
```matlab
{'StrParam', 'StrVal', 7, [1, 2; 3, 4]}
```
Specify your cell array here, in that field, just the same way you do it in the MATLAB command line, i.e. without leading and trailing quotation marks. If no additional arguments are required, just leave this field empty.
    

# COPYRIGHT #

This software project is Copyright (c) 2025 by Denis I. Markov aka MariK

< dm DOT marik DOT 230185 AT gmail DOT com >
< t DOT me / dm_MariK >

This work is licensed under the Creative Commons Attribution-ShareAlike 4.0 International License.
