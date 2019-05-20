FROM ubuntu:17.10
# Build software in the /root directory.
WORKDIR /root
# Set this so apt-utils does not complain about "unable to initialize frontend: Dialog".
ARG DEBIAN_FRONTEND=noninteractive

# Install apt-utils to avoid package confiiguration warnings later.
RUN apt-get update &&  apt-get install -y --no-install-recommends apt-utils
RUN apt-get install -y python 
RUN apt-get install -y python-pip

#Install CURL for testing
RUN apt-get install -y curl
# Install app dependencies
RUN pip install --upgrade pip

#Install virtual env
RUN pip install virtualenv

#CREATE PROJECT DIRECTORY
RUN mkdir books
RUN cd books

#Update the working directory
WORKDIR /root/books
#Create virtual env
RUN virtualenv env
# Put ycsb.py into the image.
ADD requirements.txt /root/books

#Install all requirements
RUN pip install -r requirements.txt

# Add Project files
ADD templates /root/books/templates
ADD app.py /root/books
ADD config.py /root/books
ADD manage.py /root/books
ADD models.py /root/books


#EXPORT VARIABLES
#ENV APP_SETTINGS config.DevelopmentConfig
#ENV DATABASE_URL postgres://ibm_cloud_a68d959e_f4f5_4a34_a2dc_7b240e7b8c5e:394e37ffc430d46f5fbd61466934e132fdc54884701c8885f0976b180e7e9ccc@0fbcb2ce-4b6f-443e-a843-67be7553646b.8f7bfd8f3faa4218aec56e069eb46187.databases.appdomain.cloud:30568/test

# Add the netry point script
ADD docker-entrypoint.sh /root/books
RUN chmod +x /root/books/docker-entrypoint.sh

ENTRYPOINT ["/root/books/docker-entrypoint.sh"]
#ENTRYPOINT python -u manage.py runserver --host 0.0.0.0
#CMD tail -f /dev/null