# Algorithms.mo
Software engineering algorithms implemented in Motoko for educational purposes.
View the full list of implemented algorithms and data structures [here](algorithms.md)

## Usage
- Generating the 3rd number in the Fibonacci sequence:
```motoko

    import Algo "mo:Algorithms";

    let fib = Algo.DP.fibonacci;

    assert fib(3) == 2;
```

- sorting an array using merge sort
```motoko

    import Sort "mo:Algorithms/Sort";

    let sortedArray = Sort.mergeSort([4,2,3,1]);
    
    assert sortedArray == [1,2,3,4];

```

- searching an array for a value
```motoko
    import Nat "mo:base/Nat";
    import { binarySearch } "mo:Algorithms/Search/BinarySearch";

    let array = [1,2,3,4,5,6,7];
    
    assert binarySearch(array, 5, Nat.compare) == #ok(4);
    
```

## Live Coding Environment
[Motoko Playground](https://m7sm4-2iaaa-aaaab-qabra-cai.raw.ic0.app/?tag=3117150752)
