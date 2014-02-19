package hx.xfl.utils;

class ArrayIterator<T>// implements Iterator<T>
{
    var _asc:Bool;
    var _index:Int;
    var _size:Int;
    var _array:Array<T>;

    public function new(array:Array<T>, asc:Bool=true)
    {
        _array = array;
        _asc = asc;
        _size = array.length;
        if (asc)
            _index = 0;
        else
            _index = _size - 1;
    }

    public function hasNext():Bool
    {
        return (_index < _size && _asc) || (_index >= 0 && !_asc);
    }

    public function next():T
    {
        var item = _array[_index];
        if (_asc)
            _index += 1;
        else
            _index -= 1;

        return item;
    }
}