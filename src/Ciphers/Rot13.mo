import Prim "mo:⛔";
import Debug "mo:base/Debug";
import Char "mo:base/Char";
import Iter "mo:base/Iter";
import Text "mo:base/Text";

module{
    public func rot13(text: Text) : Text{
        let iter = Iter.map<Char, Text>(text.chars(), func(c: Char) : Text {
            let cipher = if (Char.isAlphabetic(c)){
                let n = Char.toNat32(c);

                if (Char.isUppercase(c)){
                    if (n <= Char.toNat32('M')){
                        Char.fromNat32(n + 13)
                    } else {
                        Char.fromNat32(n - 13)
                    }
                }else{
                    if (n <= Char.toNat32('m')){
                        Char.fromNat32(n + 13)
                    } else {
                        Char.fromNat32(n - 13)
                    }
                }
            }else{
                c
            };

            Char.toText(cipher)
        });

        Text.join("", iter)
    };
}