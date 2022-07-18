# Not Ready...

## 07.15

- 增加 支持多语言文档站能力，自动同步 文档分站 repo内英文文档，并支持语言切换
- 增加 文档站镜像自动构建，当用户推送更新到master时，自动构建新的 docker image，并推送到远端仓库
- 增加 iframe 嵌入 video 能力，自适应 youtube、bilibili 原生iframe链接
  - 主要在 iframe 外围嵌套一层 <div class="responsive-video-container"> <iframe> </iframe> </div>

## 06.30

- 更新 支持各种姿势的自定义目录能力
- 更新 采用 git submodule 来关于所有 repo
- 优化 gitlab-ci.yaml 采用相对路径拉取 submodule repo，无需使用 gitlab oauth token
- [更新文档说明](docs/howto_dce5-docs.md)


## 06.10

- 增加自定义js 实现图片的点击放大功能 docs/extra/zoom_image.js
- 增加中文搜索功能，修改站点默认语言为中文 采用jieba 分词 ， 未调较
- 增加代码高亮
- 增加语法高亮
- 增加行号展示

## 06.09 

还没来得及写 README.md , 内容不多

基于 mkdocs 把 DCE 5.0 所有产品项目的文档站内容进行了汇总


- gitlab-ci 能够跑起来，还未优化 囧~
- 配置基本都在 mkdocs.yml

> 待续...
