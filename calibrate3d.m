main_dir = '/Users/benmartin/3D_reconstruction_mobile_array/matlab'
cd(main_dir)

%I tested this pipeline with Field Research Videos/Curacao
%2022/Monopod_videos/Bommie/10_07_22
% Cams C and D videos "GH010286_cut.MP4","GH010465_cut.MP4"
video_paths = ["GH010286_cut.MP4","GH010465_cut.MP4"]

tic
v = VideoReader(video_paths(1))
options.squareSizeInMM = 27;
options.imagesize=[v.Height,v.Width];
options.n_framesout = 150; % target number of calibration frames per camera
options.NumRadialDistortionCoefficients = 3;

%% find images with checkerboards
cal_frames = get_calib_frames(video_paths,options);

%% extract paired images from cameras
cd(main_dir)
[cam_images] = extract_paired_images(video_paths,cal_frames);

%% get parameters for each camera
cam_parms = get_cam_parms(cam_images,options);


%% calibrate stereo cameras

[stereoParams, imagepoints] = get_stereo_parms(cam_parms,cam_images,options);

toc

%% reformat parameters for use in openCV

[intrinsicMatrix1,distortionCoefficients1,intrinsicMatrix2, ...
   distortionCoefficients2,rotationOfCamera2,translationOfCamera2] =... 
   stereoParametersToOpenCV(stereoParams);

%% testing the accuracy of the calibration, with a known length object (distance between cam A and B 1 m)

% read in two images
A=imread("calib_images/1/im_008471.jpg");
B=imread("calib_images/2/im_008471.jpg");

% undistort images
A = undistortImage(A,stereoParams.CameraParameters1);
B = undistortImage(B,stereoParams.CameraParameters2);

% show images and calculate pixel coords of the cam A and B
imshow(A)
imshow(B)
% below I hard coded values I measured
lc1=[1683,530]
rc1=[1919,536]
lc2=[1645,616]
rc2=[1893,634]

%calculate 3d pos of left cam
point3d_lr = triangulate(lc1, lc2, stereoParams);

%calculate 3d pos of right cam
point3d_rc = triangulate(rc1, rc2, stereoParams);

% calc inter-camera distance (ans = 1.001 m)
sqrt(sum((point3d_lr-point3d_rc).^2))
