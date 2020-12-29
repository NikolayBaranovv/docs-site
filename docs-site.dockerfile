FROM klakegg/hugo:0.78.2 AS hugo

#COPY autoscan-docs/* /src/
COPY . /src/
WORKDIR /src
ENV HUGO_DESTINATION=/target
RUN hugo

FROM nginx
COPY --from=hugo /target/* /kyky/

CMD cp -r /kyky/* /output-folder/
