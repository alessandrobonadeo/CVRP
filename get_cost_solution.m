function c = get_cost_solution(S, coords)
c = 0;
for i = 1:length(S)
    c = c + get_cost(S{i}, coords);
end
end