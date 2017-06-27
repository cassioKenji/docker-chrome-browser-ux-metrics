FROM krallin/ubuntu-tini:xenial
LABEL name="chrome-headless ux" \
      maintainer="cassioKenji" \
      version="0.1a" \
      description="chrome headless + lighthouse"

RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    --no-install-recommends \
  && curl -sSL https://deb.nodesource.com/setup_6.x | bash - \
  && curl -sSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
  && apt-get update && apt-get install -y \
    google-chrome-stable \
    nodejs \
    --no-install-recommends \
  && apt-get install -y git \
  && npm --global install yarn \
  && npm install -g GoogleChrome/lighthouse

RUN apt-get install -y ruby \
  && chmod -x /usr/bin/google-chrome \
  && chmod -R 777 /opt/google/chrome && chmod 4755 /opt/google/chrome/chrome-sandbox
RUN yarn global add lighthouse

RUN groupadd -r chrome && useradd -r -g chrome -G audio,video chrome \
    && mkdir -p /home/chrome/reports && chown -R chrome:chrome /home/chrome

# some place to work :)
VOLUME /home/chrome/reports
WORKDIR /home/chrome/reports

# locale
RUN apt-get clean && apt-get update \
  && apt-get install locales \
  && locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

ADD lighthouse_ruby.rb /home/chrome/reports/lighthouse_ruby.rb
RUN chmod +x lighthouse_ruby.rb

CMD ["/bin/bash"]