main_dir = '/Users/benmartin/3D_reconstruction_mobile_array/matlab'
cd(main_dir)
video_paths = ["GH010286_cut.MP4","GH010465_cut.MP4"]

tic
v = VideoReader(video_paths(1))
options.squareSizeInMM = 27;
options.imagesize=[v.Width,v.Height];
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