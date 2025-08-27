= conceptual prototype, demonstrates integration of GA(exploring the solution space) and ML for data-driven **decision support**(all risks on yourself). features and mutations in Genome.hx, make "alphabet" - cycles random/sd/other, with period = historical.length / n, where n > 2, fitness like you like(i made it to value direction more, then exact price and added volatility weight), cycles are just sin wave or simple addition by module<br />
= room for improvement in performance, scalability, and parallelization. multithreaded just genetic evolution. compiled haxe code with optimized flags 1-2 minutes full training 64k size dataset on cpu xeon e3-1270<br />

Parse.hx - parsing binance through rest api

Genome.hx - just some basic example of part of genetic evolution algorithm of cyclic/fractal patterns

ml.hx - basic ml optimization, 1d gradient and some "stohastic"

![alt text](https://raw.githubusercontent.com/rtttr14/thecode/refs/heads/master/approximation.png "")

