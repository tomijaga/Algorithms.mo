import Debug "mo:base/Debug";
import Iter "mo:base/Iter";

import ActorSpec "../utils/ActorSpec";
import Bitmap "../../src/DataStructures/Bitmap";

let {
    assertTrue; assertFalse; assertAllTrue; 
    describe; it; skip; pending; run
} = ActorSpec;

let success = run([
    describe(" Bitmap ", [
        it("set(n)", do {
            
            let bitmap = Bitmap.Bitmap(7);

            bitmap.set(0);
            bitmap.set(2);
            bitmap.set(4);
            bitmap.toggle(2);
            bitmap.toggle(2);

            assertTrue( bitmap.count() == 3)
        }),

        it("get(n)", do {
            
            let bitmap = Bitmap.Bitmap(7);

            bitmap.set(2);
            bitmap.set(6);

            assertAllTrue([
                bitmap.get(2) == true,
                bitmap.get(7) == false,
                bitmap.get(6) == true
            ])
        }),

        it("clearAll", do{
            let bitmap = Bitmap.Bitmap(7);  

            bitmap.set(2);
            bitmap.set(4);
            bitmap.set(6);

            bitmap.clearAll();

            bitmap.set(0);
            bitmap.set(7);

            assertAllTrue([
                bitmap.get(2) == false,
                bitmap.get(4) == false,
                bitmap.get(6) == false,

                bitmap.get(0) == true,
                bitmap.get(7) == true
            ])
        }),

        it("bitandInPlace", do{
            let a  = Bitmap.Bitmap(7);
            let b  = Bitmap.Bitmap(7);

            a.set(1);
            b.set(1);

            b.set(2);

            a.set(3);

            a.set(5);
            b.set(5);

            a.bitandInPlace(b);

            assertAllTrue([
                a.get(1) == true,
                a.get(2) == false,
                a.get(3) == false,
                a.get(5) == true,

                a.count() == 2
            ])
        }),

        it("Bitmap.bitand(a, b)", do{
            let a  = Bitmap.Bitmap(7);
            let b  = Bitmap.Bitmap(7);

            a.set(1);
            b.set(1);

            b.set(2);

            a.set(3);

            a.set(5);
            b.set(5);

            let intersect = Bitmap.bitand(a, b);

            assertAllTrue([
                intersect.get(1) == true,
                intersect.get(2) == false,
                intersect.get(3) == false,
                intersect.get(5) == true,

                intersect.count() == 2
            ])
        }),

        it("Bitmap.bitor(a, b)", do{
            let a  = Bitmap.Bitmap(7);
            let b  = Bitmap.Bitmap(7);

            a.set(1);
            b.set(1);

            b.set(2);

            a.set(3);

            a.set(5);
            b.set(5);

            let union = Bitmap.bitor(a, b);

            assertAllTrue([
                union.get(1) == true,
                union.get(2) == true,
                union.get(3) == true,
                union.get(5) == true,

                union.get(4) == false,
                union.get(6) == false,
                union.get(7) == false,

                union.count() == 4
            ])
        }),
    ])
]);

if(success == false){
  Debug.trap("\1b[46;41mTests failed\1b[0m");
}else{
    Debug.print("\1b[23;42;3m Success!\1b[0m");
};