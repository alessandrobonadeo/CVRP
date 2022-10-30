# Capacitated Veichle Routing Problem (CVRP)
The project is about the solution of the veichle routing problem with limited capcity for each veichles. We have choosen to implement two classic algorithms: the sweep [[1]](#1), which is a constructive and sequential method, and a newest and more sophisticated one based on tabu search [[2]](#2), which is an iterative method. The final goal was to use the first algorithm to generate a suboptimal solution and pass it as an input to the second one to see how the soluton would improve. The documentation of the implemented functions and the results can be found in the [report](https://github.com/alessandrobonadeo/CVRP/blob/main/BA_VRP_project.pdf) while the data used for the experiment and the numerical results were taken from this [library](http://vrp.galgos.inf.puc-rio.br/index.php/en/9) (set A,B,M).

## References
<a id="1">[1]</a> 
B. E. Gillett and L. R. Miller, “A heuristic algorithm for the vehicle-dispatch problem,”
Operations Research, vol. 22, no. 2, pp. 340–349, 1974.

<a id="2">[2]</a> 
G. Barbarosoglu and D. Ozgur, “A tabu search algorithm for the vehicle routing prob-
lem,” Computers & Operations Research, vol. 26, no. 3, pp. 255–270, 1999.
