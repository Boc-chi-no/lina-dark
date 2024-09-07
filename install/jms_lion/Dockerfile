FROM jumpserver/lion:dark-tag AS stage-path

COPY lion-dark/ /opt/lion/ui/dist/assets/css/
RUN sed -i "s@<html lang=\"\">@<html lang=\"\" data-darkreader-scheme=\"dark\" style=\"background-color: rgb(20, 22, 24); color: rgb(178, 171, 158);\">@g" /opt/lion/ui/dist/index.html && \
    sed -i "s@<title>Lion</title>@<title>Lion</title><link rel=\"stylesheet\" href=\"/lion/assets/css/dark.css\">@g" /opt/lion/ui/dist/index.html && \
    sed -i "s/#1f1b1b/#141618/g" `grep -rl "#1f1b1b" /opt/lion/ui/dist/assets/css`

FROM jumpserver/lion:dark-tag

COPY --from=stage-path /opt/lion/ui /opt/lion/ui
