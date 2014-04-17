package hx.xfl.setting.publish;

class DOMFlashProfiles implements Dynamic<DOMFlashProfile>
{
    var _profiles:Map<String, DOMFlashProfile>;

    public function new()
    {
        _profiles = new Map();
    }

    public function resolve(name:String):DOMFlashProfile
    {
        return getProfile(name);
    }

    public function getProfile(name:String):DOMFlashProfile
    {
        return _profiles.get(name);
    }

    public function setProfile(profile:DOMFlashProfile):Void
    {
        // if (profile.current)
        //     this.default = profile;
        _profiles.set(profile.name, profile);
    }
}