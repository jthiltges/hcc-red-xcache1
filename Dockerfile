#FROM hub.opensciencegrid.org/opensciencegrid/cms-xcache:release
FROM hub.opensciencegrid.org/opensciencegrid/cms-xcache:release-20220102-0737 AS base

RUN yum --enablerepo=osg-upcoming-testing update -y \
        xrootd && \
    yum clean all --enablerepo=* && rm -rf /var/cache/

FROM base AS builder

RUN yum install -y --enablerepo=osg-upcoming-testing \
        cmake git gcc-c++ xrootd-client-devel && \
    git clone https://github.com/bbockelm/xrdcl-authz-plugin.git && \
    mkdir xrdcl-authz-plugin/build && \
    cd xrdcl-authz-plugin/build && \
    cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DLIB_INSTALL_DIR=lib64 && \
    make install

############
FROM base
LABEL maintainer Brian Bockelman <bbockelman@morgridge.org>

RUN sed -i /etc/xrootd/config.d/30-cms-xcache-authz.cfg -e 's|sec.protbind \* gsi||' && \
    mkdir /cache

COPY --from=builder /usr/lib64/xrdcl-authz-plugin/libXrdSecunix-5.so /usr/lib64/xrdcl-authz-plugin/libXrdSecunix-5.so
COPY config.d/*.cfg /etc/xrootd/config.d/
COPY scitokens.cfg /etc/xrootd/

EXPOSE 1094
