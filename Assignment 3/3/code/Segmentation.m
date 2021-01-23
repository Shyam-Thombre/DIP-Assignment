function [cluster1, out] = Segmentation(img, scaling)
    img = imresize(img, scaling);
    out = myMeanShiftSegmentation(img, 1, sqrt(size(img, 1)), 150, 20, 1);
    out = myMeanShiftSegmentation(out, 1, sqrt(size(img, 2)), 150, 20, 1);
    
    [row, col, channels] = size(out);
    flatImg = zeros([row*col, channels+2]);
    
    for i=1:row
        for j=1:col
            flatImg((i-1)*col + j, :) = [img(i, j, 1), img(i, j, 2), img(i, j, 3), i, j];
        end
    end
    
    clusters = kmeans(flatImg, 3);
    
    cluster1 = zeros([size(out, 1), size(out, 2), 3]);
    
    for i=1:size(clusters, 1)
        cluster1(ceil(i/col), mod(i, col) + 1, clusters(i)) = 1;
    end
end
