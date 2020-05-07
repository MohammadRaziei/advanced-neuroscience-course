function video = video_make(name)
video.fig = figure('Color','w','ToolBar','none','MenuBar','none', 'units','normalized','outerposition',[0.1 0.2 0.8 0.7]);
video.name = name;
video.stream = VideoWriter(video.name,'MPEG-4'); %open video file
video.stream.FrameRate = 10;  
open(video.stream)



end