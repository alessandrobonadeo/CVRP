function R = insertion(R, VP, coords)

% insert vertices in VP into a route R
% R = array containing vertices already in the route
% VP = array containing the vertices to be inserted 
% coords = array nx2 (including depot)

% Compute the (euclidean) distance matrix
dist = pdist(coords);
dist = squareform(dist);

while ~isempty(VP)

    k_best = 0;
    min_cost = 1.e7;
    for k = 1:length(VP)
        vk = VP(k);
        value_min_i = min(dist(vk,R));
        if value_min_i < min_cost
		    k_best = k;
		    min_cost = value_min_i;
        end
    end
    vk = VP(k_best);
    VP = [VP(1:k_best-1), VP(k_best+1:end)];
    
    best_i = 0;
    best_cost = 1.e7;
    for i = 1:(length(R)-1)
	    j = i+1;
        value = dist(R(i),vk) + dist(vk,R(j)) - dist(R(i),R(j));
	    if  value < best_cost
		    best_cost = value;
		    best_i = i;
	    end
    end
    R = [R(1:best_i), vk, R(best_i+1:end)];
   
end % end while

end % end function
