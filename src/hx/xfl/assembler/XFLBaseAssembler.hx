package hx.xfl.assembler;

using StringTools;

import hx.xfl.XFLDocument;

import logging.*;

class XFLBaseAssembler
{
    var document:XFLDocument;
    var logger:ILogger;

    public function new(document)
    {
        this.document = document;
        logger = Logging.getLogger("hx.xfl.assembler.XFLBaseAssembler");
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

            if (!Reflect.hasField(object, attribute))
                logger.error('not implement property '+
                      '${Type.getClassName(Type.getClass(object))}' + 
                      '.$attribute in ${data.nodeName}');

            var value = data.get(attribute);
            if ("backgroundColor" == attribute && value.substr(0, 1) == "#") {
                Reflect.setField(object, 'backgroundColor', 
                    Std.parseInt('0x' + value.substr(1)));
                continue;
            }

            Reflect.setField(object, attribute, switch(data.get(attribute)) {
                case "true": true;
                case "false": false;
                default: data.get(attribute);
            });
        }
    }
}