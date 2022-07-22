import Iter "mo:base/Iter";
import Char "mo:base/Char";
import Text "mo:base/Text";

module{
    func prepend(c: Char, iter: Iter.Iter<Char>): Iter.Iter<Char>{
        var popped = false;

        object{
            public func next() : ?Char {
                if (not popped){
                    popped := true;
                    ?c
                }else{
                    iter.next();
                };
            };
        }
    };

    func emptyIter(): Iter.Iter<Char>{
        object{
            public func next() : ?Char {
                null
            };
        }
    };

    public func reverse(t: Text): Text {
        var iter = emptyIter();

        for (c in t.chars()){
            iter := prepend(c, iter);
        };

        let toText = func(c: Char): Text { Char.toText(c)};

        Text.join("", Iter.map(iter, toText))
    };
}