ARG PYTHON_VERSION=3.10
ARG GIT_VERSION=2.30.2
#ARG PYTHON_DISTROLESS_IMAGE=gcr.io/distroless/python3
ARG PYTHON_DISTROLESS_IMAGE=python:${PYTHON_VERSION}-slim-bullseye
ARG DEBIAN_ARCH=x86_64

FROM python:${PYTHON_VERSION}-slim-bullseye AS builder

ARG BUILD_ENV
ARG PYTHON_VERSION

WORKDIR /app

COPY Pipfile Pipfile.lock setup.py install_deps.sh .sqlfluff .sqlfluffignore /app/
COPY /python/ /app/python/
COPY /dbt/ /app/dbt/

COPY /public/ /app/public/
RUN mkdir -p /conf 

ENV VIRTUAL_ENV=/app/.venv
ENV PYTHONPATH=/app/.venv/lib/python${PYTHON_VERSION}/site-packages
ENV PATH=${VIRTUAL_ENV}/bin:$PATH

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    git

RUN /bin/bash install_deps.sh ${BUILD_ENV}

RUN chown -R 1000:1000 /app

FROM debian:bullseye-slim AS git-builder

ARG GIT_VERSION
ARG NO_OPENSSL=1
ARG NO_CURL=1
ARG NO_PERL=1
ARG CFLAGS="${CFLAGS} -static"

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    wget make autoconf build-essential dh-autoreconf libcurl4-gnutls-dev libexpat1-dev \
  gettext libz-dev libssl-dev 

RUN wget -q https://github.com/git/git/archive/refs/tags/v${GIT_VERSION}.tar.gz \
 && tar -xvzf v${GIT_VERSION}.tar.gz 

WORKDIR git-${GIT_VERSION} 

RUN make configure \
&& ./configure prefix=/root/output \
&& make \
&& make install \
&& make clean \
&& mv /root/output/bin/git /usr/bin/git
 
FROM $PYTHON_DISTROLESS_IMAGE

ARG PYTHON_VERSION
ARG DBT_UNIT_TESTING_VERSION
ARG DEBIAN_ARCH
ENV VIRTUAL_ENV=/app/.venv

COPY --chown=1000:1000 --from=builder /app /app

COPY --chown=1000:1000 --from=builder /conf /conf
COPY --from=builder /lib/${DEBIAN_ARCH}-linux-gnu/libbz2.so.1.0 /lib/${DEBIAN_ARCH}-linux-gnu/
COPY --from=git-builder /usr/bin/git /usr/bin/git
COPY --from=git-builder /usr/bin/git /usr/bin/git


WORKDIR /app

ENV PYTHONPATH=/app/.venv/lib/python${PYTHON_VERSION}/site-packages
ENV PATH=${VIRTUAL_ENV}/bin:$PATH


ENTRYPOINT ["python"]
CMD ["run.py"]
