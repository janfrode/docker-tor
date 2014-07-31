FROM fedora:latest
MAINTAINER Jan-Frode Myklebust <janfrode@tanso.net>

EXPOSE 9001

RUN groupadd -r toranon -g 9999
RUN useradd -r -u 9999 -g toranon -d /var/lib/tor -s /sbin/nologin toranon
RUN yum -y install tor findutils
RUN yum -y update
RUN yum clean all
# Drop all setuid setgid permissions:
RUN find /usr -perm /6000 -exec chmod -s '{}' \;

ADD ./torrc /etc/tor/torrc

# Generate a random nickname for the relay
RUN echo "Nickname JANFRODE0$(head -c 16 /dev/urandom  | sha1sum | cut -c1-10)" >> /etc/tor/torrc

CMD /usr/bin/tor -f /etc/tor/torrc
