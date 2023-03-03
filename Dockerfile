#FROM hub.opensciencegrid.org/opensciencegrid/cms-xcache:release
FROM hub.opensciencegrid.org/opensciencegrid/cms-xcache:3.6-release-20230302-2136

RUN sed -i /etc/xrootd/config.d/30-cms-xcache-authz.cfg -e 's|sec.protbind \* gsi||' && \
    mkdir /cache

COPY config.d/*.cfg /etc/xrootd/config.d/
COPY scitokens.cfg /etc/xrootd/

EXPOSE 1094
