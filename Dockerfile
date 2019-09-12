# base image elixer to start with
FROM elixir:1.4.2

# install hex package manager
RUN mix local.hex --force

# install rebar package manager
RUN mix local.rebar --force

# install the latest phoenix 
RUN mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez --force

# install node
RUN curl -sL https://deb.nodesource.com/setup_6.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN apt-get install nodejs

# create app folder
RUN mkdir /app
COPY ./acme_bank /app
    
WORKDIR /app

# install dependencies
RUN mix do deps.get, deps.compile


RUN cd apps/bank_web && npm install
RUN cd apps/backoffice && npm install

RUN mix compile

WORKDIR /app

# run phoenix in *dev* mode on port 4000
CMD mix phoenix.server


