FROM dius/pact-broker

WORKDIR /home/app/pact_broker

# add the repository
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main" >> /etc/apt/sources.list.d/pgdg.list
RUN curl -o ACCC4CF8.asc https://www.postgresql.org/media/keys/ACCC4CF8.asc && apt-key add ACCC4CF8.asc
RUN apt-get update && apt-get install -y postgresql-client-11

RUN bundle install --no-deployment

RUN bundle add rack-mini-profiler && \
  bundle add flamegraph && \
  bundle add stackprof && \
  bundle add memory_profiler && \
  bundle install

COPY config.ru /home/app/pact_broker/config.ru
COPY restore.sh .
COPY pgdump .
COPY update_test_results.sql .

CMD ["/sbin/my_init"]
