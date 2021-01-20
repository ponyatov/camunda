# \ <section:var>
MODULE       = $(notdir $(CURDIR))
OS           = $(shell uname -s)
MACHINE      = $(shell uname -m)
NOW          = $(shell date +%d%m%y)
REL          = $(shell git rev-parse --short=4 HEAD)
# / <section:var>
# \ <section:dir>
CWD          = $(CURDIR)
TMP          = $(CWD)/tmp
# / <section:dir>
# \ <section:tool>
WGET         = wget -c
# / <section:tool>

# \ <section:all>
.PHONY: all
all: modeler/VERSION bpmrun/README.txt

.PHONY: run
run: bpmrun/README.txt
	cd bpmrun ; sh start.sh

.PHONY: model
model: modeler/camunda-modeler
	cd modeler ; ./camunda-modeler


# / <section:all>

# \ <section:gz>

.PHONY: gz
gz: tmp/$(MODELER_GZ) tmp/$(BPMRUN_GZ)

MODELER_VER = 4.5.0
MODELER     = camunda-modeler-$(MODELER_VER)-linux-x64
MODELER_GZ  = $(MODELER).tar.gz
tmp/$(MODELER_GZ):
	$(WGET) -O $@ https://downloads.camunda.cloud/release/camunda-modeler/$(MODELER_VER)/$(MODELER_GZ)

BPMRUN_VER = 7.15
BPMRUN_REL = $(BPMRUN_VER).0-alpha2
BPMRUN     = camunda-bpm-run-$(BPMRUN_REL)
BPMRUN_GZ  = $(BPMRUN).tar.gz
tmp/$(BPMRUN_GZ):
	$(WGET) -O $@ https://downloads.camunda.cloud/release/camunda-bpm/run/$(BPMRUN_VER)/$(BPMRUN_GZ)

modeler/camunda-modeler:
	$(MAKE) gz
	tar zx < tmp/$(MODELER_GZ) ; mv $(MODELER) modeler ; git checkout modeler
	touch $@ ; chmod +x $@

bpmrun/README.txt:
	$(MAKE) gz
	cd bpmrun ; tar zx < ../tmp/$(BPMRUN_GZ)
	touch $@

# / <section:gz>

# \ <section:install>
.PHONY: install
install: $(OS)_install
	$(MAKE) camunda
.PHONY: update
update: $(OS)_update
.PHONY: Linux_install Linux_update
Linux_install Linux_update:
	sudo apt update
	sudo apt install -u `cat apt.txt`
# / <section:install>

