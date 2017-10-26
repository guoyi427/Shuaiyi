抠电影iOS版本
---

工程使用[cocoapods](https://guides.cocoapods.org/)管理库依赖。

#### cocoapods 安装注意
在执行`gem install cocoapods `前，需要先将修改[gem source](https://ruby.taobao.org/)

添加[kokozu私有库源](http://git.cias.net.cn/ios_specs/Specs)

如果执行`pod install`失败，则执行

	pod setup --verbose



然后再执行

	pod install

安装完毕好打开`KoMovie.xcworkspace`

