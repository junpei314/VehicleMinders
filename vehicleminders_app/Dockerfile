FROM ruby:3.1
RUN mkdir /VehicleMinders
WORKDIR /VehicleMinders
COPY Gemfile /VehicleMinders/Gemfile
COPY Gemfile.lock /VehicleMinders/Gemfile.lock
RUN bundle install
COPY . /VehicleMinders

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
