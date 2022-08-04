function cal_frames = get_calib_frames(video_paths,options)
v = VideoReader(video_paths(1));
f_interval=300;
calibframes = [];
for i = 1:f_interval:v.NumFrames
    frame = read(v,[i i]);
    [imagePoints,boardSize] = detectCheckerboardPoints(frame);
    if isempty(imagePoints) ==  0
        calibframes = [calibframes,i];
    end
end

n_frames = round(options.n_framesout /length(calibframes));
inc = round(f_interval/n_frames);

cal_frames=[];
for i = calibframes
    temp = [i-f_interval:inc:i+f_interval];
    cal_frames = [cal_frames,temp];
end


end
