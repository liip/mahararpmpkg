# symbols
VERSION  = $(shell git describe --abbrev=0 | sed 's/^v//' | sed 's/-/./g')
RELEASE  = 1
COMMITID = $(shell git rev-parse HEAD)
ARCH     = noarch

NV      = $(PKGNAME)-$(VERSION)
NVR     = $(NV)-$(RELEASE)
DISTVER = 2.0

# rpm target directory
BUILDDIR = /tmp/$(PKGNAME)-build
TARBALL  = $(BUILDDIR)/SOURCES/$(NV).tar.gz
SPECIN     = $(BUILDDIR)/SPECS/$(PKGNAME).spec.in
SPEC     = $(BUILDDIR)/SPECS/$(PKGNAME).spec
SRPM     = $(BUILDDIR)/SRPMS/$(NVR).$(DISTVER).src.rpm
RPM      = $(BUILDDIR)/RPMS/$(ARCH)/$(NVR).$(DISTVER).$(ARCH).rpm
TMP      = $(BUILDDIR)/TMP

RPMBUILD = rpmbuild \
	--define "_topdir $(BUILDDIR)" \
	--define "dist .$(DISTVER)"

SOURCES: $(TARBALL)
$(TARBALL):
	mkdir -p $(BUILDDIR)/BUILD $(BUILDDIR)/RPMS \
	$(BUILDDIR)/SOURCES $(BUILDDIR)/SRPMS
	mkdir -p $(TMP)/$(NV)
	/bin/bash ./rpm/git-arch.sh $(TMP) $(NV)
	echo $(VERSION) > $(TMP)/$(NV)/build-version
	tar -rf $(TMP)/$(NV).tar $(TMP)/$(NV)/build-version
	gzip $(TMP)/$(NV).tar
	mv $(TMP)/$(NV).tar.gz $(BUILDDIR)/SOURCES/
	rm -fr $(TMP)/$(NV)

SRPM: $(SRPM)
$(SRPM): mahara-site.spec SOURCES
	$(RPMBUILD) -bs --nodeps $(SPEC)


mahara-site.spec: rpm/mahara-site.spec.in
	mkdir -p $(BUILDDIR)/SPECS
	sed -e 's:@PKGNAME@:$(PKGNAME):g' \
		-e 's:@VERSION@:$(VERSION):g' \
		-e 's:@RELEASE@:$(RELEASE):g' \
		-e 's:@COMMITID@:$(COMMITID):g' \
		< $< > $(SPEC)
	cat changelog >> $(SPEC)

RPM: $(RPM)
$(RPM): SRPM
	$(RPMBUILD) --rebuild $(SRPM)
	rm -fr $(BUILDDIR)/BUILD/$(NV)

clean:
	rm -rf $(BUILDDIR)

# This forces a rebuild of xs-rsync.spec.in
.PHONY: mahara-site.spec
