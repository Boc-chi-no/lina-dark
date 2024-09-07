FROM jumpserver/web:dark-tag AS stage-path

COPY lina-dark/ /opt/lina/
COPY luna-dark/ /opt/luna/
RUN sed -i "s@<html lang=\"en\">@<html lang=\"en\" data-darkreader-scheme=\"dark\" style=\"background-color: rgb(41, 48, 48); color: rgb(178, 171, 158);\">@g" /opt/luna/index.html && \
    sed -i "s@<body>@<link rel=\"stylesheet\" href=\"dark.css\"><body>@g" /opt/luna/index.html

FROM jumpserver/web:dark-tag

COPY --from=stage-path /opt/ /opt/
