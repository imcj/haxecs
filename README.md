# Haxecs

Haxecs的目标是兼容flash cs的创作，在openfl下解析运行fla文件（现在只能解析xfl文件）。

Haxecs是社区驱动开发支持的，我希望该项目能帮助程序解决繁琐的工作，专注于有创意的工作。

openfl可以运行在Windows, Mac, Linux, iOS, Android, BlackBerry, Tizen, Flash, HTML5等平台上，兼容flash api。

![screen](http://gzdev.qiniudn.com/screen_haxecs.png)

### 依赖

- haxe 3.0
- openfl
- [logging](https://github.com/imcj/logging)

### 相关工具

- flash cs cc


# 开始

在线演示，请点击下面的链接：

显示openfl logo的示例

- http://imcj.github.io/haxecs/example/haxecs-openfl-logo/


# 状态

开发中，不适用任何的生产环境和任何场景。


# 贡献

## 开发

你可以查看我们的贡献成员列表：

- https://github.com/imcj/haxecs/graphs/contributors

你也可以把你的名字加入到名单中 :)

## 开始

```haxe
// Main.hx
package ;

```

## Symbol的扩展

可以配置Symbol(MovieClip,Graphic,Button)的linkageClass扩展对象。

```
package org.haxe-china.components;

class Checked extends MovieClip
{
	public var checked(get, set):Bool;
	
	public function new()
	{

	}
}
```

# 社区

QQ群:

- 373589054

邮件列表和Google group:

- https://github.com/imcj/haxecs/graphs/contributors

Issue:

- https://github.com/imcj/haxecs/issues

# License

[The MIT License (MIT)](license.txt)