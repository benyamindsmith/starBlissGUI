# starBlissGUI

A GUI for the starBliss package made with RShiny. Check it out on ShinyApps.io [here](https://benyamindsmith.shinyapps.io/starBlissGUI/) or build the Docker Image with the [instructions below](https://github.com/benyamindsmith/starBlissGUI#building-the-docker-image)!

![image](https://user-images.githubusercontent.com/46410142/224387785-553a101d-b722-494c-b7a6-1dada177ee74.png)

## Dependencies

This Shiny App depends on the following packages.

* [`starBliss`](https://github.com/benyamindsmith/starBliss)

* [`ggplot2`](https://ggplot2.tidyverse.org)

* [`lubridate`](https://lubridate.tidyverse.org)

* [`shiny`](https://shiny.rstudio.com)

* [`shinyWidgets`](https://github.com/dreamRs/shinyWidgets)


## Building the Docker Image

To build the docker image simply run:

```
docker build -t starblissgui .
```

To run docker container: 

```
docker run -p 3838:3838 starblissgui

```

