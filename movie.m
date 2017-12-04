 % load the images
 images    = cell(3,1);
 counter=1;
 for i=1:56
 images{counter} = imread(strcat('/Users/acal/DataScienceProjects/StoryTellingThroughDataFirstWorldvsThirdWorld/pic_',num2str(i),'.png'));
 counter=counter+1;
 end
 % create the video writer with 1 fps
 writerObj = VideoWriter('movie.avi');
 writerObj.FrameRate = 1;
 % set the seconds per image
 secsPerImage = repelem( 1,length(1:56));
 % open the video writer
 open(writerObj);
 % write the frames to the video
 for u=1:length(images)
     % convert the image to a frame
     frame = im2frame(images{u});
     for v=1:secsPerImage(u) 
         writeVideo(writerObj, frame);
     end
 end
 % close the writer object
 close(writerObj);
 
% obj = VideoWriter('test.avi');
% data = rand(4096);
% open(obj)
% writeVideo(obj,data)
% writeVideo(obj,sin(data))
% close(obj)