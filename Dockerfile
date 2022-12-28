FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

COPY neo.diff /tmp/neo.diff

RUN git clone --depth=1 -b v3.5.0 --single-branch https://github.com/neo-project/neo-node.git /tmp/neo-node
RUN git clone --depth=1 -b v3.5.0 --single-branch https://github.com/neo-project/neo.git /tmp/neo
RUN git clone --depth=1 -b v3.5.0 --single-branch https://github.com/neo-project/neo-modules.git /tmp/neo-modules
RUN cd /tmp/neo && git apply /tmp/neo.diff
RUN cd /tmp/neo-node/neo-cli && dotnet remove package Neo && dotnet add reference /tmp/neo/src/Neo/Neo.csproj && dotnet publish --use-current-runtime -c Release -o /neo
RUN cd /tmp/neo-modules/src/LevelDBStore && dotnet build -c Release -o /neo/Plugins/LevelDBStore -p:PublishSingleFile=true


FROM gcc:9.5.0 as leveldb_build

RUN apt-get update && apt-get install -y cmake build-essential
RUN wget -O leveldb-src.tar.gz https://github.com/google/leveldb/archive/1.23.tar.gz
RUN tar -zxf leveldb-src.tar.gz
RUN cd /leveldb-1.23 && mkdir build && cd build \
    && cmake .. -DLEVELDB_BUILD_TESTS=OFF -DLEVELDB_BUILD_BENCHMARKS=OFF -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON -DCMAKE_INSTALL_RPATH=/tmp/test -DBUILD_SHARED_LIBS=ON && make install

FROM mcr.microsoft.com/dotnet/nightly/runtime-deps:6.0-jammy-chiseled

COPY --from=build /neo /neo
COPY --from=leveldb_build /leveldb-1.23/build/libleveldb.so /lib/

WORKDIR /workspace
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
ENTRYPOINT [ "/neo/neo-cli" ]
