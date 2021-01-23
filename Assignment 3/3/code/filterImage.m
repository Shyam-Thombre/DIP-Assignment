function [filteredImage, radiusMatrix] = filterImage(img, mask, alpha, threshold)
    [rows, cols] = size(mask);
    radiusMatrix = zeros(size(mask));
    filteredImage = img;
    for i=1:rows
        for j=1:cols
            if mask(i,j) ~= 1
                r = alpha;
                low = 0;
                high = alpha;
                k=1;
                while (high-low) >= threshold
                    filt = fspecial('disk', r);
                    filt(filt>0) = 1;
                    filt = filt/sum(filt, 'all');
                    [fs, ~] = size(filt);
                    r = (fs-1)/2;
                    
                    Up = min(i,r);
                    Down = min(rows-i,r);
                    Left = min(j,r);
                    Right = min(cols-j,r);
                    
                    msk = mask(i-Up+1:i+Down, j-Left+1:j+Right);

                    filt = filt(r-Up+2:r+1+Down, r-Left+2:r+1+Right);
                    filt = filt/sum(filt, 'all');
                    
                    out = sum((filt.*msk), 'all');
                    if (k==1) && (out==0)
                        break
                    end
                    k = k+1;
                    if out > 0
                        high = r;
                        r = (low+r)/2;
                    else
                        low = r;
                        r = (high+r)/2;
                    end
                end
                imgRegion = img(i-Up+1:i+Down, j-Left+1:j+Right, :);
                for k=1:3
                    filteredImage(i,j,k) = sum((filt.*imgRegion(:,:,k)), 'all');
                end
                radiusMatrix(i,j) = r/alpha;
            end
        end
    end
    filteredImage = uint8(filteredImage);
end