%% MyMainScript

tic;
%% Your code here
myNumOfColors = 200;
myColorScale = [ [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' ];

img1 = imread('../data/flower.jpg');
figure(), imagesc(img1), title("Original Image"), colormap(myColorScale), colormap jet, daspect([1 1 1]), colorbar, truesize;
scale = 0.65;
scaledImage = double(imresize(img1, scale));
[c1, segment] = Segmentation(img1, scale);

for i=1:3
    c1(:,:,i) = cleanMask(c1(:,:,i), 3);
    c1(145:end,:,i) = 0;
    c1(:,:,i) = imfill(c1(:,:,i), 'holes');
end

for i=1:3
    foreImg = scaledImage;
    backImg = scaledImage;
    for j=1:3
        foreImg(:,:,j) = c1(:, :, i).*scaledImage(:,:,j);
        backImg(:,:,j) = (1-c1(:, :, i)).*scaledImage(:,:,j);
    end
    figure(), imagesc(c1(:, :, i)), title("Mask"), colormap(myColorScale), daspect([1 1 1]), colorbar, truesize;
    figure(), imagesc(uint8(foreImg)), title("Foreground Image"), colormap(myColorScale), colormap jet, daspect([1 1 1]), colorbar, truesize;
    figure(), imagesc(uint8(backImg)), title("Background Image"), colormap(myColorScale), colormap jet, daspect([1 1 1]), colorbar, truesize;
    [filteredImage, radiusMatrix] = filterImage(scaledImage, c1(:, :, i), 20*scale, 2);
    figure(), imagesc(uint8(radiusMatrix*255)), title("Radius Contour Image"), colormap(myColorScale), daspect([1 1 1]), colorbar, truesize;
    figure(), imagesc(filteredImage), title("Final Filtered Image"), colormap(myColorScale), colormap jet, daspect([1 1 1]), colorbar, truesize;
end

for i=1:5
    r = 0.2*i*20;
    filt = fspecial('disk', r);
    filt(filt>0) = 1;
    [fs, ~] = size(filt);
    rad = (fs-1)/2;
    cover = zeros(41,41);
    cover(21-rad:21+rad,21-rad:21+rad) = filt;
    strTitle = "Disk Filter with Radius %0.1f alpha";
    figTitle = sprintf(strTitle, 0.2*i);
    figure(), imagesc(uint8(cover)), title(figTitle), colormap(myColorScale), daspect([1 1 1]), colorbar, truesize;
end


img2 = imread('../data/bird.jpg');
figure(), imagesc(img2), title("Original Image"), colormap(myColorScale), colormap jet, daspect([1 1 1]), colorbar, truesize;
scale = 0.25;
scaledImage = double(imresize(img2, scale));
[c2, segment] = Segmentation(img2, scale);

for i=1:3
    c2(:,:,i) = cleanMask(c2(:,:,i), 5);
    c2(60:end,1:75,i) = 0;
    c2(1:20,80:end,i) = 0;
    c2(1:40,110:end,i) = 0;
    c2(115:end,1:120,i) = 0;
    c2(:,:,i) = imfill(c2(:,:,i), 'holes');
end

for i=1:3
    foreImg = scaledImage;
    backImg = scaledImage;
    for j=1:3
        foreImg(:,:,j) = c2(:, :, i).*scaledImage(:,:,j);
        backImg(:,:,j) = (1-c2(:, :, i)).*scaledImage(:,:,j);
    end
    figure(), imagesc(c2(:, :, i)), title("Mask"), colormap(myColorScale), daspect([1 1 1]), colorbar, truesize;
    figure(), imagesc(uint8(foreImg)), title("Foreground Image"), colormap(myColorScale), colormap jet, daspect([1 1 1]), colorbar, truesize;
    figure(), imagesc(uint8(backImg)), title("Background Image"), colormap(myColorScale), colormap jet, daspect([1 1 1]), colorbar, truesize;
    [filteredImage, radiusMatrix] = filterImage(scaledImage, c2(:, :, i), 40*scale, 2);
    figure(), imagesc(uint8(radiusMatrix*255)), title("Radius Contour Image"), colormap(myColorScale), daspect([1 1 1]), colorbar, truesize;
    figure(), imagesc(filteredImage), title("Final Filtered Image"), colormap(myColorScale), colormap jet, daspect([1 1 1]), colorbar, truesize;
end

for i=1:5
    r = 0.2*i*40;
    filt = fspecial('disk', r);
    filt(filt>0) = 1;
    [fs, ~] = size(filt);
    rad = (fs-1)/2;
    cover = zeros(81,81);
    cover(41-rad:41+rad,41-rad:41+rad) = filt;
    strTitle = "Disk Filter with Radius %0.1f alpha";
    figTitle = sprintf(strTitle, 0.2*i);
    figure(), imagesc(uint8(cover)), title(figTitle), colormap(myColorScale), daspect([1 1 1]), colorbar, truesize;
end

toc;
