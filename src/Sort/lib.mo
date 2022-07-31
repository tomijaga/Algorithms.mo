import QuickSort "QuickSort";
import MergeSort "MergeSort";
import ShellSort "ShellSort";
import InsertionSort "InsertionSort";
import SelectionSort "SelectionSort";

module Sort{
    public let { quickSort; quickSortMut } = QuickSort;
    public let { mergeSort; mergeSortMut } = MergeSort;
    public let {  shellSortMut } = ShellSort;
    public let { insertionSort; insertionSortMut } = InsertionSort;
    public let { selectionSort; selectionSortMut } = SelectionSort;
};