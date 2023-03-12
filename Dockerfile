FROM public.ecr.aws/sam/build-python3.9:latest-arm64

RUN cd && \
    python3.9 -m venv env && \
    source env/bin/activate && \
    pip install --upgrade pip && \
    pip install Pillow && \
    pip install pyzbar && \
    pip freeze > requirements.txt && \
    yum install -y ImageMagick-devel ImageMagick wget && \
    cd && mkdir zbar && cd zbar && \
    wget https://github.com/mchehab/zbar/archive/refs/tags/0.23.90.tar.gz && \
    tar -zxvf 0.23.90.tar.gz && \
    cd zbar-0.23.90 && \
    autoreconf -vfi && \
    ./configure --prefix=/root/env && \
    make && \
    make install && \
    deactivate

RUN cd && mkdir /opt/lib && \
    cp -pa env/lib/libzbar.* env/lib/pkgconfig /opt/lib/

#RUN cd && cd env/lib/python3.9/site-packages && \
#    zip -r ../../../../pyzbar.zip . && \
#    cd && cd env/lib && \
#    zip -gr ../../pyzbar.zip libzbar.* pkgconfig

RUN cd && mkdir python && \
    cp -pa env/lib/python3.9/site-packages/* python/ && \
    zip -ry pyzbar_layer.zip python && \
    cd && mkdir lib && \
    cp -pa env/lib/libzbar.* env/lib/pkgconfig lib/ && \
    zip -gry pyzbar_layer.zip lib