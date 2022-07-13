import Debug "mo:base/Debug";
import Iter "mo:base/Iter";

import ActorSpec "../utils/ActorSpec";
import Algo "../../src";
// import [FnName] "../../src/[section]/[FnName]";

let {
    assertTrue; assertFalse; assertAllTrue; 
    describe; it; skip; pending; run
} = ActorSpec;

let success = run([
    describe(" Pascal Triangle ", [
        it("3 rows", do {
            
           let p =  Algo.Math.pascalTriangle(3);
           assertTrue(
                p == [
                    [1],
                    [1, 1],
                    [1, 2, 1]
                ]
           )
        }),

        it("10 rows", do{

            let p =  Algo.Math.pascalTriangle(10);
            assertTrue(
                p == [
                    [1],
                    [1, 1],
                    [1, 2, 1],
                    [1, 3, 3, 1],
                    [1, 4, 6, 4, 1],
                    [1, 5, 10, 10, 5, 1],
                    [1, 6, 15, 20, 15, 6, 1],
                    [1, 7, 21, 35, 35, 21, 7, 1],
                    [1, 8, 28, 56, 70, 56, 28, 8, 1],
                    [1, 9, 36, 84, 126, 126, 84, 36, 9, 1]
                ]
            )
        }),
    ])
]);

if(success == false){
  Debug.trap("\1b[46;41mTests failed\1b[0m");
}else{
    Debug.print("\1b[23;42;3m Success!\1b[0m");
};