# Pull base image
FROM balenalib/raspberry-pi:bullseye-run as builder

# Install dependencies
RUN apt-get update && apt-get install -y \
    vim \
    python3 \
    python3-dev \
    python3-pip \
    python3-virtualenv \
    python3-wheel \
    gcc \
    build-essential \
    libglib2.0-dev \
    bluez \
    libbluetooth-dev \
    libboost-python-dev \
    git \ 
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/IanHarvey/bluepy.git
RUN cd bluepy && python3 setup.py build && sudo python3 setup.py install

FROM balenalib/raspberry-pi:bullseye-run as runner
RUN apt-get update && apt-get install -y \
    vim \
    python3 \
    python3-pip \
    python3-virtualenv \
    python3-wheel \
    bluez \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install paho-mqtt
COPY --from=builder /usr/local/lib/python3.9/dist-packages/bluepy-1.3.0-py3.9.egg /usr/local/lib/python3.9/dist-packages/bluepy-1.3.0-py3.9.egg
COPY --from=builder /usr/local/lib/python3.9/dist-packages/easy-install.pth /usr/local/lib/python3.9/dist-packages/easy-install.pth

RUN mkdir /app

## We copy everything in the root directory
## into our /app directory
ADD ./bttriones.py /app

# Define working directory
WORKDIR /app

# Define default command
CMD ["./bttriones.py"]
