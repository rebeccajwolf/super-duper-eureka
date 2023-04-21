FROM debian:stable-slim

# Set default environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ="America/New_York"
ENV PYTHONUNBUFFERED=1

# Create working directory and relevant dirs
WORKDIR /app
RUN chmod 777 /app

RUN apt-get update && apt-get install -y \
  tzdata \
  procps \
  cron \
  wget \
  gpg \
  python3 \
  python3-pip \
  xvfb \
  xfonts-cyrillic \
  xfonts-100dpi \
  xfonts-75dpi \
  xfonts-base \
  xfonts-scalable \
  gtk2-engines-pixbuf \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /etc/cron.*/*

  
RUN ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

# Download and install Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \ 
    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list
RUN apt-get update && apt-get -y install google-chrome-stable && rm -rf /var/lib/apt/lists/*

RUN pip install -U pip


# Add often-changed files in order to cache above
COPY . .

RUN pip3 install --no-cache-dir -r requirements.txt


COPY crontab /etc/cron.d/crontab

RUN chmod 0644 /etc/cron.d/crontab

RUN crontab /etc/cron.d/crontab


# Make the entrypoint executable
RUN chmod +x entrypoint.sh

# Set the entrypoint to our entrypoint.sh

CMD ["bash", "/app/entrypoint.sh"]

#END