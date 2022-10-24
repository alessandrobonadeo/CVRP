function S_final = tabu(S, coords, demand, capacity, N_max, alpha_max, ...
    M, P, beta_max, theta_min, theta_max)

% S is a cell array containing the solution
% coords = array nx2 (including depot)

S_final = cell(length(S),1);
S_i = S;
best_S_i = S;
best_cost = get_cost_solution(S, coords);

% select a random tabu parameter theta
theta = randi([theta_min theta_max]);
tabu_table = cell(theta,1);

% tabu search iterations
for iter = 1:N_max 
    
    neighbors = cell(2*alpha_max,1);
    neighbors_cost = 1.e4*ones(2*alpha_max,1);

    % find neighbors using TANE strategy
    for j = 1:alpha_max 
        neig = tane(best_S_i, coords, demand, capacity, M, P, beta_max);
        append = true;
        % search neig in the tabu table
        for t = 1:theta
            if isempty(tabu_table{t})
                continue
            end
            for r = 1:length(best_S_i)
                if length(tabu_table{t}{r}) == length(neig{r})             
                    if tabu_table{t}{r} == neig{r}
                        append = false;
                        break
                    end
                end
            end
        end
        if append % neig not in tabu table
            neighbors{j} = neig;
            neighbors_cost(j) = get_cost_solution(neig, coords);
        end
    end
    
    
    % find neighbors using TANEC strategy
    for k = 1:alpha_max 
        neig = tanec(best_S_i, coords, demand, capacity, M, P, beta_max);
        append = true;
        % search neig in the tabu table
        for t = 1:theta
            if isempty(tabu_table{t})
                continue
            end
            % if neig in the tabu table  
            for r = 1:length(best_S_i)
                if length(tabu_table{t}{r}) == length(neig{r})            
                    if tabu_table{t}{r} == neig{r}
                        append = false;
                        break
                    end
                end
            end
        end
        if append % neig not in tabu table
            neighbors{k+alpha_max} = neig;
            neighbors_cost(k+alpha_max) = get_cost_solution(neig, coords);
        end
    end
    
    [min_neig_cost, min_neig_idx] = min(neighbors_cost);
    S_i = neighbors{min_neig_idx};

    % update tabu table
    for k = theta:-1:2
        tabu_table{k} = tabu_table{k-1};
    end
    tabu_table{1} = S_i;
    
    % improve the solution
    if min_neig_cost < best_cost 
        best_S_i = S_i;
        best_cost = min_neig_cost;
    end

end % end tabu iterations

S_final = best_S_i;

end