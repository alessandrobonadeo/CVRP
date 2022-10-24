function solution = sweep(vehicles, dimension, capacity, coords, demand)

% center location with respect to depot 
center_coords = coords - coords(1,:);
depot = center_coords(1,:);
locations = center_coords(2:dimension,:);
demand = demand(2:end);

% compute polar coordinates
% [~,angles] = cart2pol(locations);
angles = atan2(locations(:,2), locations(:,1));
% (0,2pi) representation
for i = 1:length(angles)
    if angles(i) < 0
          angles(i) = angles(i) + (2*pi);
    end
end

% order locations with respect to the angle
[~, index] = sort(angles);
% rho = radius(index);
% ordered_coords = locations(index,:);
ordered_demand = demand(index);

% route creation
tot = 0;
n_routes = 1;
i = 1;

routes = cell(vehicles,1);

while i < dimension
    if tot + ordered_demand(i) <= capacity
        routes{n_routes} = [routes{n_routes}, index(i)];
        tot = tot + ordered_demand(i);
        i = i + 1;
    else 
        tot = 0;
        n_routes = n_routes + 1;
    end
end

% apply TSP to each route
solution = cell(n_routes,1);
for i = 1:n_routes
    route_i = [1, routes{i}+1];
    route_loc = [depot; locations(routes{i},:)];
    % tsp da rivedere
    path = tsp_script(route_loc(:,1), route_loc(:,2));
    solution{i} = route_i(path(1:end-1));
end


end