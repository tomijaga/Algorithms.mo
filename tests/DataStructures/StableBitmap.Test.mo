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
            Debug.print(debug_show bitmap);

            StableBitmap.set(bitmap, 1);
            StableBitmap.set(bitmap, 2);

            let set_bits = StableBitmap.count(bitmap);

            assertTrue(
                set_bits == 2
            )
        }),
    ])
]);

if(success == false){
  Debug.trap("\1b[46;41mTests failed\1b[0m");
}else{
    Debug.print("\1b[23;42;3m Success!\1b[0m");
};