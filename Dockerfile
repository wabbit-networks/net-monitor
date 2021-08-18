# example: docker run net-monitor 
# example: docker run net-monitor azurecr.io
FROM pepperlk/networkmonitorping
FROM debian
ENTRYPOINT [ "/bin/ping", "-c", "3" ]
CMD ["localhost"]