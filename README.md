# Algorithms.mo
Software engineering algorithms implemented in Motoko for educational purposes.

## Importing Module 
- importing all the algorithms:
```motoko
    import Algo "mo:Algorithms";
```

- importing algorithm sections:
```motoko
    import Sort "mo:Algorithms/Sort";
    import DP "mo:Algorithms/DP";
    import Search "mo:Algorithms/Search";
```

- importing specific algorithms:
```motoko
    import { mergeSort } "mo:Algorithms/Sort";
    import { fibonacci } "mo:Algorithms/DP";
    import { binarySearch } "mo:Algorithms/Search";
```

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