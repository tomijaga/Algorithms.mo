import QuickSort "QuickSort";
import MergeSort "MergeSort";
import ShellSort "ShellSort";

module Sort{
    public let { quickSort; quickSortMut } = QuickSort;
    public let { mergeSort; mergeSortMut } = MergeSort;
    public let {  shellSortMut } = ShellSort;
};