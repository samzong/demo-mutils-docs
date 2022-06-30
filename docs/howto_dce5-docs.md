- 专为大型文档项目设计，合并多个站点的文档，使用 git submodule add 的方式添加
- 在每个项目内增加一个 pages.yml 用来自定义路径和导航栏名称，强定义要求，必须要 site_name 参数， 文档站名称

## submodule 的使用注意事项

```shell
# 使用 git submodule add 添加子模块
 ~ git submodule add https://xxxx.com/projectname.git modules/modules_name # 结尾处指定文件夹

# git submodule add -b 添加子模块时指定分支
 ~ git submodule add -b main https://xxxx.com/projectname.git modules/modules_name

# 使用 子模块的特定分支
~ git config -f .gitmodules submodule.xxx.branch docs

# 移除子模块
~ git submodule deinit modules/modules_name

# 初始化子模块能力
~ git submodule init

# 更新子模块
~ git submodule update <init>

# 更新全部层层的子模块
~ git submodule update --init --recursive

# clone 主项目时同时clone子模块
~ git clone project_repo_url --recurse-submodules
```

### 规范约定

- 所有 submodule 都统一拉取到 主项目根目录下 modules/ ，如果不存在需要预先创建
- 拉取 submodule 指定对应的 路径即可，上面有说到方法

## gitlab ci

为了项目在 gitlab ci 运行时可以获取到全部的文件，需要主项目在 .gitlab-ci.yml 增加 一个特定参数

```shell
variables:
  GIT_SUBMODULE_STRATEGY: recursive # 拉取 Submodule 内容
```
通过这个参数，可以保证每次 git 在构建时，会自动的拉取 submodule 对应最新的内容；就可以实现，主项目更新时，子模块自动跟随更新

### gitlab 建议对同一个 gitlab server 的项目采用相对路径的 gitmodule url

```yaml
[submodule "project"]
  path = project
  url = ../../group/project.git  # 在同一个 git 服务器时

[submodule "project-x"]
  path = project-x
  url = https://gitserver.com/group/project-x.git  # 在不同的 git 服务器，使用全部路径
```

[https://docs.gitlab.cn/jh/ci/git_submodules.html#%E9%85%8D%E7%BD%AE-gitmodules-%E6%96%87%E4%BB%B6](https://docs.gitlab.cn/jh/ci/git_submodules.html#%E9%85%8D%E7%BD%AE-gitmodules-%E6%96%87%E4%BB%B6)

## Mkdocs 子模块 pages.yml 配置

```yaml
site_name: Kpanda  # 必须要有，默认 项目名称
docs_dir: ./  
nav: 
- 简介:
- Getting Started: index.md
- 如何参与: intro/htc.md
- 格式手册: intro/format.md
- 数学:
- 万能欧几里得算法: math/useful_euclidean.md
- 拉格朗日反演: math/lagrange_inv.md
- FWT: math/fwt.md
- 图论:
    - 二分图的性质: graph/bigraph.md
```

- site_name: 必须要有，默认 项目名称
- docs_dir: 必须要有，指定文档的根路径 ，默认是此配置文件所在目录内的 docs 文件夹，如果不是需要指定
- nav: 必须要有，指定对应的侧边栏导航目录，这里所有导航都是收在主项目导航下

## 主项目的配置 mkdocs.yml 配置说明

> 强烈声明，主项目不做文档存储，所有文档需以 submodule 的形式挂在；主项目为定期更新和输出总站的目的为主

```yaml
site_name: My Docs
theme: material
plugins:
  - monorepo

nav:
  - Home: index.md
  - afoi-wiki: '!include afoi-wiki/docs/page.yml'  # 子模块的引入方法
```

- 本次采用的 mkdocs 插件是解决大型文档站多 repo 方案 社区使用量排名第一的项目 [mkdocs-monorepo-plugin](https://github.com/backstage/mkdocs-monorepo-plugin) 
- 使用 git submodule 来进行模块管理
   - 需预先完成子模块添加
   - 需自行维护子模块内 被引入配置文件 和 子模块内容更新
- `!include submodule_dir/page.yml` 标准的子模块引入的方法，此文件由各个子模块团队负责维护，详见上方第 2 章节对子文件的描述
- **其他使用注意事项**
   - 支持在主项目任意层级引入子模块
   - 同一个子模块仅可以引用一次，通过 子模块配置文件的 site_name 作区分
   - 不支持嵌套引入能力
   - 不支持在子模块中使用  [mkdocs-monorepo-plugin](https://github.com/backstage/mkdocs-monorepo-plugin)  此插件

## 参考资料

- mkdocs 多仓库插件  [https://github.com/backstage/mkdocs-monorepo-plugin](https://github.com/backstage/mkdocs-monorepo-plugin)
- git 子模块功能介绍   [https://git-scm.com/docs/git-submodule](https://git-scm.com/docs/git-submodule)
- gitlab ci 结合子模块使用方法 [https://docs.gitlab.cn/jh/ci/git_submodules.html](https://docs.gitlab.cn/jh/ci/git_submodules.html)

## 项目改造的注意事项

- 图片附件 不要使用绝对路径 /images/ 改为 images/
- 从 SUMMARY.md 快速产生 pages.yml 的 nav 部分
   - 利用 vscode 批量替换的能力
   - 批量删除 `[` `)`
   - 批量替换内容 `](`替换为 `: ` 
   - mkdocs 不支持目录配置文件，声明文件夹和文件需要区分，这里需要把每个文档的 README.md 进行调整

```yaml
nav:
  # 默认为这样的形态
  - 产品动态: 00releasenotes/README.md
    - 最新动态: 00releasenotes/Dynamics.md
    - Release 0.1: 00releasenotes/0.1.md
    - Release 0.2: 00releasenotes/0.2.md
    - Release 0.3: 00releasenotes/0.3.md
  
  # 调整为下发形态，变更了文件夹的 README.md
  - 产品动态: 
    - 00releasenotes/README.md # 这里可以补充一个命名，也可以直接选择文件，会默认取文件内第一个 H1 标签
    - 最新动态: 00releasenotes/Dynamics.md
    - Release 0.1: 00releasenotes/0.1.md
    - Release 0.2: 00releasenotes/0.2.md
    - Release 0.3: 00releasenotes/0.3.md
```
