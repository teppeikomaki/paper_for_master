FROM paperist/texlive-ja:latest
# XeTeX をインストールする場合の例
RUN apt-get update \
  && apt-get install -y \
    libfontconfig1 \
  && rm -rf /var/lib/apt/lists/*
RUN tlmgr update --self  
RUN tlmgr install doublestroke