import Array "mo:base/Array";
import Nat64 "mo:base/Nat64";
import Nat "mo:base/Nat";
import Int "mo:base/Int";
import Iter "mo:base/Iter";

/// A Bitmap that stores numbers from 0 to the given max

module Bitmap{

    public let MASK = 64; // 2 ** 6;

    public class Bitmap(_max : Nat){
        assert _max > 0;

        func to_index(n: Nat) : Nat{
            n / MASK
        };

        func to_nat64(n : Nat) : Nat64{
            Nat64.fromNat(n % MASK)
        };

        func to_bit_pos(n : Nat) : Nat64{
            1 << to_nat64(n)
        };

        let _size: Nat = to_index(_max) + 1;
        let bits = Array.init<Nat64>(_size, 0);

        public func set(n: Nat){
            bits[to_index(n)] |= to_bit_pos(n);
        };

        public func clear(n: Nat){
            bits[to_index(n)] &= ^to_bit_pos(n);
        };

        public func toggle(n: Nat){
            bits[to_index(n)] ^= to_bit_pos(n);
        };

        public func get(n: Nat) : Bool {
            (bits[to_index(n)] & to_bit_pos(n)) >> to_nat64(n) == 1
        };

        public func count() : Nat {
            var set_bits = 0;

            for (i in Iter.range(0, Int.abs(_size - 1))){
                let cnt = Nat64.bitcountNonZero(bits[i]);
                set_bits += Nat64.toNat(cnt);
            };

            set_bits
        };

        public func clear_all(){
            for (i in Iter.range(0, Int.abs(_size - 1))){
                bits[i] := 0;
            };
        };

        public func __bits(): [var Nat64]{
            bits
        };

        public func size() : Nat{
            _size
        };

        public func max(): Nat{
            _max
        };

        public func bitandInPlace(other : Bitmap) {
            let self_bits = bits;
            let other_bits = other.__bits();

            let min_size = Nat.min(_size, other.size());

            for (i in Iter.range(0, Int.abs(min_size - 1))){
                self_bits[i] &= other_bits[i];
            };

            if (_size > min_size){
                for (i in Iter.range(min_size, Int.abs(_size - 1))){
                    self_bits[i] := 0;
                };
            };
        };
    };

    public func bitand( a: Bitmap, b: Bitmap ) : Bitmap {
        let bits_a = a.__bits();
        let bits_b = b.__bits();

        let c = Bitmap(
            Nat.max(a.max(), b.max())
        );

        let bits_c = c.__bits();

        let min_size = Nat.min(a.size(), b.size());

        for (i in Iter.range(0, Int.abs(min_size - 1))){
            bits_c[i] := bits_a[i] & bits_b[i];
        };

        c
    };

    public func bitor( _a : Bitmap, _b : Bitmap ) : Bitmap {
        let (a, b) = if (_a.size() > _b.size()){
            (_a, _b)
        }else{
            (_b, _a)
        };

        let bits_a = a.__bits();
        let bits_b = b.__bits();

        let c = Bitmap(
            Nat.max(a.max(), b.max())
        );

        let bits_c = c.__bits();

        for (i in Iter.range(0, Int.abs(b.size() - 1))){
            bits_c[i] := bits_a[i] | bits_b[i];
        };

        for (i in Iter.range(b.size(), Int.abs(a.size() - 1))){
            bits_c[i] := bits_a[i];
        };

        c
    };

    public func bitxor( _a : Bitmap, _b : Bitmap ) : Bitmap{
        let (a, b) = if (_a.size() > _b.size()){
            (_a, _b)
        }else{
            (_b, _a)
        };

        let bits_a = a.__bits();
        let bits_b = b.__bits();

        let c = Bitmap(
            Nat.max(a.max(), b.max())
        );

        let bits_c = c.__bits();

        for (i in Iter.range(0, Int.abs(b.size() - 1))){
            bits_c[i] := bits_a[i] ^ bits_b[i];
        };

        for (i in Iter.range(b.size(), Int.abs(a.size() - 1))){
            bits_c[i] := bits_a[i] ^ 0;
        };
    };
};