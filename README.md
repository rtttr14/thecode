Parse.hx - parsing binance through rest api

Genome.hx - just some basic example of part of genetic evolution algorithm of cyclic/fractal patterns

ml.hx - basic ml optimization, 1d gradient and some "stohastic"

= conceptual prototype, demonstrates integration of GA(exploring the solution space) and ML for data-driven decision support. features and mutations in Genome.hx, make "alphabet" - cycles random/sd/other, with period = historical.length / n, where n > 2, fitness like you like(i made it to value direction more to note on chart), cycles are just sin wave or simple addition by module<br /><br />
= room for improvement in performance, scalability, and parallelization. multithreaded just genetic evolution. compiled haxe code with optimized flags 1-2 minutes full training 64k size dataset on cpu xeon e3-1270<br />

![alt text](https://raw.githubusercontent.com/rtttr14/thecode/refs/heads/master/approximation.png "")

btw. have next idea for computer vision, without all that complexity. just shitposting here for now
self-similar pattern search. imagine skin and hair. take random pixel, suppose it's on skin, expand it orthogonally with function that expands on similar colored pixels (self-similar pattern search). now go on expanding until algorithm sees different pattern/color in our case, black if it's hair. saf. improve it with maching learning and symmetry, like structures expands and if it sees eye, then it should see self-similar eye on other side of face to envelope in same way - this is improves that algorithm really hard. saf. 
