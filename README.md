# NBDT_dynamic_clicks
This is the reference repository for code used in our [NBDT](https://nbdt.scholasticahq.com/about) publication on the dynamic clicks task
**[PRE-PRINT](https://arxiv.org/abs/1902.01535)**. The main programing languages used are MATLAB (version 2017+) and Octave (version 4.2.2). Python 3 was also used to produce static clicks datasets, as explained below.

# Figures 1-3
The high-level algorithms for producing figures 1 through 3 were described 
in the paper.
The files `simulate_linDE.m`, `simulate_DE.m` and `simulate_crossover_effect.m` 
contain code that was used to produce these figures. 

The file `simulate_linDE.m` is an example implementation of how the clicks
stimulus and the responses of the linear model may be simulated.

The file `simulate_DE.m` is an example implementation of how the clicks
stimulus and the responses of the nonlinear model may be simulated.

The file `simulate_crossover_effect.m` is an example implementation of how
the cross-over effect from figure 2 may be computed.

----------
**DISCLAIMER: For the remainder of the figures, the code is spread out across several repositories. If you want to reproduce them, you will need to:**
- Install [ToolboxToolbox](https://github.com/ToolboxHub/ToolboxToolbox)
- Clone these repositories:
  - [main repo for analysis](https://github.com/aernesto/analysis_and_fits_dyn_clicks/tree/dev) 
  - [repo for database handling](https://github.com/aernesto/Data_IO_Clicks_Project/tree/design) (Python 3 will be needed to produce the clicks stimuli and create the databases)
  - [old repo where some relevant code still lies](https://github.com/aernesto/param-infer-clicks)
- Follow the instructions below. In particular, the links provided to specific scripts are always *frozen* to a particular commit number or tag. Thus, to execute the referenced script, you should first get your [HEAD in detached mode](https://git-scm.com/docs/gitglossary#gitglossary-aiddefdetachedHEADadetachedHEAD) to point to the appropriate commit or tag (`git checkout <commit number>`).  

For questions regarding figures 4 and 5, contact Adrian Radillo at the following email:  
adrian dot radillo at pennmedicine dot upenn dot edu

# Figures 4A-B
First, a 1-Million trial database of clicks stimuli `validation2.h5` was produced. You may download it from [here](https://app.box.com/s/dfygciwu82j7faybl39wsjxetzfq0d8l). If you'd rather produce yourself an equivalent database, you may follow the instructions [here](https://github.com/aernesto/Data_IO_Clicks_Project/tree/design), bearing in mind that the `validation2.h5` dataset had the following parameter settings:  
low click rate = 5 Hz, high click rate = 20 Hz, stimulus hazard rate = 1 Hz.

Then, the accuracy values of the different models in the figures were computed with [this script](https://github.com/aernesto/analysis_and_fits_dyn_clicks/blob/figure4_AB_1M_trials/accuracy_figure_1.m), which outputs a file named `accuracy_figure_9.mat`. This `.mat` file was eventually used by [this script](https://github.com/aernesto/analysis_and_fits_dyn_clicks/blob/figure4_AB_1M_trials/plots/accuracy_noise.m) which generates the actual plots.

# Figures 4C-D
The database used for the fits is `S3lr5h1T2tr10000sp1000.h5` and may be downloaded [here](https://app.box.com/s/8grhhaf1pymc32lg2e0npbo98wf9puwh). Just as for the `validation2.h5` database previously mentioned, you can reproduce your own equivalent database following the instructions [here](https://github.com/aernesto/Data_IO_Clicks_Project/tree/design), bearing in mind that the `S3lr5h1T2tr10000sp1000.h5` dataset had the following parameter settings:  
low click rate = 5 Hz, high click rate = 20 Hz, stimulus hazard rate = 1 Hz, total number of trials in database = 10,000.

The MAP estimates were computed with [this script](https://github.com/aernesto/param-infer-clicks/blob/19f467c6eee569ce638530b6b20cbd888413f91c/MATLAB_2017a_code/nonlin_stoch_fig4.m), which uses the `S3lr5h1T2tr10000sp1000.h5` file as input and outputs 4 `.mat` files.

In turn, these `.mat` files are read by [this script](https://github.com/aernesto/analysis_and_fits_dyn_clicks/blob/002c5af8738a49b75070bc9312fff8e278792cdf/plots/whiskers_point_estimates.m) to produce the whisker plots from panels C and D.

# Figure 4E

The fits from the `.mat` files mentioned in the previous section were collected in [this `.csv` file](https://app.box.com/s/6m8re9ob7qre1k5uyr8syrfkcnr6x9m4). This `.csv` file is then read by the code mentioned in the next paragraph.

Panel E from figure 4, corresponding to the relative error resulting from the fits may be reproduced by running only the code in
[this script](https://github.com/aernesto/analysis_and_fits_dyn_clicks/blob/d61f046cbad5ba3d89186590d63859025e0b758d/plots/Figure4.m) that relates to the 3rd subplot.

# Figure 5
The function that produces each individual panel is [this one](https://github.com/aernesto/analysis_and_fits_dyn_clicks/blob/Figure5_FINAL/plots/pcolor_PP.m). One of its arguments is a `.mat` file outputted by one of the following scripts, depending on the model pair:
- [NL-NL](https://github.com/aernesto/param-infer-clicks/blob/436447e66176ad2716f0c234cc03a41df45cd179/MATLAB_2017a_code/cross_param_PP_NLNL.m)
- [L-L](https://github.com/aernesto/param-infer-clicks/blob/436447e66176ad2716f0c234cc03a41df45cd179/MATLAB_2017a_code/cross_param_PP_LL.m)
- [L-NL or NL-L](https://github.com/aernesto/param-infer-clicks/blob/436447e66176ad2716f0c234cc03a41df45cd179/MATLAB_2017a_code/cross_param_PP_L_NL.m)

The clicks database on which *percent match* is maximized is `validation2.h5`, already mentioned above.
