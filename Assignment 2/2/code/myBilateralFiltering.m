function [rmsd,im_noisy, newim] = myBilateralFiltering(im, sigma_space, sigma_intensity)
    [M,N] = size(im);
    im_min = double(min(im,[],'all'));
    im_max = double(max(im,[],'all'));
    % corrupt the image with IID gaussian noise
    im_noisy = double(im) + 0.05*im_max*randn(M,N);
    window_len = round(3*sigma_space);

    im_max = 2*im_max; 
    %%
    % store_intensity_gaussians is nothing but a matrix storing the output
    % values for all combinations of intensity differences given to the
    % gaussian intensity kernel. This can be computed in time O(MN), so we
    % can simply read off these values when needed. 
    store_intensity_gaussians = zeros(im_max+1, im_max+1);
    for i = 1 : im_max+1
        for j = 1 : im_max+1
            store_intensity_gaussians(i,j) = exp(-((i-j)^2)/(2*sigma_intensity*sigma_intensity));
        end
    end
    % output image 
    newim = zeros(M,N);
    for i = 1:M
        for j = 1:N
            [iLow, iHigh, jLow, jHigh] = WindowCorners(im_noisy, window_len, i, j);
            window = im_noisy(iLow:iHigh,jLow:jHigh);
            spatial_mask = spacial_gaussian_filter(window, sigma_space, i-iLow+1, j-jLow+1);
            intensity_mask = intensity_gaussian_filter(reshape(window,[numel(window) 1]), im_noisy(i,j), store_intensity_gaussians);
            intensity_mask = reshape(intensity_mask, size(window));
            mask = spatial_mask.*intensity_mask;
            mask = mask./sum(mask,'all');
            newim(i,j) = sum(mask.*window, 'all');
            %newim(i,j) = sum(spatial_mask.*window, 'all');
        end
    end
    newim = cast(newim, 'uint8');

    % RMSD CALCULATION
    rmsd_matrix = (im - newim).*(im-newim);
    rmsd = sqrt(sum(rmsd_matrix,'all')/numel(rmsd_matrix)); 

end
%%
% Function to obtain the corners of the window, given the coordinates of
% the pixel around which the window is to be made. 
function [iLow, iHigh, jLow, jHigh] = WindowCorners(img, windowSize, centerI, centerJ)
    [maxI, maxJ] = size(img);
    split = floor(windowSize/2);
    iLow = max(centerI - split, 1); iHigh = min(maxI, centerI + split);
    jLow = max(centerJ - split, 1); jHigh = min(maxJ, centerJ + split);
end

%% 
% Spatial gaussian mask. 
function spatial_mask = spacial_gaussian_filter(window, sigma_space, center_i, center_j)
    [m,n] = size(window);
    %use separability
    u = zeros(1,m);
    for i = 1:m
        u(i) = exp(-((i-center_i)^2)/(2*sigma_space*sigma_space));
    end
    v = zeros(1,n);
    for j = 1:n
        v(j) = exp(-((j-center_j)^2)/(2*sigma_space*sigma_space));
    end
    spatial_mask = transpose(u)*v;
    spatial_mask = spatial_mask./sum(spatial_mask,'all');
end

%%
% Read off the intensity kernel outputs from the matrix. Note that this has
% been vectorized in the bilateral filtering loop. 
function intensity_mask = intensity_gaussian_filter(pixel_intensity, center_intensity, store_intensity_gaussians)
    x = max(1, round(pixel_intensity)+1);
    y = max(1, round(center_intensity)+1);
    intensity_mask = store_intensity_gaussians(x,y); 
end