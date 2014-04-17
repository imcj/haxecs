package hx.xfl.assembler;

import hx.xfl.setting.publish.DOMFlashProfiles;

import hx.xfl.setting.publish.*;

class DOMPublishSettingAssembler extends hx.xfl.assembler.XFLBaseAssembler
{
    var fields:Map<String, Map<String, String>>;
    public function new()
    {
        super(null);

        fields = new Map();

        var flash_properties_fields = new Map<String, String>();
        for (field in Reflect.fields(new DOMFlashProperties())) {
            flash_properties_fields.set(field.toLowerCase(), field);
        }


        fields.set("flash_properties_fields", flash_properties_fields);
    }

    public function toCamelCase(name:String):String
    {
        return "";
    }

    function parseProfile(nodeProfile:Xml):DOMFlashProfile
    {
        var flash_profile = new DOMFlashProfile();
        flash_profile.name = nodeProfile.get("name");
        flash_profile.version = nodeProfile.get("version");
        flash_profile.current = nodeProfile.get("current") == "True" ? true : 
            false;
        return flash_profile;
    }

    function parseFlashProperties(node_flash_properties:Xml):DOMFlashProperties
    {
        var flash_properties_fields = fields.get("flash_properties_fields");
        var flash_properties = new DOMFlashProperties();
        for (property in node_flash_properties.elements()) {
            var property_name = property.nodeName;
            var property_value:String = property.firstChild().nodeValue;
            var field_name:String;
            if (flash_properties_fields.exists(property_name.toLowerCase())) {
                field_name = flash_properties_fields.get(
                    property.nodeName.toLowerCase());
                switch(property_name) {
                case "AS3PackagePaths":
                    var array_property_value = property_value.split(";");

                    Reflect.setField(flash_properties, field_name, 
                        array_property_value);
                default:
                    Reflect.setField(flash_properties, field_name,
                        property_value);
                }
            }
        }

        return flash_properties;
    }

    public function parse(data:Xml):DOMFlashProfiles
    {
        var flashProfiles = new DOMFlashProfiles();
        for (nodeFlashProfile in data.firstElement().elements()) {
            var profile:DOMFlashProfile = parseProfile(nodeFlashProfile);

            if ("flash_profile" == nodeFlashProfile.nodeName) {
                flashProfiles.setProfile(profile);

                for (nodeProperties in 
                     nodeFlashProfile.elements()) {
                    if ("PublishFlashProperties" == nodeProperties.nodeName) {
                        var properties = parseFlashProperties(nodeProperties);
                        profile.flashProperties = properties;
                    }
                }
            }
        }

        return flashProfiles;
    }
}