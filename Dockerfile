FROM debian:bullseye-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates gnupg dirmngr wget \
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
    && echo "deb http://download.mono-project.com/repo/debian stable-buster main" > /etc/apt/sources.list.d/mono-official-stable.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        mono-runtime \
        ca-certificates-mono \
        libmono-i18n4.0-all \
        libmono-system-runtime-serialization4.0-cil \
    && cert-sync --user /etc/ssl/certs/ca-certificates.crt \
    && rm -rf /var/lib/apt/lists/*

ARG OVM_VERSION=v1.0.0-RC16
RUN wget -q https://github.com/oscript-library/ovm/releases/download/${OVM_VERSION}/ovm.exe \
        -O /usr/local/bin/ovm.exe \
    && echo 'mono /usr/local/bin/ovm.exe "$@"' > /usr/local/bin/ovm \
    && chmod +x /usr/local/bin/ovm \
    && ovm use --install stable

ENV OSCRIPTBIN=/root/.local/share/ovm/current/bin
ENV PATH="$OSCRIPTBIN:$PATH"

RUN opm install opm \
    && opm update --all \
    && opm install autumn autumn-data winow markdown github messenger tempfiles fs strings logos

COPY src /app
WORKDIR /app
RUN opm install -l

EXPOSE 5000

CMD ["oscript", "main.os"]
