## Dokcerイメージのダウンロード
paperist/texlive-jaを利用する。  
Github:https://github.com/Paperist/texlive-ja  
git cloneは不要。docker pullをすればそれで良い。
```
docker pull paperist/texlive-ja:latest
```

## (抜粋)latexmk を使う  
paperist/texlive-ja には、latexmk がインストールされています

例えば、upLaTeX でビルドしたい場合、次のように latexmkrc ファイルを作ると、latexmk コマンドだけでビルドできます
```
$latex = 'uplatex %O -synctex=1 -interaction=nonstopmode -file-line-error %S';
$bibtex = 'upbibtex %O %B';
$biber = 'biber %O --bblencoding=utf8 -u -U --output_safechars %B';
$dvipdf = 'dvipdfmx %O -o %D %S';
$makeindex = 'upmendex %O -o %D %S';
$pdf_mode = 3;
```
```
$ docker run --rm -it -v $PWD:/workdir example/texlive-ja:latest \
    sh -c 'latexmk -C thesis.tex && latexmk thesis.tex && latexmk -c thesis.tex'

```

# イメージを拡張する
paperist/texlive-ja には、最小限のパッケージしかインストールされていません

もし、paperist/texlive-ja 内臓のパッケージだけでは足りない場合、自分で Docker イメージを拡張できます

tlmgr で任意のパッケージをインストールするには、次のように Dockerfile を作成して、任意のイメージ名でビルドします

```
FROM paperist/texlive-ja:latest
# XeTeX をインストールする場合の例
RUN apt-get update \
  && apt-get install -y \
    libfontconfig1 \
  && rm -rf /var/lib/apt/lists/*
RUN tlmgr install collection-xetex ctex
$ docker build -t example/texlive-ja:latest .
$ docker run --rm -it -v $PWD:/workdir example/texlive-ja:latest \
    sh -c 'xelatex main.tex'
```


## VSCode LaTeX Workshop で使う
paperist/texlive-ja は、LaTeX Workshop で使えます

「latexmk を使う」を参考に latexmkrc を用意したあと、次のように VSCode の設定を書き換えます
```
{
  "latex-workshop.docker.enabled": true,
  "latex-workshop.docker.image.latex": "example/texlive-ja:latest",
  "latex-workshop.latex.tools": [
    {
      "name": "latexmk",
      "command": "latexmk",
      "args": ["-gg", "%DOC%"]
    }
  ],
  "latex-workshop.latex.autoClean.run": "onBuilt"
}
```