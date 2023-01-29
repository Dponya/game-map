FROM codesimple/elm:0.19
WORKDIR ./app

WORKDIR ./client
CMD ["make",  "src/Main.elm", "--output=main.js"]
CMD ["reactor"]