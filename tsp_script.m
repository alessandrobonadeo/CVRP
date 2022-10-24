function path = tsp_script(x,y)

nStops = length(x); 
stopsLon = x; 
stopsLat = y; 

idxs = nchoosek(1:nStops,2);

dist = hypot(stopsLat(idxs(:,1)) - stopsLat(idxs(:,2)), ...
             stopsLon(idxs(:,1)) - stopsLon(idxs(:,2)));
lendist = length(dist);

G = graph(idxs(:,1),idxs(:,2));

tsp = optimproblem;
trips = optimvar('trips',lendist,1,'Type','integer','LowerBound',0,'UpperBound',1);
tsp.Objective = dist'*trips;

constr2trips = optimconstr(nStops,1);
for stop = 1:nStops
    whichIdxs = outedges(G,stop); % Identify trips associated with the stop
    constr2trips(stop) = sum(trips(whichIdxs)) == 2;
end
tsp.Constraints.constr2trips = constr2trips;


opts = optimoptions('intlinprog','Display','off');
tspsol = solve(tsp,'options',opts);
tspsol.trips = logical(round(tspsol.trips));
Gsol = graph(idxs(tspsol.trips,1),idxs(tspsol.trips,2),[],numnodes(G));

tourIdxs = conncomp(Gsol);
numtours = max(tourIdxs); 

k = 1;
while numtours > 1 %
    
    for ii = 1:numtours
        inSubTour = (tourIdxs == ii); 
        a = all(inSubTour(idxs),2); 
        constrname = "subtourconstr" + num2str(k);
        tsp.Constraints.(constrname) = sum(trips(a)) <= (nnz(inSubTour) - 1);
        k = k + 1;        
    end
    
   
    [tspsol,fval,exitflag,output] = solve(tsp,'options',opts);
    tspsol.trips = logical(round(tspsol.trips));
    Gsol = graph(idxs(tspsol.trips,1),idxs(tspsol.trips,2),[],numnodes(G));
    
    tourIdxs = conncomp(Gsol);
    numtours = max(tourIdxs);  
end

edges = [idxs(tspsol.trips,1), idxs(tspsol.trips,2)];
A = zeros(nStops, nStops);
for e_idx = 1:size(edges,1)
    a = edges(e_idx,1);
    b = edges(e_idx,2);
    A(a,b) = 1;
    A(b,a) = 1;
end
path = [1];
for i=1:nStops-1
    res = find(A(path(i),:));
    a = res(1);
    b = res(2);
    if(any(path==a))
        path = [path, b];
    else
        path = [path, a];
    end
end
path = [path, 1];


