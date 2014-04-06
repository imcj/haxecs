package hx.xfl.assembler;

using StringTools;

import hx.xfl.XFLDocument;

class XFLBaseAssembler
{
    var document:XFLDocument;

    public function new(document)
    {
        this.document = document;
    }

    public function fillProperty<T>(object:T, data:Xml,
        ignoreProperty:Array<String>=null)
    {
        var ignorePropertyMap:Map<String, Bool> = null;
        if (null != ignoreProperty) {
            ignorePropertyMap = new Map();

            for (propertyName in ignoreProperty)
                ignorePropertyMap.set(propertyName, true);
        }
        for (attribute in data.attributes()) {
            if (ignorePropertyMap != null && ignorePropertyMap.get(attribute))
                continue;
            if (~/xmlns:?/.match(attribute))
                continue;
            
            if (~/lastModified/.match(attribute))
                continue;

            if (~/isSelected/.match(attribute))
            continue;

            if (~/selected/.match(attribute))
                continue;

            if (~/locked/.match(attribute))
                continue;
            // attribute = attribute.replace("\n", "");
            // attribute = attribute.replace("\r", "");
            // trace(Type.getInstanceFields(Type.getClass(object)));

            // if (!Reflect.hasField(object, attribute))
            //     throw 'not implement property '+
            //           '${Type.getClassName(Type.getClass(object))}' + 
            //           '.$attribute in ${data.nodeName}';

            Reflect.setField(object, attribute, switch(data.get(attribute)) {
                case "true": true;
                case "false": false;
                default: data.get(attribute);
            });
        }
    }
}