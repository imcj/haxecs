package hx.xfl.utils;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

class ArrayIteratorTest 
{  
    var array:Array<Int>;

    public function new() 
    {
        
    }
    
    @Before
    public function setup():Void
    {
        array = [1, 2];
    }
    
    @After
    public function tearDown():Void
    {
    }
    
    
    @Test
    public function testAsc():Void
    {
        var iterator = new ArrayIterator(array);

        Assert.areEqual(1, iterator.next());
        Assert.areEqual(2, iterator.next());
        Assert.isFalse(iterator.hasNext());
    }

    @Test
    public function testDesc():Void
    {
        var iterator = new ArrayIterator(array, false);

        Assert.areEqual(2, iterator.next());
        Assert.areEqual(1, iterator.next());
        Assert.isFalse(iterator.hasNext());
    }

    @Test
    public function testIteratorDesc():Void
    {
        var iterator = new ArrayIterator(array, false);

        for (item in iterator) {}
        Assert.isFalse(iterator.hasNext());
    }

    @Test
    public function testIteratorAsc():Void
    {
        var iterator = new ArrayIterator(array);

        for (item in iterator) {}
        Assert.isFalse(iterator.hasNext());
    }
}