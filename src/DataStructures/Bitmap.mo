import Array "mo:base/Array";
import Nat64 "mo:base/Nat64";
import Nat "mo:base/Nat";
import Int "mo:base/Int";
import Iter "mo:base/Iter";

import Utils "../Utils";

/// A Bitmap that stores numbers from 0 to the given max

module Bitmap{

    public let MASK = 64; // 2 ** 6;

    public class Bitmap(_max : Nat){

        func to_index(n: Nat) : Nat{
            n / MASK
        };

        func mask_bit(n : Nat) : Nat64{
            Nat64.fromNat(n % MASK)
        };

        func to_bit_pos(n : Nat) : Nat64{
            1 << mask_bit(n)
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
            (bits[to_index(n)] & to_bit_pos(n)) >> mask_bit(n) == 1
        };

        public func count() : Nat {
            var set_bits = 0;

            for (i in Utils.range(0, _size)){
                let cnt = Nat64.bitcountNonZero(bits[i]);
                set_bits += Nat64.toNat(cnt);
            };

            set_bits
        };

        public func clearAll(){
            for (i in Utils.range(0, _size)){
                bits[i] := 0;
            };
        };

        public func _getBits(): [var Nat64]{
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
            let other_bits = other._getBits();

            let min_size = Nat.min(_size, other.size());

            for (i in Utils.range(0, min_size)){
                self_bits[i] &= other_bits[i];
            };

            if (_size > min_size){
                for (i in Utils.range(min_size, _size)){
                    self_bits[i] := 0;
                };
            };
        };
    };

    func sortBySize( a: Bitmap, b: Bitmap ) : (Bitmap, Bitmap){
        if ( a.size() < b.size()) {
            (a, b)
        }else{
            (b, a)
        }
    };

    public func bitand( a: Bitmap, b: Bitmap ) : Bitmap {
        let bits_a = a._getBits();
        let bits_b = b._getBits();

        let c = Bitmap(
            Nat.max(a.max(), b.max())
        );

        let bits_c = c._getBits();

        let min_size = Nat.min(a.size(), b.size());

        for (i in Utils.range(0, min_size)){
            bits_c[i] := bits_a[i] & bits_b[i];
        };

        c
    };

    public func bitor( _a : Bitmap, _b : Bitmap ) : Bitmap {
        let (a, b) = sortBySize(_a, _b);

        let bits_a = a._getBits();
        let bits_b = b._getBits();

        let c = Bitmap(
            Nat.max(a.max(), a.max())
        );

        let bits_c = c._getBits();

        for (i in Utils.range(0, a.size())){
            bits_c[i] := bits_a[i] | bits_b[i];
        };

        for (i in Utils.range(a.size(), b.size())){
            bits_c[i] := bits_b[i];
        };

        c
    };

    public func bitxor( _a : Bitmap, _b : Bitmap ) : Bitmap {
        let (a, b) = sortBySize(_a, _b);

        let bits_a = a._getBits();
        let bits_b = b._getBits();

        let c = Bitmap(
            Nat.max(a.max(), a.max())
        );

        let bits_c = c._getBits();

        for (i in Utils.range(0, a.size())){
            bits_c[i] := bits_a[i] ^ bits_b[i];
        };

        for (i in Utils.range(a.size(), b.size())){
            bits_c[i] := bits_b[i] ^ 0;
        };

        c
    };

    public func isDisjoint(a: Bitmap, b: Bitmap) : Bool{
        let bits_a = a._getBits();
        let bits_b = b._getBits();

        let min_size = Nat.min(a.size(), b.size());

        for (i in Utils.range(0, min_size)){
            if ((bits_a[i] & bits_b[i]) != 0) {
                return false;
            }
        };

        true
    };
};