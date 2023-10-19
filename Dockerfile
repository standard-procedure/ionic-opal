FROM ruby:3.2.2-bookworm

RUN gem install bundler -N
WORKDIR /workspace

COPY Gemfile Gemfile.lock /workspace/
RUN bundle check || bundle install
COPY . /workspace

EXPOSE 3000

CMD bundle exec puma -t 8:32
