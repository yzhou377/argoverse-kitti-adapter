[![Python 3.6](https://img.shields.io/badge/python-3.6-blue.svg)](https://www.python.org/downloads/release/python-360/)
[![Python 3.7](https://img.shields.io/badge/python-3.7-blue.svg)](https://www.python.org/downloads/release/python-370/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)

# argoverse-kitti-adapter
A toolbox to translate [Argoverse dataset (CVPR2019)](https://www.argoverse.org/data.html) into [KITTI dataset (CVPR2012)](http://www.cvlibs.net/datasets/kitti/) format for perception/tracking tasks. 

 - Author: Yiyang Zhou 
 - Contact: yiyang.zhou@berkeley.edu 

## Introduction 
This toolbox is to translate Argoverse dataset from CVPR2019 into the KITTI dataset format. The major changes are:
1. Changing labels from the .json files into the .txt file format (15 columns) used in KITTI dataset;
2. Reconfigure the calibration files from the .json files per log into .txt file format per image/lidar scan;
3. Copying related image files and lidar files to form the corrsponding data structure used in KITTI perception tasks;

## Usage
### 1. Download Data
- Please download the most recent [argoverse dataset](https://www.argoverse.org/data.html). Once the data is downloaded, it is convenient to put all the training logs under one training folder. Please do not change any contents under the individual log folder. Here is a document tree as an illustration:
```
argodataset
└── argoverse-tracking <----------------------------root_dir
    └── train <-------------------------------------data_dir
        └── 0ef28d5c-ae34-370b-99e7-6709e1c4b929
        └── 00c561b9-2057-358d-82c6-5b06d76cebcf
        └── ...
    └── validation
        └──5c251c22-11b2-3278-835c-0cf3cdee3f44
        └──...
    └── test
        └──8a15674a-ae5c-38e2-bc4b-f4156d384072
        └──...
```
### 2. Download Argoverse Repo
- To use the toolbox, please follow the instructions in the [argoverse github repository](https://github.com/argoai/argoverse-api/tree/16dec1ba51479a24b14d935e7873b26bfd1a7464) to install the corrsponding python API. 

### 3. Clone the Argoverse-kitti-adapter Repo
'''git clone https://github.com/yzhou377/argoverse-kitti-adapter.git'''
- Once the data and the API are well equipped, please open the 'apater.py' file for changing your root_dir (the directory to your argoverse-tracking folder). The toolbox will automatically construct a new folder (train_kitti) for you. The new file structure is shown as below: 

```
argodataset
└── argoverse-tracking <----------------------------root_dir
    └── train <-------------------------------------data_dir
        └──5c251c22-11b2-3278-835c-0cf3cdee3f44
        └──...
    └── train_kitti <-------------------------------goal_dir
        └──velodyne
        └──iamge_2
        └──calib
        └──label_2
        └──velodyne_reduced <-----------------------empty folder
    └── ...
```

### 4. Change Hyperparameters
- On the top of the adapter.py file, please change the root directory and the distance threshold. 

### 5. Run the Adapter
- After changing the configruation file, please run the adapter.py file using the following commands
"""python adapter.py"""

## Note
1. Frequency and Sychronization 
- In KITTI, the camera and the LIDAR are synchronized at 10Hz. However, in Argoverse, the ring cameras are running at 30Hz, while the LIDAR is running at 10Hz. To fully realize the KITTI dataset format, we match each LIDAR scan with the corresponding camera at the closest timestamp. As a result, the sensor combo in the modified KITTI version of Argoverse is still running at 10Hz. 
2. Multi-camera
- In KITTI dataset, each image is matched up with one LIDAR scan, one label file, and one calibration document. However, in Argoverse, seven images share one LIDAR scan, and one log only has one single label/calibration combo. Using only the ring cameras, the LIDAR file is copied 7 times to match with each image, and corresponding label/calibration files are generated as well. 
3. Labelling File Clips 
- KITTI only labels the object in the view of the front camera, while Argoverse, given its panoramic nature, labels all the obstacles around the object. Thus, for each associated labelling file, if the object is not seen in this specific image, then it is not labelled. Furthermore, objects that are too small (beyond 50m) were not labelled. One can cetrainly change this threshold in the ['apater.py'](https://github.com/yzhou377/argoverse-kitti-adapter/blob/master/adapter.py).  [Here](https://github.com/yzhou377/argoverse-kitti-adapter/blob/master/supplementals/KITTI_README) attaches the KITTI label README file . For the Argoverse label file, please go check the [Argoverse github](https://github.com/argoai/argoverse-api/tree/16dec1ba51479a24b14d935e7873b26bfd1a7464)
4. Calibration File
- To match the KITTI calibration file, the tool is designed to combine the 'R0_rect' matrix together with the 'P2' matrix to form intrinsic matrix 'K' of the  camera. In the new label file, 'R0_rect' is set to be an identity matrix, while 'P2' contains all the intrinsics. 

## Reference 
- [1] M. Chang et al., Argoverse: 3D Tracking and Forecasting with Rich Maps, CVPR2019, Long Beach, U.S.A
- [2] A. Geiger et al., Are we ready for Autonomous Driving? The KITTI Vision Benchmark Suite, CVPR2012, Rhode Island, U.S.A
