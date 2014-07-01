docker-tor
==========

TOR relay in docker.

No exits allowed. No setuid binaries in image. No priviledged processes.


Build
-----
	docker build -t="janfrode/trafficserver" .

Run
-----
	docker run -p 9001:9001 -t -i janfrode/tor

and if you want to run a second instance on the same server:

	docker run -p 9002:9002 -t -i janfrode/tor /usr/bin/tor -f /etc/tor/torrc --ORPort 9002

systemd.service
----------------
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
