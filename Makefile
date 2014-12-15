CONTROLLER=montana.local
default: help

RSYNC_EXCLUDE := $(RSYNC_EXCLUDE) \
	--exclude=.ruby-version \
	--exclude=.keep \
	--exclude=.git

rsync:
	rsync -avzL ./ oui@$(CONTROLLER):/home/oui/src/github.com/aocole/growingpanes/ $(RSYNC_EXCLUDE)

ssh: 
	ssh oui@$(CONTROLLER)
