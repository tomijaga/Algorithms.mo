import Result "mo:base/Result";

module{
    public func hammingDistance(t1: Text, t2: Text): Result.Result<Nat, Text>{
        let (a, b) = (t1.chars(), t2.chars());

        var distance = 0;

        loop{
            
            switch ((a.next(), b.next())){
                case ((?char_a, ?char_b)) {
                    if (char_a != char_b){
                        distance += 1;
                    };
                };

                case ((null, null)) return #ok(distance);
                case (_) return #err("The two texts must be the same length");
            }
        };
    };
};