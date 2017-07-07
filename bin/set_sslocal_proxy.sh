# Helper script for sourcing to have proxies set up.
# Ref: https://wiki.archlinux.org/index.php/proxy_settings#Environment_variables
export http_proxy=http://carlss-host.cw:1080/
export https_proxy=$http_proxy
export ftp_proxy=$http_proxy
export rsync_proxy=$http_proxy
export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com,.cw"
