function [stereoParams,imagePoints] = get_stereo_parms(cam_parms,cam_images,options)
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here


camera1Intrinsics=cam_parms{1, 1}{1, 1}  ;
camera2Intrinsics=cam_parms{1, 2}{1, 1}  ;
%detector = vision.calibration.stereo.CheckerboardDetector();

%squareSize = 27;  % in units of 'millimeters'
%worldPoints = generateWorldPoints(detector, 'SquareSize', squareSize);

detector = vision.calibration.stereo.CheckerboardDetector();
[imagePoints, imagesUsed] = detectPatternPoints(detector, cam_images(1,:), cam_images(2,:));

% Generate world coordinates for the planar patten keypoints
squareSize = 27;  % in units of 'millimeters'
worldPoints = generateWorldPoints(detector, 'SquareSize', options.squareSizeInMM);

camera1Intrinsics=cam_parms{1, 1}{1, 1};
camera2Intrinsics=cam_parms{1, 2}{1, 1};

mean_er = 100000;
while mean_er > 0.6 && size(imagePoints,3) > 20
    [stereoParams, pairsUsed, estimationErrors] = estimateStereoBaseline(imagePoints, worldPoints, camera1Intrinsics, camera2Intrinsics,'WorldUnits', 'millimeters');
    repro_er    = mean(sqrt(sum(((imagePoints(:,:,:,1)-stereoParams.CameraParameters1.ReprojectedPoints).^2),2)),'omitnan');
    [~, indx]=sort(repro_er(:));
    imagePoints = imagePoints(:,:,indx,:);
    imagePoints = imagePoints(:,:,1:round(.75*length(repro_er)),:);
    mean_er = mean(repro_er);
    disp(sprintf('mean reprojection error is %d with %d images', mean_er,size(imagePoints,3)))
end

end