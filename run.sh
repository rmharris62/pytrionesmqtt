#!/bin/bash
sudo docker run -dit --net host --privileged --cap-add=SYS_ADMIN --cap-add=NET_ADMIN --restart=unless-stopped --env-file secrets.list maclee/bttriones