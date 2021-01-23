function [RMSDvals] = myPatchBasedFiltering(Stdev, istd)
    % input images
    RMSDvals = [-1, -1, -1];
    myNumOfColors = 200;
    myColorScale = [ [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' ];
    imgBarbara = load("../data/barbara.mat");
    imgBarbara = cast(imgBarbara.imageOrig, 'double');
    imgBarbara = imgBarbara./max(max(imgBarbara));
    imgGrass = imread("../data/grass.png");
    imgGrass = double(imgGrass); imgGrass = imgGrass./max(max(imgGrass));
    imgHoney = imread('../data/honeyCombReal.png');
    imgHoney = double(imgHoney); imgHoney = imgHoney./max(max(imgHoney));
    
    imgBarbarac = corrupt(imgBarbara);
%     disp(RMSD(imgBarbarac, imgBarbara));
    fImg = patchFilter(imgBarbarac, [9, 9], [25, 25], Stdev(1), istd);
    RMSDvals(1) = RMSD(fImg, imgBarbara);
    subplot(1, 3, 1), imagesc(imgBarbara), title("Original Image"), colormap(myColorScale), daspect([1 1 1]), colorbar, axis tight;
    subplot(1, 3, 2), imagesc(imgBarbarac), title("Added noise"), colormap(myColorScale), daspect([1 1 1]), colorbar, axis tight;
    subplot(1, 3, 3), imagesc(fImg), title("Patch Based Filtering Result"), colormap(myColorScale), daspect([1 1 1]), colorbar, axis tight;
    
    imgGrassC = corrupt(imgGrass);
%     disp(RMSD(imgGrassC, imgGrass));
    fImg = patchFilter(imgGrassC, [9, 9], [25, 25], Stdev(2), istd);
    RMSDvals(2) = RMSD(fImg, imgGrass);
    figure();
    subplot(1, 3, 1), imagesc(imgGrass), title("Original Image"), colormap(myColorScale), daspect([1 1 1]), colorbar, axis tight;
    subplot(1, 3, 2), imagesc(imgGrassC), title("Added noise"), colormap(myColorScale), daspect([1 1 1]), colorbar, axis tight;
    subplot(1, 3, 3), imagesc(fImg), title("Patch Based Filtering Result"), colormap(myColorScale), daspect([1 1 1]), colorbar, axis tight;
    
    imgHoneyC = corrupt(imgHoney);
%     disp(RMSD(imgHoneyC, imgHoney));
    fImg = patchFilter(imgHoneyC, [9, 9], [25, 25], Stdev(3), istd);
    RMSDvals(3) = RMSD(fImg, imgHoney);
    figure();
    subplot(1, 3, 1), imagesc(imgHoney), title("Original Image"), colormap(myColorScale), daspect([1 1 1]), colorbar, axis tight;
    subplot(1, 3, 2), imagesc(imgHoneyC), title("Added noise"), colormap(myColorScale), daspect([1 1 1]), colorbar, axis tight;
    subplot(1, 3, 3), imagesc(fImg), title("Patch Based Filtering Result"), colormap(myColorScale), daspect([1 1 1]), colorbar, axis tight;
end

function [cImg] = corrupt(img)
    img = double(img);
    std = (max(max(img)) - min(min(img)))*0.05;
    noise = normrnd(0, std, [size(img, 1), size(img, 2)]);
    cImg = img + noise;
end

function [newImg] = patchFilter(img, patchSize, windowSize, iGaussStd, istd)
%     patchSize and windowSize should be [oddnumber, oddnumber] both
    [M, N] = size(img);
    newImg = zeros([M, N]);
    pGaussianWeights = fspecial('gaussian', patchSize, istd);
%     point to denoise is point p, point on which patch is kept for getting
%     weight for point p is point k. (ik, jk) are the coordinates of point
%     k while (i, j) are coordinates of point p
    for i=1:M
        for j=1:N
%             window around point p in which we need to calculate the
%             weights
            [wMinI, wMaxI, wMinJ, wMaxJ] = winEndPoints(i, j, windowSize, img);
            denoiseWeights = zeros([wMaxI-wMinI+1, wMaxJ-wMinJ+1]);
%             Patch around point p and the margin the boundary keeps with
%             point p
            [pMinI, pMaxI, pMinJ, pMaxJ] = winEndPoints(i, j, patchSize, img);
            pPatch = img(pMinI:pMaxI, pMinJ:pMaxJ); % patch around point p
            iMarginNeg = i-pMinI; iMarginPos = pMaxI-i;
            jMarginNeg = j-pMinJ; jMarginPos = pMaxJ-j;
%             Gaussian weights around p for the patch
            gaussWeight = pGaussianWeights(int16(patchSize(1)/2)-iMarginNeg:int16(patchSize(1)/2)+iMarginPos,...
                int16(patchSize(2)/2)-jMarginNeg:int16(patchSize(2)/2)+jMarginPos);
            for ik=wMinI:wMaxI
                for jk=wMinJ:wMaxJ
                    kpMinI = max(1, ik-iMarginNeg); kpMaxI = min(M, ik+iMarginPos);
                    kpMinJ = max(1, jk-jMarginNeg); kpMaxJ = min(N, jk+jMarginPos);
                    if isequal(size(pPatch), [kpMaxI-kpMinI+1, kpMaxJ-kpMinJ+1])
                        kPatch = img(kpMinI:kpMaxI, kpMinJ:kpMaxJ); % patch around point k
                        weightedL2Dist = gaussWeight.*((kPatch-pPatch).^2);
                        weightedL2Dist = exp(-1*sum(weightedL2Dist, 'ALL')/(iGaussStd^2));
                        denoiseWeights(ik-wMinI+1, jk-wMinJ+1) = weightedL2Dist;
                    end
                end
            end
            denoiseWeights = denoiseWeights/sum(denoiseWeights, 'ALL');
            newIntensity = sum(denoiseWeights.*img(wMinI:wMaxI, wMinJ:wMaxJ), 'ALL');
            newImg(i, j) = newIntensity;
        end
    end
    %showImgBW(newImg, "Patch Base Filtering Result");
end

function [wMinI, wMaxI, wMinJ, wMaxJ] = winEndPoints(i, j, windowSize, img)
    [M, N] = size(img);
    wMinI = max(1, i+1-int16(windowSize(1)/2)); wMaxI = min(M, i+int16(windowSize(1)/2)-1);
    wMinJ = max(1, j+1-int16(windowSize(2)/2)); wMaxJ = min(N, j+int16(windowSize(2)/2)-1);
end

function val = RMSD(img1, img2)
    img1 = double(img1);
    img2 = double(img2);
    val = (mean2((img1 - img2).^2))^0.5;
end