import Array "mo:base/Array";
import Nat64 "mo:base/Nat64";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Int "mo:base/Int";
import Debug "mo:base/Debug";

module StableBitmap{

    public type StableBitmap = ([var Nat64], Nat);

    public let MASK = 64; // 2 ** 6

    func to_index(n: Nat) : Nat{
        n / MASK
    };

    func mask_bit(n : Nat) : Nat64{
        Nat64.fromNat(n % MASK)
    };

    func to_bit_pos(n : Nat) : Nat64{
        1 << mask_bit(n)
    };

    public func size( bitmap: StableBitmap ) : Nat {
        bitmap.0.size()
    };

    public func max( bitmap: StableBitmap ) : Nat {
        bitmap.1
    };

    public func new(max: Nat) : StableBitmap {
        let size = to_index(max) + 1;

        let bits = Array.init<Nat64>(size, 0);

        (bits, max)
    };

    public func set( bitmap: StableBitmap, n: Nat){
        assert (n <= bitmap.1);

        bitmap.0[to_index(n)] |= to_bit_pos(n);
    };

    public func toggle( bitmap: StableBitmap, n: Nat){
        assert (n <= bitmap.1);

        bitmap.0[to_index(n)] ^= to_bit_pos(n);
    };

    public func clear( bitmap: StableBitmap, n: Nat){
        assert (n <= bitmap.1);

        bitmap.0[to_index(n)] &= ^to_bit_pos(n);
    };

    public func clearAll( bitmap: StableBitmap){
        for (i in Iter.range(0, Int.abs( size(bitmap) - 1 ))){
            bitmap.0[i] := 0;
        };
    };

    public func get( bitmap: StableBitmap, n: Nat) : Bool {
        (bitmap.0[to_index(n)] & to_bit_pos(n)) >> mask_bit(n) == 1
    };

    public func count( bitmap: StableBitmap) : Nat{
        var set_bits = 0;

        for ( i in Iter.range(0, Int.abs( size(bitmap) - 1 ))){
            let cnt = Nat64.bitcountNonZero( bitmap.0[i] );
            set_bits += Nat64.toNat(cnt);
        };

        set_bits
    };

    func sortBySize( a: StableBitmap, b: StableBitmap ) : (StableBitmap, StableBitmap){
        if ( size(a) < size(b)) {
            (a, b)
        }else{
            (b, a)
        }
    };

    public func bitand( _a: StableBitmap, _b: StableBitmap ) : StableBitmap {
        let (a, b) = sortBySize(_a, _b);

        let new_bitmap = new( 
            Nat.max( max(a), max(b) )
        );

        for (i in Iter.range(0, Int.abs(size(a) - 1))){
            new_bitmap.0[i] := a.0[i] & b.0[i]; 
        };

        new_bitmap
    };
};