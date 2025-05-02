FROM ubuntu:20.04

ENV DEFAULT_LOCALE=en_US \
	NGINX_VERSION=stable

# Surpress Upstart errors/warning
RUN dpkg-divert --local --rename --add /sbin/initctl && \
	ln -sf /bin/true /sbin/initctl
	# Setup default locale
	
RUN apt-get update && \
	apt-get install -y locales && \
	locale-gen ${DEFAULT_LOCALE}.UTF-8 && \
	update-locale LC_ALL=${DEFAULT_LOCALE}.UTF-8 && \
	export LANG=${DEFAULT_LOCALE}.UTF-8 && \
	#apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C / 4AD4CAB6 && \
	apt-get update -y && \
	apt-get upgrade -y && \
	apt-get install -y software-properties-common  && \
	BUILD_PACKAGES="pwgen sudo cron wget" && \
	apt-get -y install $BUILD_PACKAGES

RUN echo 'Installing Postgres 9.1' && \
	wget -O /etc/apt/sources.list.d/pgdg.list http://apt.postgresql.org/pub/repos/apt/pool/main/pgdg.list && \
	apt-key add --keyserver keyserver.ubuntu.com --key 4041C04B && \
	apt-get update && \
	apt install postgresql-9.1

RUN echo 'Setting up Postgres 9.1' && \
	systemctl start postgresql-9.1 && \
	systemctl enable postgresql-9.1 && \
	systemctl status postgresql-9.1

#do some system cleanup
RUN apt-get remove --purge -y software-properties-common && \
	apt-get autoremove -y && \
	apt-get clean && \
	apt-get autoclean && \
	echo -n > /var/lib/apt/extended_states && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /usr/share/man/?? && \
	rm -rf /usr/share/man/??_* && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Expose Ports
EXPOSE 5432

ENTRYPOINT ["/bin/bash", "/cmd.sh"]
