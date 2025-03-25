FROM itzg/minecraft-server:java21
RUN apt-get update && apt-get install -y openssh-server supervisor neovim
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
RUN echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
RUN mkdir -p /var/log/supervisor
RUN mkdir /run/sshd
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 22 25565
ENTRYPOINT  ["/usr/bin/supervisord"]
