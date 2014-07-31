# docker-tor
---

TOR relay in docker.

No exits allowed. No setuid binaries in image. No priviledged processes.


### Build
---
	docker build -t="janfrode/trafficserver" .

### Run
---
	docker run -p 9001:9001 -t -i janfrode/tor

and if you want to run a second instance on the same server:

	docker run -p 9002:9002 -t -i janfrode/tor /usr/bin/tor -f /etc/tor/torrc --ORPort 9002

### systemd.service
---
Create /etc/systemd/system/docker-tor.service containing:

	[Unit]
	Description=TOR in docker
	After=docker.service
	Requires=docker.service

	[Service]
	Restart=always
	ExecStart=/usr/bin/docker run  --rm=true -p 9001:9001 janfrode/tor

	[Install]
	WantedBy=multi-user.target
 
and execute:

	systemctl daemon-reload
	systemctl enable docker-tor
	systemctl start docker-tor

### Persistent data
---
To keep the tor relay's data persistent, one can run f.ex.:

	semanage fcontext -a -t docker_var_lib_t "/srv/docker(/.*)?"
	mkdir -p /srv/docker/tor/var_lib_docker
	chown 9999 /srv/docker/tor/var_lib_docker
	cat <<EOF > /srv/docker/tor/torrc
	DataDirectory /var/lib/tor
	User toranon
	Log notice stdout
	ExitPolicy reject *:*
	ORPort 9001
	Nickname JANFRODE09001
	ContactInfo 4096R/3D04EAE7 Jan-Frode Myklebust <janfrode@tanso.net>
	EOF
	restorecon -rv /srv/docker

and start the container with:

	/usr/bin/docker run  --rm=true -v /srv/docker/tor/var_lib_tor:/var/lib/tor -v /srv/docker/tor/torrc:/etc/tor/torrc -p 9001:9001 janfrode/tor


