//1d gradient
static function learnGradient(genome:Array<Int>, learningRate:Float = 0.01, epsilon:Float = 1e-6, maxIterations:Int = 1000) {
    var iter = 0;
    var bestScore = fitness(genome, Genome.shared);

    while (iter < maxIterations) {
        var improved = false;

        for (gene in genome) {
            var op = Genome.shared[gene];
            var oldAmp = op.amp;

            op.amp = oldAmp + epsilon;
            var fPlus = fitness(genome, Genome.shared);

            op.amp = oldAmp - epsilon;
            var fMinus = fitness(genome, Genome.shared);

            var grad = (fPlus - fMinus) / (2 * epsilon);

            op.amp = oldAmp - learningRate * grad;

            var newScore = fitness(genome, Genome.shared);
            if (newScore < bestScore) {
                bestScore = newScore;
                improved = true;
            } else {
                op.amp = oldAmp;
            }
        }

        Sys.stdout().writeString('iter=' + iter + ' score=' + bestScore + "\r");
        Sys.stdout().flush();

        if (!improved) {
            learningRate *= 0.5;
            if (learningRate < epsilon) break;
        }

        iter++;
    }

    Sys.stdout().writeString("\n");
}

//stochastic
static function learnFast(genome:Array<Int>, delta:Float = 10, minDelta:Float = 1e-3) {
	var bestScore = fitness(genome, Genome.shared);
	var iter = 0;

	while (true) {
		var improved = false;

		for (gene in genome) {
			var op = Genome.shared[gene];
			var oldAmp = op.amp;
			var perturb = oldAmp * 0.1 * (2*Random.random() - 1); // случайное смещение

			op.amp = oldAmp + perturb;
			var newScore = fitness(genome, Genome.shared);

			if (newScore < bestScore) {
				bestScore = newScore;
				improved = true;
			} else {
				op.amp = oldAmp;
			}

			var oldTime = op.time;
			var perturbTime = oldTime * 0.1 * (2*Random.random() - 1); // случайное смещение
			op.time = Std.int(oldTime + perturbTime);
			newScore = fitness(genome, Genome.shared);
			if (newScore < bestScore) {
				bestScore = newScore;
				improved = true;
			} else {
				op.time = oldTime;
			}

			/*
			var oldOffset = op.offset;
			var perturbTime = oldOffset * 0.1 * (1.5*Random.random() - 1); // случайное смещение с перекосом к началу
			op.offset = Std.int(oldOffset + perturbTime);
			newScore = fitness(genome, Genome.shared);
			if (newScore < bestScore) {
				bestScore = newScore;
				improved = true;
			} else {
				op.offset = oldOffset;
			}
			*/
		}

		iter++;
		if (iter % 5 == 0) Sys.stdout().writeString('score='+bestScore+", delta="+delta+"\r");

		if (!improved) {
			delta *= 0.8;
			if (delta < minDelta) break;
		}
	}

	Sys.stdout().writeString("\n");
}