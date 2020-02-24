FROM python:2.7
# install your dependencies
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt upgrade -y && apt install \
    postgresql -y
RUN pip install psycopg2
RUN pip install awscli

# Add sample application
COPY application.py /tmp/application.py
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
RUN mkdir /tmp/sample-app

EXPOSE 3000

# Run it
ENTRYPOINT ["sh","/entrypoint.sh"]

CMD ["python","/tmp/application.py"]
