FROM python:3.9-alpine

WORKDIR /app/

COPY ./requirements.txt /opt/requirements.txt

RUN apk add --no-cache curl jq git bash zip 7zip && \
rm -rf /var/cache/apk/*

RUN pip install --no-cache-dir -r /opt/requirements.txt

CMD ["bash"]
