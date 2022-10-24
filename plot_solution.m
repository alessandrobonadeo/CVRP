function plot_solution(S, coords)
figure 
hold on
for i = 1:length(S)
    R = S{i};
    a = coords([R,1],:);
    plot(a(:,1), a(:,2), '-o');
end
hold off
end