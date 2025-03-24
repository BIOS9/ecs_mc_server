FROM itzg/minecraft-server:java21
RUN apt-get update && apt-get install -y openssh-server supervisor
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 22 25565
CMD ["/usr/bin/supervisord"]