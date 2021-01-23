function [msk] = cleanMask(mask, threshold)
    msk = mask;
    [M,N] = size(mask);
    centerI = ceil(M/2);
    centerJ = ceil(N/2);
    
    i = centerI;
    while(i>0 && sum(mask(i,:))>threshold)
        i = i-1;
    end
    msk(1:i,:) = 0;
    i = centerI;
    while(i<M+1 && sum(mask(i,:))>threshold)
        i = i+1;
    end
    msk(i:M,:) = 0;
    
    j = centerJ;
    while(j>0 && sum(mask(:,j))>threshold)
        j = j-1;
    end
    msk(:,1:j) = 0;
    j = centerJ;
    while(j<N+1 && sum(mask(:,j))>threshold)
        j = j+1;
    end
    msk(:,j:N) = 0;
end