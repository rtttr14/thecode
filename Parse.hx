//haxe -main Parse -cpp out && ./out/Parse.exe
import sys.io.File;
import haxe.Http;
import haxe.Json;

typedef Data = {
    var prices:Array<Float>;
    var dates:Array<String>;
}

class Parse {
    public static function parseBinance(filename: String, symbol:String="ORDIUSDT", interval:String, requestsLeft:Int=4, limit:Int=1000):Data {
        parse(filename, symbol, interval, requestsLeft, limit);
        return readCSV(filename);
    }

    public static function parse(filename:String, symbol:String="ORDIUSDT", interval:String, requestsLeft:Int=4, limit:Int=1000) {
        var allData:Array<String> = [];
        allData.push("openTime,open,high,low,close,volume,closeTime");

        var intervalMs = switch(interval) {
            case "1m": 60;
            case "3m": 3*60;
            case "5m": 5*60;
            case "15m": 15*60;
            case "30m": 30*60;
            case "1h": 60*60;
            case "2h": 2*60*60;
            case "4h": 4*60*60;
            case "6h": 6*60*60;
            case "8h": 8*60*60;
            case "12h": 12*60*60;
            case "1d": 24*60*60;
            default: 60*60;
        };

        var now = Date.now().getTime();// + 30 * 60 * 1000;
        now -= (0) * 1 * 60 * 1000; //get previous records, manual-handed prediction tests
        var endTime = now - (requestsLeft-1) * limit * intervalMs; 

        var allJson:Array<Array<Float>> = [];
        function fetchChunk() {
            var url = "https://api.binance.com/api/v3/klines?symbol="+symbol+"&interval="+interval+"&limit="+limit+"&endTime="+Std.string(endTime);
            var http = new Http(url);

            http.onData = function(data:String) {
                try {
                    var json:Array<Dynamic> = Json.parse(data);

                    for (candle in json) {
                        allJson.push(candle);
                    }

                    if (json.length > 0) {
                        endTime = json[0][0] - 1; 
                    }

                    requestsLeft--;
                    if (requestsLeft > 0) {
                        fetchChunk();
                    } else {
                        allJson.sort(function(a, b) return Std.int(a[0] - b[0]));
                        for (candle in allJson) {
                            allData.push('${Date.fromTime(candle[0])},${candle[1]},${candle[2]},${candle[3]},${candle[4]},${candle[5]},${candle[6]}');
                        }

                        File.saveContent(filename, allData.join("\n"));
                        trace("Saved " + allData.length + " rows to " + filename);
                    }

                } catch(e) {
                    trace("Parse error: " + e);
                }
            }

            http.onError = function(msg) {
                trace("HTTP error: " + msg);
            }

            http.request(false);
        }

        fetchChunk();
    }

    public static function readCSV(filename: String):Data {
        if (!sys.FileSystem.exists(filename)) {
            throw("File not found: " + filename);
        }

        var content = File.getContent(filename);
        var lines = content.split("\n");

        var prices:Array<Float> = [];
        var dates:Array<String> = [];
        // пропускаем заголовок
        for (i in 1...lines.length) {
            var line = lines[i];
            if (line == "") continue;

            var parts = line.split(",");
            var timestamp = parts[0];
            var price = Std.parseFloat(parts[1]);

            prices.push(price);
            dates.push(timestamp);
        }

        return {
            prices: prices, 
            dates: dates
        };
    }
}
