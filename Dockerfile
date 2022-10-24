FROM alpine
ARG SLEEP="30m"
ARG TEXT="Local net-monitor docker image text no arguments"
RUN echo $TEXT 'now sleeping for' $SLEEP 'at:' >message.txt
RUN echo $SLEEP >sleep.txt
CMD cat message.txt && date && sleep $(cat sleep.txt)