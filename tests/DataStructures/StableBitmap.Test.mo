import Debug "mo:base/Debug";
import Iter "mo:base/Iter";

import ActorSpec "../utils/ActorSpec";
import StableBitmap "../../src/Datastructures/StableBitmap";

let {
    assertTrue; assertFalse; assertAllTrue; 
    describe; it; skip; pending; run
} = ActorSpec;

let success = run([
    describe("StableBitmap ", [
        it("set(n)", do {
            
            let bitmap = StableBitmap.new(7);

            StableBitmap.set(bitmap, 1);
            StableBitmap.set(bitmap, 2);

            let set_bits = StableBitmap.count(bitmap);

            assertTrue(
                set_bits == 2
            )
        }),
        
        it("toggle(n)", do{
            let bitmap = StableBitmap.new(7);

            StableBitmap.toggle(bitmap, 1);

            StableBitmap.toggle(bitmap, 2);
            StableBitmap.toggle(bitmap, 2);

            StableBitmap.toggle(bitmap, 3);
            StableBitmap.toggle(bitmap, 3);
            StableBitmap.toggle(bitmap, 3);

            StableBitmap.set(bitmap, 4);
            StableBitmap.toggle(bitmap, 4);

            assertAllTrue([
                StableBitmap.get(bitmap, 1) == true,
                StableBitmap.get(bitmap, 2) == false,
                StableBitmap.get(bitmap, 3) == true,
                StableBitmap.get(bitmap, 4) == false
            ])
        }),

        it("get(n)", do{
            let bitmap = StableBitmap.new(7);
            StableBitmap.set(bitmap, 4);
            StableBitmap.set(bitmap, 7);

            assertAllTrue([
                StableBitmap.get(bitmap, 4) == true,
                StableBitmap.get(bitmap, 5) == false,
                StableBitmap.get(bitmap, 7) == true
            ])
        }),

        it("clearAll", do{
            let bitmap = StableBitmap.new(7);

            for (n in Iter.range(0, 7)){
                StableBitmap.set(bitmap, n);
            };

            StableBitmap.clearAll(bitmap);

            var res = true;

            for (n in Iter.range(0, 7)){
                res := res and not StableBitmap.get(bitmap, n);
            };

            assertTrue( res )
        }),
    ])
]);

if(success == false){
  Debug.trap("\1b[46;41mTests failed\1b[0m");
}else{
    Debug.print("\1b[23;42;3m Success!\1b[0m");
};