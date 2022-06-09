FROM release-ci.daocloud.io/product/squidfunk/mkdocs-material:8

# Install dependencies for pip
COPY ./requirements.txt .
RUN pip install -i http://pypi.douban.com/simple --trusted-host pypi.douban.com -r ./requirements.txt

WORKDIR /docs
