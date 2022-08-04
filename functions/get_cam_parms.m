function [paramsout] = get_cam_parms(cam_images,options)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

paramsout = {};
for i = 1:size(cam_images,1)

    [imagePoints, boardSize] = detectCheckerboardPoints(cam_images(i,:));
    worldPoints = generateCheckerboardPoints(boardSize,options.squareSizeInMM);
    
    mean_er = 100000;
    % calibrate cameras, and then remove images with highest reprojection
    % error, until error or N images is low
    while mean_er > 0.6 && size(imagePoints,3) > 25
        params      = estimateCameraParameters(imagePoints,worldPoints,'ImageSize',options.imagesize,'NumRadialDistortionCoefficients',options.NumRadialDistortionCoefficients);
        repro_er    = mean(sqrt(sum(((imagePoints-params.ReprojectedPoints).^2),2)),'omitnan');
        [~, indx]=sort(repro_er(:));
        mean_er = mean(repro_er);
        disp(sprintf('mean reprojection error is %d with %d images', mean_er,size(imagePoints,3)))
        imagePoints = imagePoints(:,:,indx,1);
        imagePoints = imagePoints(:,:,1:round(.75*length(repro_er)));

    end
    paramsout{i}={params};
end
end