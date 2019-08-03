#!/bin/bash

docker build -t webservertest .

docker run -p 80:80 -p 443:443 -it webservertest
