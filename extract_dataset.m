function [vehicles, optimal_value, dimension, capacity, coordinates, demand] = extract_dataset(dataset)
A = readlines(dataset);
vehicles = double(extractBetween(A(2),'COMMENT : (Augerat et al, No of trucks: ',...
    ', Optimal value'));
optimal_value = double(extractBetween(A(2),'Optimal value: ', ')'));
dimension = double(extractAfter(A(4),'DIMENSION : '));
capacity = double(extractAfter(A(6),'CAPACITY : '));
coord = split(extractAfter(A(8:7+dimension),' '));
x = str2double(coord(:,2)); 
y = str2double(coord(:,3));
coordinates = [x,y];
demand = str2double(split(extractBetween(A(9+dimension:8+2*dimension), ' ', ' ')));
end