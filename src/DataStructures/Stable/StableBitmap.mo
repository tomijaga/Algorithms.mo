import Array "mo:base/Array";
import Nat64 "mo:base/Nat64";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";

module StableBitmap{

    public type StableBitmap = ([var Nat64], Nat);

    public let MASK = 2 ** 6;

    func num_to_index(n: Nat) : Nat{
        n / MASK
    };

    func num_to_nat64(n : Nat) : Nat64{
        Nat64.fromNat(n / MASK)
    };

    func num_to_bit_pos(n : Nat) : Nat64{
        1 << num_to_nat64(n)
    };

    public func new(max: Nat) : StableBitmap {
        let size = num_to_index(max) + 1;

        let bits = Array.init<Nat64>(size, 0);

        (bits, max)
    };

    public func set( bitmap: StableBitmap, n: Nat){
        assert (n <= bitmap.1);

        let (bits, max) = bitmap;

        bits[num_to_index(n)] |= num_to_bit_pos(n);
    };

};