import trade.Random;
import sys.thread.Mutex;


typedef Gene = {
    offset: Int,
    amp: Float,
    time: Int
}

class Genome {
    // Алфавит — циклы: амплитуда и длительность
    public static var shared:Array<Gene> = [
        {offset: 0, amp: 0.0, time: 2}
    ];

    public static inline function getShared():Array<Gene> {
        return Genome.shared;
    }

    public static inline function mutate(child:Array<Int>, rate:Float, mutex:Mutex):Array<Int> {
        if (Random.random() < 0.25 * rate) { //заменяем один ген
            child[Random.nextInt(child.length)] = Random.nextInt(Genome.shared.length);
        } else if (Random.random() < 0.1 * rate){ //заменяем гены
            var n = Random.smallerBias(child.length);
            for (i in 0...n) {
                child[Random.nextInt(n)] = Random.nextInt(Genome.shared.length);
            }
        } else if (Random.random() < 0.2 * rate) { //добавляем дополнительный ген 0.5
            var index = Random.biggerBias(Genome.shared.length);
            /* if (Genome.shared[index].time < 500) {
                child.push(index);
            } */
            child.push(index);
        } else if (Random.random() < 0.1 * rate) { //удаляем ген
            var index = Random.smallerBias(child.length);
            if (index < 3) child.splice(index, 1);
        } 
        return child;
    }
}


