function S = tane(S, coords, demand, capacity, M, P, beta_max)

% S is a cell array containing the solution
% coords = array nx2 (including depot)
% demand = array nx1 (including depot)
% (vehicle) capacity is a scalar

% setting some parameters
% M=2; % maximum number of vertices to be chosen from R1
% P=2; % maximum number of vertices to be chosen from R2
% beta_max = 10; % number of 2-opt iterations

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
	
    % extract the vertices 
	R1_extracted = zeros(1,m);
	R2_extracted = zeros(1,p);

	for i=1:m
        while true
		    idx = randi(size(R1));
            if idx ~= 1
                break
            end
        end        
		R1_extracted(i) = R1(idx);
		R1 = [R1(1:idx-1), R1(idx+1:end)];
end

	for i=1:p
        while true
		    idx = randi(size(R2));
            if idx ~= 1
                break
            end
        end
		R2_extracted(i) = R2(idx);
		R2 = [R2(1:idx-1), R2(idx+1:end)];
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

