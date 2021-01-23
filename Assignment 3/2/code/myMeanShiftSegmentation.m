function [finalImg] = myMeanShiftSegmentation(img, hr, hs, neighbours, iterations, scaleFactor)
    img = im2double(img);
    img = imresize(img, scaleFactor);
    
    finalImg = zeros(size(img));
    [row, col, channels] = size(img);
    flat = zeros([row*col, 5]);     % flat the image to 5 channels and 1D in each channel
    for i=1:row
        for j=1:col
            flat((i-1)*col + j, :) = [img(i, j, 1)/hr, img(i, j, 2)/hr, img(i, j, 3)/hr, i/hs, j/hs];
        end
    end
    
    for iter=1:iterations
        [nearestN, dist] = knnsearch(flat, flat, 'k', neighbours);
        temp = flat;
        for i=1:row*col
            w = exp(-0.5*(dist(i, :).^2))';
            s = sum(w);
            flat(i, 1:3) = sum([w,w,w].*temp(nearestN(i, :), 1:3))/s;
        end
    end
    
    for i=1:row
        for j=1:col
            finalImg(i, j, :) = flat((i-1)*col + j, 1:3);
        end
    end
    
end


