# matlab3Dcalibration

This code calibrates a set of synced stereo cameras that contain some segments where a checkboard pattern was displayed.


## Steps:
1. find frames that contain checkboards in the videos
2. Extract those frames for each camera and save out as jpgs
3. Calibrate individual camereas to get camera intrinics
4. Estimate the baseline and relative orientation of cameras to generate stereo parameters

One calibrated, the images in each video can be rectified, and the positions of features in a pair of images can be used to triangulate 3D positions
