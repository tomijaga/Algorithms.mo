import Text "mo:base/Text";
import Char "mo:base/Char";
import Iter "mo:base/Iter";
import Nat8 "mo:base/Nat8";
import Nat32 "mo:base/Nat32";

module {
    public func caeser(text: Text, _shift: Nat8) : Text{
        let shift = Nat32.fromNat(Nat8.toNat(_shift));

        let iter = Iter.map<Char, Text>(text.chars(), func(c): Text{
            let n = Char.toNat32(c);

            let shifted_char = if (Char.isAlphabetic(c)){
                if (n + shift <= 90){
                    Char.fromNat32(n + shift);
                } else {
                    Char.fromNat32(n + shift - 26);
                }
            }else{
                if (n + shift <= 122 ){
                    Char.fromNat32(n + shift);
                } else {
                    Char.fromNat32(n + shift - 26);
                }
            };

            Char.toText(shifted_char)

        });

        Text.join("", iter)
    };
};