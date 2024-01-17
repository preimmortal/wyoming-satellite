FROM python:3.11-slim-bookworm

ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install --yes --no-install-recommends avahi-utils alsa-utils


WORKDIR /app

COPY sounds/ ./sounds/
COPY script/setup ./script/
COPY setup.py requirements.txt requirements_vad.txt requirements_audio_enhancement.txt MANIFEST.in ./
COPY wyoming_satellite/ ./wyoming_satellite/

RUN script/setup
RUN .venv/bin/pip3 install --upgrade pip
RUN .venv/bin/pip3 install --upgrade --upgrade wheel setuptools
RUN .venv/bin/pip3 install -f 'https://synesthesiam.github.io/prebuilt-apps/' -r requirements.txt -r requirements_vad.txt -r requirements_audio_enhancement.txt

COPY script/run ./script/
COPY docker/run ./

EXPOSE 10700

ENTRYPOINT ["/app/run"]
