%% Question 2
myNumOfColors = 200;
myColorScale = [ [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' ];
% First, read the images
tic;
imGrass = imread("../data/grass.png");
imHoneyComb = imread("../data/honeyCombReal.png");
imBarbara = load("../data/barbara.mat");
imBarbara = cast(imBarbara.imageOrig, 'uint8');

 

%% Barbara Image
sigma_space = 0.6;
sigma_intensity = 18;
r1 = 0;
for i = 1 : 20
    [rmsd,im_noisy,newim] = myBilateralFiltering(imBarbara, sigma_space, sigma_intensity);
    r1 = r1 + rmsd;
end
disp("The optimal avg RMSD is:");
disp(r1/20);
% f1 = figure;
% figure(f1);
figure(), imagesc(imBarbara), title("Original Image"), colormap(myColorScale), daspect([1 1 1]), colorbar, truesize;
figure(), imagesc(im_noisy), title("Added noise"), colormap(myColorScale), daspect([1 1 1]), colorbar, truesize;
figure(), imagesc(newim), title("Filtered Image"), colormap(myColorScale), daspect([1 1 1]), colorbar, truesize;

 

%% RMSD Results

 

%% Grass Image
sigma_space = 1;
sigma_intensity = 46;
r2 = 0;
for i = 1 : 20
    [rmsd,im_noisy,newim] = myBilateralFiltering(imGrass, sigma_space, sigma_intensity);
    r2 = r2 + rmsd;
end
disp("The optimal avg RMSD is:");
disp(r2/20)
figure(), imagesc(imGrass), title("Original Image"), colormap(myColorScale), daspect([1 1 1]), colorbar, truesize;
figure(), imagesc(im_noisy), title("Added noise"), colormap(myColorScale), daspect([1 1 1]), colorbar, truesize;
figure(), imagesc(newim), title("Filtered Image"), colormap(myColorScale), daspect([1 1 1]), colorbar, truesize;

 

%% RMSD Results

 


%% Honey Comb Image
sigma_space = 1.2;
sigma_intensity = 34;
r3 = 0;
for i = 1 : 20
    [rmsd,im_noisy,newim] = myBilateralFiltering(imHoneyComb, sigma_space, sigma_intensity);
    r3 = r3 + rmsd;
end
disp("The optimal avg RMSD is:");
disp(r3/20);
figure(), imagesc(imHoneyComb), title("Original Image"), colormap(myColorScale), daspect([1 1 1]), colorbar, truesize;
figure(), imagesc(im_noisy), title("Added noise"), colormap(myColorScale), daspect([1 1 1]), colorbar, truesize;
figure(), imagesc(newim), title("Filtered Image"), colormap(myColorScale), daspect([1 1 1]), colorbar, truesize;

 

%% RMSD Results

 

toc;