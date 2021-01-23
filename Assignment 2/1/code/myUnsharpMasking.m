function [] = myUnsharpMasking()
    myNumOfColors = 200;
    myColorScale = [ [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' ];
    imageList = ["../data/lionCrop.mat" "../data/superMoonCrop.mat"];
    scalingParam = [3, 7];
    sigmaParam = [1.25 4];
    filterSize = [7 9];

    imgMat = load(imageList(1)).imageOrig;
    img = mat2gray(imgMat);
    origStretchedImg = myLinearContrastStretching(img);
    newImg = sharpen(img, scalingParam(1), sigmaParam(1), filterSize(1));
    newStretchedImg = myLinearContrastStretching(newImg);
    figure(), imagesc(origStretchedImg), title("Original Image"), colormap(myColorScale), daspect([1 1 1]), colorbar, truesize;
    figure(), imagesc(newStretchedImg), title("Sharpened Image"), colormap(myColorScale), daspect([1 1 1]), colorbar, truesize;
    
    imgMat = load(imageList(2)).imageOrig;
    img = mat2gray(imgMat);
    origStretchedImg = myLinearContrastStretching(img);
    newImg = sharpen(img, scalingParam(2), sigmaParam(2), filterSize(2));
    newStretchedImg = myLinearContrastStretching(newImg);
    figure(), imagesc(origStretchedImg), title("Original Image"), colormap(myColorScale), daspect([1 1 1]), colorbar, truesize;
    figure(), imagesc(newStretchedImg), title("Sharpened Image"), colormap(myColorScale), daspect([1 1 1]), colorbar, truesize;

end

function [sharpenedImg] = sharpen(img, scale, sigma, fltSize)
    filter = fspecial('gaussian', fltSize, sigma);
    blurImg = imfilter(img, filter, 'conv');
    unsharpMask = img - blurImg;
    sharpenedImg = img + (scale*unsharpMask);
end

function [stretchedImg] = myLinearContrastStretching(img)
    Imean = mean2(img);
    Istd = std2(img);
    Imin = Imean - 3*Istd;
    Imax = Imean + 3*Istd;
    stretchedImg = (img - Imin)/(Imax-Imin);
    [M, N] = size(img);
    for i = 1:M
        for j = 1:N
            if img(i,j) < Imin
                stretchedImg(i,j) = 0;
            elseif img(i,j) > Imax
                stretchedImg(i,j) = 1;
            end
        end
    end
end