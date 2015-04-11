# Makefile for creating well structured debian and ubuntu package
# vim:set ts=4 sw=4 sts=4 noexpandtab

NAME=rkt
VERSION=0.5.3
TARBALL=$(NAME)-v$(VERSION).tar.gz
TARDIR=$(NAME)-v$(VERSION)
DOWNLOAD=https://github.com/coreos/$(NAME)/releases/download/v$(VERSION)/$(TARBALL)
DESCRIPTION=A highly-available key value store for shared configuration and service discovery

# Invoke this script with the ITERATION env var already set to provide your own
ITERATION ?= custom1

.PHONY: default
default: deb
package: deb

$(TARBALL):
	wget -nv --progress=bar -c -O $(TARBALL) $(DOWNLOAD)

$(TARDIR): $(TARBALL)
	tar xzf $(TARBALL)

rkt_$(VERSION)_amd64.deb: $(TARDIR)
	fpm -s dir -t deb -C $(TARDIR) \
		--name $(NAME) \
		--version $(VERSION) \
		--iteration $(ITERATION) \
		--architecture amd64 \
		--prefix=/usr/bin \
		--url "https://github.com/coreos/rkt" \
		--description "$(DESCRIPTION)" \
		--deb-user root --deb-group root \
		--post-install debian/postinst \
		.

rkt_$(VERSION)_amd64.rpm: $(TARDIR)
	cd $(TARDIR)/ && \
	fpm -s dir -t rpm -v $(VERSION) -n $(NAME) -a amd64 \
		--prefix=/usr/bin \
		--description "$(DESCRIPTION)" \
		--url "https://github.com/coreos/rkt" \
		.
	mv *.rpm ..

.PHONY: clean
clean:
	rm -rf $(TARDIR)
	rm -rf *.deb
	rm -rf *.rpm

.PHONY: deb
deb: $(NAME)_$(VERSION)_amd64.deb

.PHONY: rpm
rpm: $(NAME)_$(VERSION)_amd64.rpm
