function [labels, centroid] = kmean(img, K) 
    rows = size(img);
    disp(K);  
    labels = zeros(rows(1), 1);  
    rng(40);
    [centroid, idx] = datasample(img, K, 'Replace',false); 
    
    flag = true;
    
    %distances betweeen point and each centroid
    distances = zeros(K, 1); 
    
    %Keeps track of number of points in each cluster
    count = zeros(1, K);
    
    %Inititialize labels and number of points in each cluster
    for i = 1:K
        labels(idx(i)) = i; 
        count(i) = 1; 
    end
    
    
    %Obj function value 
    J = 1; 
    new_J = 0; 
    
    %Keep distances that will be used to calculate obj function 
    while flag

        %For each pixel, we are going to find the closest centroid and
        %assign it to that cluster
        new_centroids = centroid; 
        for i = 1:rows(1)
            %Get distance between pixel and all the centroids 
            for j = 1:K
                distances(j) = sqrt(sum((centroid(j, : ) - img(i, : )).^ 2));
            end
            [ordered, nearest] = sort(distances);
            
          
            %Calculate obj function value of new centroids and labels 
            new_J = new_J + distances(nearest(1));  
               
            %If the point is assigned to a new cluster 
            if labels(i) ~= nearest(1)
                for j = 1:K
                    %found the old label 
                    if(labels(i) == j)
                        %Update centroid of old cluster 
                        new_centroids(j,:) = (new_centroids(j, :)*count(j) - img(i, :))/ (count(j) - 1); 
                        count(j) = count(j) - 1; 
                    end
                end
                labels(i) = nearest(1);
                count(nearest(1)) = count(nearest(1)) + 1;
                %update value of centroid of the new cluster
                new_centroids(nearest(1), :) = (new_centroids(nearest(1), :)*(count(nearest(1)) - 1) + img(i, :))/count(nearest(1));  
            end
        end
        
        %Stopping condition
        if abs(J - new_J)/J < 10e-3
            flag = false; 
            break
        end
        %Update obj func value
        J = new_J; 
        new_J = 0;  
    
        %Calculate new centroids
        centroid = new_centroids;
        
    end

end
    
