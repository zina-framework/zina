package zina.utils;

class ArrayUtil {
    public static inline function back<T>(array:Array<T>):T {
        return array[array.length - 1];
    }

    public static inline function front<T>(array:Array<T>):T {
        return array[0];
    }
}