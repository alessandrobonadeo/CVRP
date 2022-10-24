function R = opt2(R, coords)

% Compute the cost matrix
% coords = array nx2 (including depot)
c = pdist(coords);
c = squareform(c);

% R = [R, 1];

k = length(R)-1;
edge_combination = (k+1)*(k-2)*0.5;

t=1;
flag = true;
while flag && t <= edge_combination

    delta = zeros(length(R));
    
    for i = 1:length(R)-3
        for j = (i+2):(length(R)-1)
            delta(i,j) = c(R(i),R(i+1)) + c(R(j),R(j+1)) - ...
                    c(R(i),R(j)) - c(R(i+1),R(j+1));
        end % j
    end % i
    
    % [delta_max, ind] = max(delta, [], 'all');
    [max_row, ind_row_vector] = max(delta, [], 1);
    [delta_max, ind_col] = max(max_row);
    ind_row = ind_row_vector(ind_col);
    

    if delta_max > 0
        % do swap
        a = min(ind_row, ind_col);
        b = max(ind_row, ind_col);
        R = [R(1:a), R(b:-1:a+1), R(b+1:end)];
    else
        % no improvement
        flag = false;
    end
 
    t=t+1;

end % while
    
end