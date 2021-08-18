# example: docker run net-monitor 
# example: docker run net-monitor azurecr.io
FROM debian
ENTRYPOINT [ "/bin/ping", "-c", "3" ]
CMD ["localhost"]