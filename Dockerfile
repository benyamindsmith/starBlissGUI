FROM rocker/shiny:latest

RUN apt-get update && apt-get install -y \
    libssl-dev \
    libcurl4-gnutls-dev \
    libxml2-dev \
    libudunits2-dev \
    libgdal-dev

RUN R -e 'install.packages(c("shiny","shinyWidgets","ggplot2","lubridate", "remotes"))'
RUN R -e 'remotes::install_github("benyamindsmith/starBliss")'

COPY app.R /srv/shiny-server/
COPY www /srv/shiny-server/www

EXPOSE 3838

CMD ["R", "-e", "shiny::runApp('/srv/shiny-server/',, host='0.0.0.0', port=3838)"]
