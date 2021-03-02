# example: docker run net-monitor 
# example: docker run net-monitor azurecr.io
FROM alpine
ENTRYPOINT [ "/bin/ping", "-c", "3" ]
CMD ["localhost"]