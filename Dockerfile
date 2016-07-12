
# This is a Dockerfile that extends an installation of itk and modules
#in the dsarchive/histomicstk:v0.1.3 


FROM dsarchive/histomicstk:v0.1.3

MAINTAINER Bilal Salam <bilal.salam@kitware.com>


RUN apt-get update && \
    apt-get install -y git wget python-qt4 \
    openslide-tools python-openslide \
    build-essential \
    swig \
    make \
    zlib1g-dev \
    curl \
    libcurl4-openssl-dev \
     libexpat1-dev \
    unzip  \
    cmake && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#install requirements for itk


WORKDIR /

#ITK dependencies

RUN mkdir ninja && \ 
cd ninja && \
wget https://github.com/ninja-build/ninja/releases/download/v1.7.1/ninja-linux.zip && \
unzip ninja-linux.zip && \
ln -s $(pwd)/ninja /usr/bin/ninja  


WORKDIR /
#need to get the latest tag of master branch in ITK
# v4.10.0 = 95291c32dc0162d688b242deea2b059dac58754a
RUN git clone https://github.com/InsightSoftwareConsortium/ITK.git &&
cd  ITK && \
git checkout $(git describe --abbrev=0 --tags) && \
cd .. && \
mkdir ITKbuild && \
cd ITKbuild && \
cmake \
-G Ninja \
-DBUILD_EXAMPLES:BOOL=OFF \
-DBUILD_TESTING:BOOL=OFF \
-DBUILD_SHARED_LIBS:BOOL=ON \
-DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=ON \
-DITK_LEGACY_REMOVE:BOOL=ON \
-DITK_BUILD_DEFAULT_MODULES:BOOL=OFF \
-DITK_USE_SYSTEM_LIBRARIES:BOOL=ON \
-DModule_ITKIOImageBase:BOOL=ON \
-DModule_ITKSmoothing:BOOL=ON \
-DModule_ITKTestKernel:BOOL=ON \
-DCMAKE_INSTALL_PREFIX:PATH=/build/miniconda \
-DITK_WRAP_PYTHON=ON \
-DPYTHON_INCLUDE_DIR:FILEPATH=/build/miniconda/include/python2.7 \
-DPYTHON_LIBRARY:FILEPATH=/build/miniconda/lib/libpython2.7.so \
-DPYTHON_EXECUTABLE:FILEPATH=/build/miniconda/bin/python \
-DBUILD_EXAMPLES:BOOL=OFF -DBUILD_TESTING:BOOL=OFF ../ITK && ninja \
&& ninja install && \
 rm -rf /ITKbuild /ITK


ENV my_plugin_path=$htk_path/../my_plugin
RUN mkdir -p $my_plugin_path
COPY . $my_plugin_path
WORKDIR $my_plugin_path


# use entrypoint provided by HistomicsTK
ENTRYPOINT["/build/miniconda/bin/python" ,"/HistomicsTK/server/cli_list_entrypoint.py"] 

