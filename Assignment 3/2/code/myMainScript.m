%% MyMainScript

tic;
%% MeanShiftSegmentation

%We perform the mean-shift-segmentation using both the color(RGB) and the
%spatial-coordinate(XY) features. Firstly we apply a gaussian filter on the
%image and subsample it with a factor of 0.5 so that our algorithm dosen't
%take too long because of the large size of the image. We took exponential 
%kernel function for the segmentation algorithm. To handle both the color 
%and spatial coordinate features together, we converted our 3-D (RGB) image 
%to a 5-D(RGBXY) image with the features scaled by their respective
%gaussian kernel bandwidth feature parameters (hr and hs). For using knn
%search for finding the neighbours and to use the algorithm efficiently,
%we flattened the HxWx5 image as HxW,5 vector. After sufficient number of
%iterations of the mean shift, we output the 3-D (RGB) segmented image.
%Abbreviations
% Gaussian kernel bandwidth for the spatial feature - hr
% Gaussian kernel bandwidth for the color feature - hs
% Nuber of iterations - iterations
%Number of segments - nos
%For baboonColor image - hr=1, hs=50, iterations=20, nos=10
%For flower image - hr=1, hs=100, iterations=20, nos=9
%For bird image - hr=1, hs=30, iterations=20, nos=6

%% Your code here
myNumOfColors = 200;
myColorScale = [ [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' ];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
img=imread('../data/baboonColor.png');

f = figure();
imagesc (img), title("Original Image");
saveas(f, strcat('../images/', 'baboonColor_original.png'));

out=myMeanShiftSegmentation(img, 1, 50, 150, 20, 0.5);
f = figure();
imagesc(out), title(['Segmented Image hr=1' ' hs=50' ' iterations=20']);
saveas(f, strcat('../images/', 'baboonColor_segmented.png'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

img=imread('../data/flower.jpg');

f = figure();
imagesc (img), title("Original Image");
saveas(f, strcat('../images/','flower_original.png'));

out=myMeanShiftSegmentation(img, 1, 100, 150, 20, 0.5);
f = figure();
imagesc(out), title(['Segmented Image hr=1' ' hs=100' ' iterations=20']);
saveas(f, strcat('../images/','flower_segmented.png'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

img=imread('../data/bird.jpg');

f = figure();
imagesc (img), title("Original Image");
saveas(f, strcat('../images/','bird_original.png'));

out=myMeanShiftSegmentation(img, 1, 30, 150, 20, 0.5);
f = figure();
imagesc(out), title(['Segmented Image hr=1' ' hs=30' ' iterations=20']);
saveas(f, strcat('../images/','bird_segmented.png'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
toc;

