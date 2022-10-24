function feasible = isfeasible(S, demand, capacity)
feasible = true;
for i = 1:length(S)
    R = S{i};
    if sum(demand(R)) > capacity
        feasible = false;
        break
    end
end
end