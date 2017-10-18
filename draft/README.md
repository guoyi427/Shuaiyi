# CMS项目iOS版本

## 规范

1. 添加必要的单元测试。
2. 必要且非废话的注释。
3. 使用 CocoaPods 管理第三方依赖。

##  Git代码管理规范

### 分支说明

1. `master`：用于版本发布。
2. `develop`：开发分支。
3. `develop-[版本号]`：在某个版本开发中需要同步进行开发的另一个版本。
4. `feature-[功能名称]`：在某个版本开发中一些比较独立或不一定要上线的功能。
5. `hotfix-[版本号]`：线上版本紧急修复。

### 工作流程

1. 在 ***develop*** 分支上进行开发。
2. 功能开发完成，经过自测、必要的单元测试后，提交测试。
3. 在 ***develop*** 分支进行 bug 修复，以及一些可能的新需求开发。
4. 如果同时进行下个版本的开发，在 ***develop*** 下切出新的分支 ***develop-[版本号]***，在新分支下进行下版本的开发，***develop*** 代码封版后将 ***develop-[版本号]*** 分支下的代码合并过来，继续在 ***develop*** 分支开发。
5. 如果有非必须上线的需求开发，在 ***develop*** 下切出新的分支 ***feature-[功能名称]***，在新分支下开发需求，***develop*** 代码封版后将 ***feature-[功能名称]*** 分支下的代码合并过来，继续在 ***develop*** 分支开发。
6. 代码测试完成可发布后将 ***develop*** 下的代码合并到 ***master*** 分支，并且添加版本号的 tag，tag 名称为发布的版本号，例如：5.2.7。
7. 如果已发布版本的代码发现 bug 需要紧急修复，在 ***master*** 分支上找到对应的 tag，并切出新的分支 ***hotfix-[版本号]***，bug修复完成后将代码合并到 ***master*** 分支并添加 tag。

#### Git 代码示例

```
#从 develop 切换到 master 分支
git checkout master

#合并 develop 分支的代码
git merge develop

#添加 tag 1.0.0 版本
git tag -a 1.0.0 -m 'Release v1.0.0'

#把 tag 推送到远程仓库
git push origin 1.0.0
```

### 相关 Git 命令

1\. 切换分支：

```
git checkout <分支名称>
```

2\. 合并分支：
 
```
git merge <分支名称>
```

3\. 添加标签：

```
git tag -a <tagname: x.x.x> -m '<message>' [<commit>]
```

4\. 推送标签到远程仓库：

```
#推送指定的 tag
git push origin <tagname> 

#推送所有 tag
git push origin --tags
```

### Submodule

不能集成到'Cocoapods'内的`ios_cms_framework`模块，使用git `submodule` 的形式进行依赖管理。

#### 基本使用

当clone下代码后，执行：`git submodule init`初始化本地配置文件，然后`git submodule update`来拉取代码。

```
$ git submodle init
Submodule 'ios_cms_framework' (ssh://git@git.cias.net.cn:35708/cmsapp/ios_cms_framework.git) registered for path 'ios_cms_framework'
$ git submodule update
Cloning into '/Users/Albert/Desktop/ios_cms/ios_cms_framework'...
Submodule path 'ios_cms_framework': checked out '2ef4418d9d84a1d38408abdbfd839637b453c8e0'
```
当工程代码修改后需要进行提交，若`submodule`内有修改时，先提交`submodule`内代码，再提交工程的修改（提交包括`submodule`路径，这样才会将工程`submodule`的commit指向刚提交的commit）。

为了使工程依赖的`submodule`尽量保持一致，在本地submodule`提交后，先push到`repository`。

当对工程代码进行pull操作后，如果更新后工程的`submodule`的commit指向发生了变化，只需执行：`git submodule update`。


## 新增项目步骤

如果可以，尽量在已有工程的`target`基础上创建新项目的`target`。

步骤：

在源`target`右键，选择菜单中的`Duplicate`，然后对新项目`target`进行命名。

创建新项目文件夹并加入工程，修改新工程的`info.plist`文件名，并移入文件夹（修改后需重新关联`info.plish`）


### 其他配置

Build Phases -> Build number auto increment 内脚本对应的`plish`文件名要对应上

#### fastlane

Fastfile

get_target_version 添加对应`secheme`的`plist`路径

get_target_version 添加对应`secheme`的名字

添加对应`secheme`的 添加对应`secheme`

Matchfile

`app_identifier` 增加新项目的`identifier`