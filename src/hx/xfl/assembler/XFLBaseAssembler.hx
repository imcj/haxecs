package hx.xfl.assembler;

using StringTools;

class XFLBaseAssembler
{
    public function new()
    {
    }

    public function fillProperty<T>(object:T, data:Xml)
    {
        for (attribute in data.attributes()) {
            if (~/xmlns:?/.match(attribute))
                continue;
            
			if (~/lastModified/.match(attribute))
				continue;
				
			if (~/isSelected/.match(attribute))
				continue;
				
			if (~/selected/.match(attribute))
				continue;
            // attribute = attribute.replace("\n", "");
            // attribute = attribute.replace("\r", "");
            // trace(Type.getInstanceFields(Type.getClass(object)));

            // if (!Reflect.hasField(object, attribute))
            //     throw 'not implement property '+
            //           '${Type.getClassName(Type.getClass(object))}' + 
            //           '.$attribute in ${data.nodeName}';

            Reflect.setField(object, attribute, data.get(attribute));
        }
    }
}