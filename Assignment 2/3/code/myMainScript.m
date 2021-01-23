%% MyMainScript

tic;
%% Your code here
optSigma = [0.055, 0.055, 0.06];
rmsdOpt = myPatchBasedFiltering(optSigma, 1); disp(rmsdOpt);
rmsd9 = myPatchBasedFiltering(optSigma*0.9, 1); disp(rmsd9);
rmsd11 = myPatchBasedFiltering(optSigma*1.1, 1); disp(rmsd11);
toc;

%% Mask that makes patch isotropic
pGaussianWeights = fspecial('gaussian', [9,9], 1);
figure();
imagesc(pGaussianWeights), daspect([1 1 1]), colormap(gray), colorbar;
