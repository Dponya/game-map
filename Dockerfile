FROM codesimple/elm:0.19
COPY ./client ./app

WORKDIR ./app

RUN elm make src/Main.elm --output=main.js
CMD ["reactor"]