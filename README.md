# argoverse-kitti-adapter
A toolbox to translate Argoverse dataset (CVPR2019) into KITTI dataset format for perception/tracking tasks. 

Author: Yiyang Zhou 
Contact: yiyang.zhou@berkeley.edu 

## Introduction 
This toolbox is to translate Argoverse dataset from CVPR2019 into the KITTI dataset format. The major changes are:
1. Changing labels from the .json files into the .txt file format (15 columns) used in KITTI dataset;
2. Reconfigure the calibration files from the .json files per log into .txt file format per image/lidar scan;
3. Copying related image files and lidar files to form the corrsponding data structure used in KITTI perception tasks;

## How to use? 
To use the toolbox, you have to follow the instructions in the argoverse dataset github repository to install the corrsponding python API. 
Then 

## Reference 
