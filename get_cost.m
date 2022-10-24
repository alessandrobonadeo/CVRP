function c = get_cost(route, coords)
c = 0;
if route(1) ~= 1
    c = c + norm(coords(route(1),:) - coords(1,:),2);
end
for i = 1:length(route)-1
    c = c + norm(coords(route(i),:) - coords(route(i+1),:),2);
end
if route(end) ~= 1
    c = c + norm(coords(route(end),:) - coords(1,:),2);
end
end