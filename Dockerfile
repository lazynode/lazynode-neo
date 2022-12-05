FROM mcr.microsoft.com/dotnet/sdk:6.0

RUN apt-get update && apt-get install -y libleveldb-dev sqlite3 libsqlite3-dev libunwind8-dev
RUN git clone --depth=1 -b v3.4.0 --single-branch https://github.com/neo-project/neo-node.git /tmp/neo-node
RUN git clone --depth=1 -b v3.4.0 --single-branch https://github.com/neo-project/neo.git /tmp/neo
RUN git clone --depth=1 -b v3.4.0 --single-branch https://github.com/neo-project/neo-modules.git /tmp/neo-modules
COPY neo.diff /tmp/neo.diff
RUN cd /tmp/neo && git apply /tmp/neo.diff
RUN cd /tmp/neo-node/neo-cli && dotnet remove package Neo && dotnet add reference /tmp/neo/src/Neo/Neo.csproj && dotnet publish -c Release -o /neo
RUN cd /tmp/neo-modules/src/LevelDBStore && dotnet build -c Release -o /neo/Plugins/LevelDBStore
RUN rm -rf /tmp/*

WORKDIR /workspace
CMD /neo/neo-cli
