FROM ruby:3.1
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
apt-get install -y nodejs
ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN mkdir /VehicleMinders
WORKDIR /VehicleMinders
COPY Gemfile /VehicleMinders/Gemfile
COPY Gemfile.lock /VehicleMinders/Gemfile.lock
RUN bundle install
COPY . /VehicleMinders

COPY entrypoint.env.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.env.sh
ENTRYPOINT ["entrypoint.env.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
