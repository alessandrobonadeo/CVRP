function S = tanec(S, coords, demand, capacity, M, P, beta_max)

% S is a cell array containing the solution
% coords = array nx2 (including depot)
% demand = array nx1 (including depot)
% (vehicle) capacity is a scalar

% setting some parameters
% M=2; % maximum number of vertices to be chosen from R1
% P=2; % maximum number of vertices to be chosen from R2
% beta_max = 10; % number of 2-opt iterations

% Removing the depot
% for i = 1:length(S)
%     R = S{i};
%     S{i} = R(2:end);
% end

loop = true;

while loop
    
    % choose randomly 2 different routes
	R1_idx = randi(length(S));
	while true
		R2_idx = randi(length(S));
	    if R2_idx ~= R1_idx
			break
    end
end
	R1 = S{R1_idx};
	R2 = S{R2_idx};
    
    % choose randomly m vertices from R1
	m = randi(min(M, length(R1)));
    % choose randomly p vertices from R2
	p = randi(min(P, length(R2)));

    % start with R1
    P2 = polyshape(coords(R2,:), 'simplify', false);
    [C2_x, C2_y] = centroid(P2);
    C2 = [C2_x, C2_y];
    ratio1 = zeros(length(R1),1);
    for i=1:length(R1)
        R1_i = [R1(1:i-1), R1(i+1:end)];
        P1_i = polyshape(coords(R1_i,:), 'simplify', false);
        [C1_i_x, C1_i_y] = centroid(P1_i);
        C1_i = [C1_i_x, C1_i_y];
        d1 = norm(C1_i - coords(R1(i),:), 2);
        d2 = norm(C2 - coords(R1(i),:), 2);
        ratio1(i) = d1/d2;
    end
    [~, sort_index1] = sort(ratio1, 'descend');
    R1_sort = R1(sort_index1);

    % repeat for R2
    P1 = polyshape(coords(R1,:), 'simplify', false);
    [C1_x, C1_y] = centroid(P1);
    C1 = [C1_x, C1_y];
    ratio2 = zeros(length(R2),1);
    for i=1:length(R2)
        R2_i = [R2(1:i-1), R2(i+1:end)];
        P2_i = polyshape(coords(R2_i,:), 'simplify', false);
        [C2_i_x, C2_i_y] = centroid(P2_i);
        C2_i = [C2_i_x, C2_i_y];
        d1 = norm(C2_i - coords(R2(i),:), 2);
        d2 = norm(C1 - coords(R2(i),:), 2);
        ratio2(i) = d1/d2;
    end
    [~, sort_index2] = sort(ratio2, 'descend');
    R2_sort = R2(sort_index2);
    
    % extract the vertices from the ordered arrays
	R1_extracted = R1_sort(1:m);
	R2_extracted = R2_sort(1:p);

    % check if depot was extracted 
    for i = 1:length(R1_extracted)
        if R1_extracted(i) == 1
            R1_extracted = [R1_extracted(1:i-1), R1_extracted(i+1:end)];
            break
        end
    end
    for i = 1:length(R2_extracted)
        if R2_extracted(i) == 1
            R2_extracted = [R2_extracted(1:i-1), R2_extracted(i+1:end)];
            break
        end
    end

    % update routes
    for i = 1:length(R1_extracted)
        for j = 1:length(R1)
            if R1(j) == R1_extracted(i)
                R1 = [R1(1:j-1), R1(j+1:end)];
                break
            end
        end
    end
    for i = 1:length(R2_extracted)
        for j = 1:length(R2)
            if R2(j) == R2_extracted(i)
                R2 = [R2(1:j-1), R2(j+1:end)];
                break
            end
        end
    end

    % insert the vertices 
	R1_new = insertion(R1, R2_extracted, coords);
	R2_new = insertion(R2, R1_extracted, coords);

    % check if the solution is unfeasible
	if sum(demand(R1_new))>capacity || sum(demand(R2_new))>capacity
		continue 
end
    
    % apply the 2-opt for beta_max times
    for i = 1:beta_max
        R1_new = opt2(R1_new, coords);
	    R2_new = opt2(R2_new, coords);
    end
    
    % update the solution
	S{R1_idx} = R1_new;
	S{R2_idx} = R2_new;
	

    loop = false;

end % end while


end % end function